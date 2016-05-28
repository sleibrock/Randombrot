#lang racket

;; Required for bitmap drawing
(require racket/draw)

(provide 
  randomp
  random-fractal
  main)

(define target-width  1920) ; gotta get that 1080p boi
(define target-height 1080)
(define magnification    1)
(define x-scale  (/ 3.0 magnification))
(define y-scale  (/ 3.0 magnification))
(define x-offset (/ x-scale 1.25))
(define y-offset (/ y-scale 2.0))
(define sleep-time 3600) ; sleep for an hour
(define max-iter 255)
(define rand-scale 2)

(define file-output-path "output.png")

;; Functions to pull from and use
(define the-functions
  (vector
    (λ (z c) (+ c (expt z 2)))
    (λ (z c) (+ c (expt z 3)))
    (λ (z c) (+ c (exp z)))
    (λ (z c) (+ c (exp (expt z 2))))
    (λ (z c) (+ c (exp (expt z 3))))
    (λ (z c) (+ c (* (expt z 2) (exp z))))
    (λ (z c) (+ c (sin z)))))

;; Random range function for older Racket versions
(define (randomp low high)
  (inexact->exact (round (+ low (* (random) (- high low))))))

;; Pull a random function
(define (random-function)
  (vector-ref the-functions (random (vector-length the-functions))))

;; Define a random complex function (yes I compressed it on purpose)
(define (random-complex)
  (apply make-rectangular
         (map (λ (p) (if (= 0 (random 2)) p (- p)))
              (map (λ (j) (* rand-scale (random))) (range 2))))) 

;; A color creation wrapper to constrain 0 <= x <= 255 on all nums given
(define (create-color a b c)
  (apply 
    (λ (x y z) (make-object color% x y z))
    (map (λ (w) (if (< w 0) 0 (if (> w 255) 255 w)))
         (list a b c))))

;; Process a function until it diverges or reaches maximum iteration (255)
(define (iterate f a z i)
  (define zp (f a z))
  (if (or (= i max-iter) (> (magnitude zp) 2))
    i
    (iterate f a zp (add1 i))))

;; Choose random values to use for the coloring function
(define (pick-numbers)
  (define lefty  (randomp 1 32))
  (define righty (randomp 1 (- 32 lefty)))
  (values lefty righty))

;; Create a color factory that has different modulos every creation
(define (color-factory)
  (define-values (a1 a2) (pick-numbers))
  (define-values (b1 b2) (pick-numbers))
  (define-values (c1 c2) (pick-numbers))
  (λ (i)
     (if (= i 255)
       (create-color 0 0 0)
       (create-color
         (* a1 (modulo i a2))
         (* b1 (modulo i b2))
         (* c1 (modulo i c2))))))

(define (make-fractal fun cvar wid hei fpath)
  (define target (make-bitmap wid hei))
  (define dc (new bitmap-dc% [bitmap target]))
  (define iter->color (color-factory))
  (for* ([x wid] [y hei])
    (define real-x (- (* x-scale (/ x wid)) x-offset))
    (define real-y (- (* y-scale (/ y hei)) y-offset))
    (send dc set-pen
          (iter->color
            (iterate fun (make-rectangular real-x real-y) cvar 0))
          1 'solid)
    (send dc draw-point x y))
  (send target save-file fpath 'png))

;; No-args fractal wrapper
(define (random-fractal)
  (make-fractal
    (random-function)
    (random-complex)
    target-width
    target-height
    file-output-path))

; Create a fractal, upload it by calling the upload function, sleep for 1 hour
(define (main)
  (displayln "Creating fractal...")
  (random-fractal)
  (if 
    (> 15000 (file-size file-output-path))
    (displayln "Fractal generated too small")
    (displayln "Restarting creation...")
    (main))
  (displayln "Uploading...")
  (system* "upload.py")
  (displayln "Sleeping... ( -ل͟-) Zzzzzzz")
  (sleep sleep-time)
  (main))

