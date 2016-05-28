#lang racket

(require "src/prog.rkt")

;; A function that takes in a list of true/false return tests
;; and performs IO actions to inform us if tests pass or fail
(define (test-manager listof-tests)
  (for-each
    (λ (p)
       (if (second p)
         (displayln (format "~a passed" (first p)))
         (displayln (format "~a didn't pass" (first p)))))
    (foldl (λ (a b) (cons (a) b)) '() listof-tests)))

(define (test-randomp)
  (list 
    "test-randomp"
    (empty?
      (filter
        (λ (x) (not (if (> x 1000) #f (if (< x 1) #f #t))))
        (map (λ (p) (randomp 1 1000)) (range 1000))))))

(define (test-random-fractal)
  (time (random-fractal))
  (list
    "test-make-fractal"
    (file-exists? (string->path "output.png"))))

(test-manager
  (list
    test-randomp
    test-random-fractal))
