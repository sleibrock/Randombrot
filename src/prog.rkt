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
 main
 pfun
 pstr
 (struct-out proc))

(define target-width   1024) ;; Twitter dimensions are 1024x576 
(define target-height  576)
(define magnification  1.0)  ;; depth level
(define x-scale        (/ 3.0 magnification)) ;; aspect ratio
(define y-scale        (/ 2.5 magnification))
(define x-offset       2.25) ;; offsetting the grid of the fractal
(define y-offset       1.25)
(define sleep-time     3600) ;; sleep for an hour
(define max-iter       250)  ;; max iteration depth
(define comp-scale     3.0)  ;; random complex scaling
(define rand-scale     3.0)  ;; random amp scaling

;; target output path; if changing this, edit upload.py as well
(define file-output-path "output.png")

;; The core struct we will use throughtout the program
(struct proc (str fun))
(define pfun (lambda (p) (proc-fun p)))
(define pstr (lambda (p) (proc-str p)))

;; Core functions to render Mandelbrot sets
(define the-functions 
  (vector
   (proc "z+c"          (λ (z c) (+ c z)))
   (proc "z^0.5+c"      (λ (z c) (+ c (expt z 0.5))))
   (proc "z^2+c"        (λ (z c) (+ c (expt z 2))))
   (proc "z^3+c"        (λ (z c) (+ c (expt z 3))))
   (proc "z^4+c"        (λ (z c) (+ c (expt z 4))))
   (proc "z^5+c"        (λ (z c) (+ c (expt z 5))))
   (proc "z^6+c"        (λ (z c) (+ c (expt z 6))))
   (proc "z^7+c"        (λ (z c) (+ c (expt z 7))))
   (proc "z^8+c"        (λ (z c) (+ c (expt z 8))))
   (proc "z^2+z+c"      (λ (z c) (+ c z (expt z 2))))
   (proc "z^3+z+c"      (λ (z c) (+ c z (expt z 3))))
   (proc "z^0.5+c"      (λ (z c) (+ c (exp (expt z 0.5)))))
   (proc "exp(z^2)+c"   (λ (z c) (+ c (exp (expt z 2)))))
   (proc "exp(z^3)+c"   (λ (z c) (+ c (exp (expt z 3)))))
   (proc "z^2*exp(z)+c" (λ (z c) (+ c (* (expt z 2) (exp z)))))
   (proc "sin(z^2)+c"   (λ (z c) (+ c (sin (expt z 2)))))
   (proc "cos(z^2)+c"   (λ (z c) (+ c (cos (expt z 2)))))
   (proc "tan(z^2)+c"   (λ (z c) (+ c (tan (expt z 2)))))
   (proc "sinh(z^2)+c"  (λ (z c) (+ c (sinh (expt z 2)))))
   (proc "cosh(z^2)+c"  (λ (z c) (+ c (cosh (expt z 2)))))
   (proc "tanh(z^2)+c"  (λ (z c) (+ c (tanh (expt z 2)))))
   (proc "asin(z^2)+c"  (λ (z c) (+ c (asin (expt z 2)))))
   (proc "acos(z^2)+c"  (λ (z c) (+ c (acos (expt z 2)))))
   (proc "atan(z^2)+c"  (λ (z c) (+ c (atan (expt z 2)))))
   (proc "exp(z^0.5)+c" (λ (z c) (+ c (exp (expt z -2.0)))))
   (proc "log(z^2)+c"   (λ (z c) (+ c (log (expt z 2)))))
   (proc "z-c"          (λ (z c) (- c z)))
   (proc "z^0.5-c"      (λ (z c) (- c (expt z 0.5))))
   (proc "z^2-c"        (λ (z c) (- c (expt z 2))))
   (proc "z^3-c"        (λ (z c) (- c (expt z 3))))
   (proc "z^4-c"        (λ (z c) (- c (expt z 4))))
   (proc "z^5-c"        (λ (z c) (- c (expt z 5))))
   (proc "z^6-c"        (λ (z c) (- c (expt z 6))))
   (proc "z^7-c"        (λ (z c) (- c (expt z 7))))
   (proc "z^8-c"        (λ (z c) (- c (expt z 8))))
   (proc "z^2+z-c"      (λ (z c) (- c z (expt z 2))))
   (proc "z^3+z-c"      (λ (z c) (- c z (expt z 3))))
   (proc "z^0.5-c"      (λ (z c) (- c (exp (expt z 0.5)))))
   (proc "exp(z^2)-c"   (λ (z c) (- c (exp (expt z 2)))))
   (proc "exp(z^3)-c"   (λ (z c) (- c (exp (expt z 3)))))
   (proc "z^2*exp(z)-c" (λ (z c) (- c (* (expt z 2) (exp z)))))
   (proc "sin(z^2)-c"   (λ (z c) (- c (sin (expt z 2)))))
   (proc "cos(z^2)-c"   (λ (z c) (- c (cos (expt z 2)))))
   (proc "tan(z^2)-c"   (λ (z c) (- c (tan (expt z 2)))))
   (proc "sinh(z^2)-c"  (λ (z c) (- c (sinh (expt z 2)))))
   (proc "cosh(z^2)-c"  (λ (z c) (- c (cosh (expt z 2)))))
   (proc "tanh(z^2)-c"  (λ (z c) (- c (tanh (expt z 2)))))
   (proc "asin(z^2)-c"  (λ (z c) (- c (asin (expt z 2)))))
   (proc "acos(z^2)-c"  (λ (z c) (- c (acos (expt z 2)))))
   (proc "atan(z^2)-c"  (λ (z c) (- c (atan (expt z 2)))))
   (proc "exp(z^0.5)-c" (λ (z c) (- c (exp (expt z -2.0)))))
   (proc "log(z^2)-c"   (λ (z c) (- c (log (expt z 2)))))
   ))

;; the operations to use to weave functions together
(define the-ops
  (vector
   (proc "+" +)
   (proc "-" -)
   (proc "/" (lambda (a b) (if (= b 0) 0 (/ a b))))
   (proc "*" *)))

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
  (define lmul  (- (* 2 (random)) 1))
  (define rmul  (- (* 2 (random)) 1))
  (proc
   (string-join
    (list
     "λ.z="
     (string-append (number->string lmul) "*(" (pstr left) ")")
     (pstr op)
     (string-append (number->string rmul) "*(" (pstr right) ")")
     )
    " ")
   (λ (z c) ((pfun op) (* lmul ((pfun left) z c)) (* rmul ((pfun right) z c))))))

;; Define a random complex function (yes I compressed it on purpose)
(define (random-complex)
  (apply make-rectangular
         (map (λ (p) (if (= 0 (random 2)) p (- p)))
              (map (λ (j) (* comp-scale (random))) (range 2)))))

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

;; Main procedure to create and upload fractals
(define (main)
  ;; Genesis block 
  (displayln "Picking a function... ")
  (define func (random-function)) ;; this is a pair (string . proc)
  (displayln (format "Got ~a" (pstr func)))
  (displayln "Generating a random number... ")
  (define randc (random-complex))
  (displayln (format "Got ~a" randc))
  (displayln "Creating fractal... (ง’̀-‘́)ง")
  (time (make-fractal (pfun func) randc target-width target-height file-output-path))
  
  ;; emergency break-out block; check if file is less than 4000 bytes
  (when
    (4000 . > .  (file-size "output.png"))
    (displayln "Failed size check, restarting... ლ(ಠ益ಠლ)")
    (main))

  ;; upload block 
  (displayln "Uploading... (つ☯ᗜ☯)つ")
  (define upload-str
    (string-append (pstr func) "; c=" (number->string randc)))
  (define usl (string-length upload-str))
  (system* "upload.py" (substring upload-str 0 (if (< usl 140) usl 140)))
  (displayln "Sleeping... ( -ل͟-) Zzzzzzz")

  ;; wait and go-again block
  (sleep sleep-time)
  (main))
;; end
