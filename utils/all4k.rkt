#lang racket

(require "../src/data.rkt")
(require "../src/prog.rkt")

(define ow 3840)
(define oh 2160)

(define (loop-all-functions size)
  (for* ([x size] [y size])
    (when (not (= x y))
      (define p (pair-functions x y))
      (displayln (format "Assembling ~a..." (pstr p)))
      (time
       (make-fractal
        (pfun p)
        (random-complex)
        ow oh
        (format "~a.png" (string-replace (pstr p) "/" "|")))))))

(loop-all-functions (vector-length the-functions))
    
