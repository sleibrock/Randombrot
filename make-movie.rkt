#lang racket

(require "src/prog.rkt")

(define movie-width  1920)
(define movie-height 1080)
(define frame-count  900)

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
    (define current-mag (* 20 (add1 x)))
    (define current-frame (create-frame current-mag  0 0 3.0 2.5 rand-color)) 
    (displayln (format "Processing frame ~a of ~a" x frame-count))
    (current-frame func cvar movie-width movie-height
                   (string-append "image" (number->string x) ".png")))
  (displayln "Done! Go ffmpeg it now!")
  (system "ffmpeg -framerate 30 -i image%d.png -c:v libx264 -r 30 -pix_fmt yuv420p out3.mp4"))

(make-movie target-func target-seed)
