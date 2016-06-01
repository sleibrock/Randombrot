#lang racket

(require "src/prog.rkt")

(define (create-file) (open-output-file "fractal.obj"))
(define x-offset 2.25)
(define y-offset 1.25)
(define x-scale 3.0)
(define y-scale 2.5)
(define hs 50)

(define (make-3d fun wid hei fpath)
  (define op (open-output-file fpath #:exists 'replace))
  (define sample-size (* wid hei))
  (for* ([x wid] [y hei]) ; generate a fractal file in similar fashion
    (define real-x (- (* x-scale (/ x wid)) x-offset))
    (define real-y (- (* y-scale (/ y hei)) y-offset))
    (displayln 
      (format 
        "v ~a ~a ~a" 
        (- x (/ wid 2))
        (- (* hs (/ (iterate fun 0 (make-rectangular real-x real-y) 0) 255.0)))
        (- y (/ hei 2))) 
      op))
  (for ([p sample-size]) ; connect the dots with a simple round-the-world
    (when
      (not (or (= (modulo p wid) 0) (>= p (- sample-size wid))))
      (displayln
        (format
          "f ~a ~a ~a ~a"
          p (add1 p) (+ p wid 1) (+ p wid))
        op)))
  (close-output-port op))

(make-3d (λ (z c) (+ c (expt z 2))) 500 500 "fractal.obj")

