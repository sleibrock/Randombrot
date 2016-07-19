#lang racket

(require "src/prog.rkt")

(define movie-width  300)
(define movie-height 200)
(define frame-count  300)

;(define target-func (pfun (random-function)))
; (define target-func (λ (z c) (+ c (expt z 2)))) ; default mandelbrot
(define target-func
  (λ (z c)
     (/
       (* -0.6811423422018082 (- c (expt z 7)))
       (* 0.6065626452129871  (- c (sinh (expt z 2)))))))

(define target-seed 0.026687190996235177+0.11995964705748638i)

(define (make-movie func cvar)
  (define rand-color (color-factory))
  (for ([x frame-count])
    (define current-frame (create-frame (* 4 (add1 x)) 
                                        0 
                                        0
                                        (/ 3.0 (add1 x)) 
                                        (/ 2.5 (add1 x)) 
                                        rand-color))
    (displayln (format "Processing frame ~a of ~a" x frame-count))
    (current-frame func cvar movie-width movie-height
                   (string-append "image" (number->string x) ".png")))
  (displayln "Done! Go ffmpeg it now!"))

(make-movie target-func target-seed)
