#lang racket

(require "../src/prog.rkt")

(make-3d (λ (z c) (+ c (expt z 2))) (random-complex) 500 500 "fractal.obj")
