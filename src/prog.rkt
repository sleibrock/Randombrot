#lang racket

;; Required for bitmap drawing
(require racket/draw)

(provide 
  the-functions
  random-function
  random-complex
  randomp
  iterate
  make-fractal
  random-fractal
  main)

(define target-width  1024) ; 1080p gets resized to 1024x576 
(define target-height  576)
(define magnification  1.0)
(define x-scale  (/ 3.0 magnification))
(define y-scale  (/ 2.5 magnification))
(define x-offset 2.25)
(define y-offset 1.25)
(define sleep-time 1800) ; sleep for half an hour
(define max-iter 300)
(define rand-scale 1.0)

(define file-output-path "output.png")

(define the-functions 
  (vector		
    (λ (z c) (+ c (expt z 2)))		
    (λ (z c) (+ c (expt z 3)))		
    (λ (z c) (+ c z (expt z 2)))
    (λ (z c) (+ c (exp z)))		
    (λ (z c) (+ c (exp (expt z 2))))		
    (λ (z c) (+ c (exp (expt z 3))))
    (λ (z c) (+ c (exp (expt z 4))))
    (λ (z c) (+ c (exp (expt z 5))))
    (λ (z c) (+ c (exp (expt z 6))))
    (λ (z c) (+ c (exp (expt z 7))))
    (λ (z c) (+ c (* (expt z 2) (exp z))))
    (λ (z c) (+ c (sin (expt z 2))))
    (λ (z c) (+ c (tan (expt z 2))))
    ))

;; Pull a random function from the list; 5% chance of a randomly composed one
(define (random-function)
  (if (> 0.05 (random))
    (λ (z c)
       (define left  (random-function))
       (define right (random-function))
       (* (left z c) (right z c)))
    (vector-ref the-functions (random (vector-length the-functions)))))

;; Random range function for older Racket versions
(define (randomp low high)
  (inexact->exact (round (+ low (* (random) (- high low))))))

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
(define (iterate f z c i)
  (define zp (f z c))
  (if (or (= i max-iter) (> (magnitude zp) 2))
    i
    (iterate f zp c (add1 i))))

;; Choose random values to use for the coloring function
(define (pick-numbers)
  (define lefty  (randomp 1 32))
  (define righty (abs (add1 (randomp 1 (- 32 lefty)))))
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
            (iterate fun cvar (make-rectangular real-x real-y) 0))
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
  (time (random-fractal))
  (when
    (4000 . > .  (file-size "output.png"))
    (displayln "Failed size check, restarting...")
    (main))
  (displayln "Uploading...")
  (system* "upload.py")
  (displayln "Sleeping... ( -ل͟-) Zzzzzzz")
  (sleep sleep-time)
  (main))

