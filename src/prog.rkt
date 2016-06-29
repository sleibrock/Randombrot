#lang racket

;; Required for bitmap drawing
(require racket/draw)

(provide 
 the-functions
 the-ops
 random-function
 random-complex
 randomp
 iterate
 make-fractal
 random-fractal
 main)

(define target-width   1024) ;; Twitter dimensions are 1024x576 
(define target-height  576)
(define magnification  1.0)  ;; depth level
(define x-scale        (/ 3.0 magnification)) ;; aspect ratio
(define y-scale        (/ 2.5 magnification))
(define x-offset       2.25) ;; offsetting the grid of the fractal
(define y-offset       1.25)
(define sleep-time     3600) ;; sleep for an hour
(define max-iter       250)  ;; max iteration depth
(define rand-scale     3.0)  ;; random complex scaling

;; target output path; if changing this, edit upload.py as well
(define file-output-path "output.png")

;; Core functions to render Mandelbrot sets
(define the-functions 
  (vector
   (list "z+c"          (λ (z c) (+ c z)))
   (list "z^2+c"        (λ (z c) (+ c (expt z 2))))
   (list "z^3+c"        (λ (z c) (+ c (expt z 3))))
   (list "z^2+z+c"      (λ (z c) (+ c z (expt z 2))))
   (list "z^0.5+c"      (λ (z c) (+ c (exp (expt z 0.5)))))
   (list "exp(z^2)+c"   (λ (z c) (+ c (exp (expt z 2)))))
   (list "exp(z^3)+c"   (λ (z c) (+ c (exp (expt z 3)))))
   (list "z^2*exp(z)+c" (λ (z c) (+ c (* (expt z 2) (exp z)))))
   (list "sin(z^2)+c"   (λ (z c) (+ c (sin (expt z 2)))))
   (list "cos(z^2)+c"   (λ (z c) (+ c (cos (expt z 2)))))
   (list "tan(z^2)+c"   (λ (z c) (+ c (tan (expt z 2)))))
   (list "sinh(z^2)+c"  (λ (z c) (+ c (sinh (expt z 2)))))
   (list "cosh(z^2)+c"  (λ (z c) (+ c (cosh (expt z 2)))))
   (list "tanh(z^2)+c"  (λ (z c) (+ c (tanh (expt z 2)))))
   (list "asin(z^2)+c"  (λ (z c) (+ c (asin (expt z 2)))))
   (list "acos(z^2)+c"  (λ (z c) (+ c (acos (expt z 2)))))
   (list "atan(z^2)+c"  (λ (z c) (+ c (atan (expt z 2)))))
   (list "exp(z^0.5)+c" (λ (z c) (+ c (exp (expt z -2.0)))))
   (list "log(z^2)+c"   (λ (z c) (+ c (log (expt z 2)))))
   ))

;; the operations to use to weave functions together
(define the-ops
  (vector
   (list "+" +)
   (list "-" -)
   (list "/" /)
   (list "*" *)))

;; Random range function for older Racket versions
(define (randomp low high)
  (inexact->exact (round (+ low (* (random) (- high low))))))

;; Get a random element from a vector (we're using this a lot)
(define (get-random-element vec)
  (vector-ref vec (random (vector-length vec))))

;; create a new function with a random op inbetween
;; aimed to replace the random-chance recursion factory
(define (random-function)
  (define left  (get-random-element the-functions))
  (define right (get-random-element the-functions))
  (define op    (get-random-element the-ops))
  (list
   (string-join(list "f(z) =" (first left) (first op) (first right)) " ")
   (λ (z c) ((second op) ((second left) z c) ((second right) z c)))))

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

;; Process a function until it diverges or reaches max-iter
(define (iterate f z c i)
  (define zp (f z c))
  (if (or (= i max-iter) (> (magnitude zp) 2))
    i
    (iterate f zp c (add1 i))))

;; Choose random values to use for the coloring function
;; TODO: create a better algorithm for picking color seeds
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

;; iterate through each pixel and generate a Mandelbrot set image
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

;; No-args fractal wrapper for the main function
(define (random-fractal rand-fun randc)
  (make-fractal
    rand-fun
    randc
    target-width
    target-height
    file-output-path))

;; Main procedure to create and upload fractals
(define (main)
  ;; Genesis block 
  (displayln "Picking a function... ")
  (define func (random-function)) ;; this is a pair (string . proc)
  (displayln (format "Got ~a" (first func)))
  (displayln "Generating a random number... ")
  (define randc (random-complex))
  (displayln (format "Got ~a" randc))
  (displayln "Creating fractal... (ง’̀-‘́)ง")
  (time (random-fractal (second func) randc))
  
  ;; emergency break-out block
  (when
    (4000 . > .  (file-size "output.png"))
    (displayln "Failed size check, restarting... ლ(ಠ益ಠლ)")
    (main))

  ;; upload block 
  (displayln "Uploading... (つ☯ᗜ☯)つ")
  (system* "upload.py" (string-append (first func) "; c=" randc))
  (displayln "Sleeping... ( -ل͟-) Zzzzzzz")

  ;; wait and go-again block
  (sleep sleep-time)
  (main))
;; end
