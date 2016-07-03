#lang racket

(require "../src/data.rkt")
(require "../src/prog.rkt")

(define ow 3840)
(define oh 2160)

(define (pair-function x y)
  (define l (vector-ref the-functions x))
  (define r (vector-ref the-functions y))
  (define o (get-random-element the-ops))
  (define a (- (* 2 (random)) 1))
  (define b (- (* 2 (random)) 1))
  (proc
   (get-func-string o l r a b)
   (λ (z c) ((pfun o) (* a ((pfun l) z c)) (* b ((pfun r) z c))))))

(define (loop-all-functions size)
  (for* ([x size] [y size])
    (when (not (= x y))
      (define p (pair-function x y))
      (displayln (format "Assembling ~a..." (pstr p)))
      (time
       (make-fractal
        (pfun p)
        (random-complex)
        ow oh
        (format "~a.png" (string-replace (pstr p) "/" "|")))))))

(loop-all-functions (vector-length the-functions))
    
