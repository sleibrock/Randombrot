#lang racket

(require "../src/data.rkt")
(require "../src/prog.rkt")

(define ow 3840)
(define oh 2160)

(command-line
 #:args (func1 func2)
 (let ((a (string->number func1))
       (b (string->number func2)))
       (displayln (format "Nummber of functions: ~a" (vector-length the-functions)))
       (time
        (make-fractal
         (pfun (pair-functions a b))
         (random-complex)
         ow oh
         (format "~a-with-~a.png" a b)))))

