#lang racket

(provide
 the-functions
 the-ops
 pfun
 pstr
 (struct-out proc))

;; The core struct we will use throughtout the program
(struct proc (str fun))
(define pfun (lambda (p) (proc-fun p)))
(define pstr (lambda (p) (proc-str p)))

;; the operations to use to weave functions together
(define the-ops
  (vector
   (proc "+" +)
   (proc "-" -)
   (proc "/" (lambda (a b) (if (= b 0) 0 (/ a b)))) ;; safe division \_,0 -> 0
   (proc "*" *)))

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

;; end
