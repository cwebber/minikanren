#!r6rs
(library (minikanren mkprelude)
(export caro
        cdro
        conso
        nullo
        eqo
        eq-caro
        pairo
        listo
        membero
        rembero
        appendo
        anyo
        nevero
        alwayso

        build-num
        full-addero
        poso
        >1o
        gen-addero
        +o
        -o
        *o
        odd-*o
        bound-*o
        =lo
        <lo
        <=lo
        /o
        splito
        logo
        exp2
        repeated-mul
        expo
        trace-vars
        )
(import (rnrs)
        (only (rnrs r5rs) quotient)
        (minikanren mk)
        (minikanren mkextraforms))
;;; Code that accompanies ``The Reasoned Schemer''
;;; Daniel P. Friedman, William E. Byrd and Oleg Kiselyov
;;; MIT Press, Cambridge, MA, 2005
;;;
;;; Useful definitions from the book

;;; This file was generated by writeminikanren.pl
;;; Generated at 2005-08-12 11:27:16

;;; 3 October 2005 [WEB]
;;; Renamed 'any*' to 'anyo'.
;;; Renamed 'never' and 'always' to 'nevero' and 'alwayso'.

(define caro
  (lambda (p a)
    (fresh (d)
      (== (cons a d) p))))

(define cdro
  (lambda (p d)
    (fresh (a)
      (== (cons a d) p))))

(define conso
  (lambda (a d p)
    (== (cons a d) p)))

(define nullo
  (lambda (x)
    (== '() x)))

(define eqo
  (lambda (x y)
    (== x y)))

(define eq-caro
  (lambda (l x)
    (caro l x)))

(define pairo
  (lambda (p)
    (fresh (a d)
      (conso a d p))))

(define listo
  (lambda (l)
    (conde
      ((nullo l) succeed)
      ((pairo l)
       (fresh (d)
         (cdro l d)
         (listo d)))
      (else fail))))

(define membero
  (lambda (x l)
    (conde
      ((nullo l) fail)
      ((eq-caro l x) succeed)
      (else
        (fresh (d)
          (cdro l d)
          (membero x d))))))

(define rembero  
  (lambda (x l out)
    (conde
      ((nullo l) (== '() out))
      ((eq-caro l x) (cdro l out))
      (else (fresh (a d res)
              (conso a d l)
              (rembero x d res)
              (conso a res out))))))

(define appendo
  (lambda (l s out)
    (conde
      ((nullo l) (== s out))
      (else 
        (fresh (a d res)
          (conso a d l)
          (conso a res out)
          (appendo d s res))))))

(define anyo
  (lambda (g)
    (conde
      (g succeed)
      (else (anyo g)))))

(define nevero (anyo fail))
 
(define alwayso (anyo succeed))

(define build-num
  (lambda (n)
    (cond
      ((zero? n) '())
      ((and (not (zero? n)) (even? n))
       (cons 0
         (build-num (quotient n 2))))
      ((odd? n)
       (cons 1
         (build-num (quotient (- n 1) 2)))))))

(define full-addero
  (lambda (b x y r c)
    (conde
      ((== 0 b) (== 0 x) (== 0 y) (== 0 r) (== 0 c))
      ((== 1 b) (== 0 x) (== 0 y) (== 1 r) (== 0 c))
      ((== 0 b) (== 1 x) (== 0 y) (== 1 r) (== 0 c))
      ((== 1 b) (== 1 x) (== 0 y) (== 0 r) (== 1 c))
      ((== 0 b) (== 0 x) (== 1 y) (== 1 r) (== 0 c))
      ((== 1 b) (== 0 x) (== 1 y) (== 0 r) (== 1 c))
      ((== 0 b) (== 1 x) (== 1 y) (== 0 r) (== 1 c))
      ((== 1 b) (== 1 x) (== 1 y) (== 1 r) (== 1 c))
      (else fail))))

(define poso
  (lambda (n)
    (fresh (a d)
      (== `(,a . ,d) n))))

(define >1o
  (lambda (n)
    (fresh (a ad dd)
      (== `(,a ,ad . ,dd) n))))

(define addero
  (lambda (d n m r)
    (condi
      ((== 0 d) (== '() m) (== n r))
      ((== 0 d) (== '() n) (== m r)
       (poso m))
      ((== 1 d) (== '() m)
       (addero 0 n '(1) r))
      ((== 1 d) (== '() n) (poso m)
       (addero 0 '(1) m r))
      ((== '(1) n) (== '(1) m)
       (fresh (a c)
         (== `(,a ,c) r)
         (full-addero d 1 1 a c)))
      ((== '(1) n) (gen-addero d n m r))
      ((== '(1) m) (>1o n) (>1o r)
       (addero d '(1) n r))
      ((>1o n) (gen-addero d n m r))
      (else fail))))

(define gen-addero
  (lambda (d n m r)
    (fresh (a b c e x y z)
      (== `(,a . ,x) n)
      (== `(,b . ,y) m) (poso y)
      (== `(,c . ,z) r) (poso z)
      (alli
        (full-addero d a b c e)
        (addero e x y z)))))

(define +o
  (lambda (n m k)
    (addero 0 n m k)))

(define -o
  (lambda (n m k)
    (+o m k n)))

(define *o
  (lambda (n m p)
    (condi
      ((== '() n) (== '() p))
      ((poso n) (== '() m) (== '() p))  
      ((== '(1) n) (poso m) (== m p))   
      ((>1o n) (== '(1) m) (== n p))
      ((fresh (x z)
         (== `(0 . ,x) n) (poso x)
         (== `(0 . ,z) p) (poso z)
         (>1o m)
         (*o x m z)))
      ((fresh (x y)
         (== `(1 . ,x) n) (poso x)
         (== `(0 . ,y) m) (poso y)
         (*o m n p)))
      ((fresh (x y)
          (== `(1 . ,x) n) (poso x)      
          (== `(1 . ,y) m) (poso y)
          (odd-*o x n m p)))
      (else fail))))

(define odd-*o
  (lambda (x n m p)
    (fresh (q)
      (bound-*o q p n m)
      (*o x m q)
      (+o `(0 . ,q) m p))))

(define bound-*o
  (lambda (q p n m)
    (conde
      ((nullo q) (pairo p))
      (else
        (fresh (x y z)
          (cdro q x)
          (cdro p y)
          (condi
            ((nullo n)
             (cdro m z)
             (bound-*o x y z '()))
            (else
              (cdro n z) 
              (bound-*o x y z m))))))))

(define =lo
  (lambda (n m)
    (conde
      ((== '() n) (== '() m))
      ((== '(1) n) (== '(1) m))
      (else
        (fresh (a x b y)
          (== `(,a . ,x) n) (poso x)
          (== `(,b . ,y) m) (poso y)
          (=lo x y))))))

(define <lo
  (lambda (n m)
    (conde
      ((== '() n) (poso m))
      ((== '(1) n) (>1o m))
      (else
        (fresh (a x b y)
          (== `(,a . ,x) n) (poso x)
          (== `(,b . ,y) m) (poso y)
          (<lo x y))))))

(define <=lo
  (lambda (n m)
    (condi
      ((=lo n m) succeed)
      ((<lo n m) succeed)
      (else fail))))

(define <o
  (lambda (n m)
    (condi
      ((<lo n m) succeed)
      ((=lo n m)
       (fresh (x)
         (poso x)
         (+o n x m)))
      (else fail))))

(define <=o
  (lambda (n m)
    (condi
      ((== n m) succeed)
      ((<o n m) succeed)
      (else fail))))

(define /o
  (lambda (n m q r)
    (condi
      ((== r n) (== '() q) (<o n m))
      ((== '(1) q) (=lo n m) (+o r m n)
       (<o r m))
      (else
        (alli
          (<lo m n)                        
          (<o r m)                        
          (poso q)                 
          (fresh (nh nl qh ql qlm qlmr rr rh)
            (alli
              (splito n r nl nh)
              (splito q r ql qh)
              (conde
                ((== '() nh)
                 (== '() qh)
                 (-o nl r qlm)
                 (*o ql m qlm))
                (else
                  (alli 
                    (poso nh)
                    (*o ql m qlm)
                    (+o qlm r qlmr)
                    (-o qlmr nl rr)
                    (splito rr r '() rh)
                    (/o nh m qh rh)))))))))))

(define splito
  (lambda (n r l h)
    (condi
      ((== '() n) (== '() h) (== '() l))
      ((fresh (b n^)
         (== `(0 ,b . ,n^) n)
         (== '() r)
         (== `(,b . ,n^) h)
         (== '() l)))
      ((fresh (n^)
         (==  `(1 . ,n^) n)
         (== '() r)
         (== n^ h)
         (== '(1) l)))
      ((fresh (b n^ a r^)
         (== `(0 ,b . ,n^) n)
         (== `(,a . ,r^) r)
         (== '() l)
         (splito `(,b . ,n^) r^ '() h)))
      ((fresh (n^ a r^)
         (== `(1 . ,n^) n)
         (== `(,a . ,r^) r)
         (== '(1) l)
         (splito n^ r^ '() h)))
      ((fresh (b n^ a r^ l^)
         (== `(,b . ,n^) n)
         (== `(,a . ,r^) r)
         (== `(,b . ,l^) l)
         (poso l^)
         (splito n^ r^ l^ h)))
      (else fail))))

(define logo
  (lambda (n b q r)
    (condi
      ((== '(1) n) (poso b) (== '() q) (== '() r))
      ((== '() q) (<o n b) (+o r '(1) n))
      ((== '(1) q) (>1o b) (=lo n b) (+o r b n))
      ((== '(1) b) (poso q) (+o r '(1) n))
      ((== '() b) (poso q) (== r n))
      ((== '(0 1) b)
       (fresh (a ad dd)
         (poso dd)
         (== `(,a ,ad . ,dd) n)
         (exp2 n '() q)
         (fresh (s)
           (splito n dd r s))))
      ((fresh (a ad add ddd)
         (conde
           ((== '(1 1) b))
           (else (== `(,a ,ad ,add . ,ddd) b))))
       (<lo b n)
       (fresh (bw1 bw nw nw1 ql1 ql s)
         (exp2 b '() bw1)
         (+o bw1 '(1) bw)
         (<lo q n)
         (fresh (q1 bwq1)
           (+o q '(1) q1)
           (*o bw q1 bwq1)
           (<o nw1 bwq1))
           (exp2 n '() nw1)
           (+o nw1 '(1) nw)
           (/o nw bw ql1 s)
           (+o ql '(1) ql1)
         (conde
           ((== q ql))
           (else (<lo ql q)))
         (fresh (bql qh s qdh qd)
           (repeated-mul b ql bql)        
           (/o nw bw1 qh s)                
           (+o ql qdh qh)
           (+o ql qd q)
           (conde
             ((== qd qdh))
             (else (<o qd qdh)))
           (fresh (bqd bq1 bq)
             (repeated-mul b qd bqd)        
             (*o bql bqd bq)                
             (*o b bq bq1)                
             (+o bq r n)
             (<o n bq1)))))
      (else fail))))

(define exp2
  (lambda (n b q)
    (condi
      ((== '(1) n) (== '() q))
      ((>1o n) (== '(1) q)
       (fresh (s)
         (splito n b s '(1))))
      ((fresh (q1 b2)                        
         (alli                 
           (== `(0 . ,q1) q)
           (poso q1)
           (<lo b n)
           (appendo b `(1 . ,b) b2)
           (exp2 n b2 q1))))
      ((fresh (q1 nh b2 s)                
          (alli
            (== `(1 . ,q1) q)
            (poso q1)
            (poso nh)
            (splito n b s nh)
            (appendo b `(1 . ,b) b2)
            (exp2 nh b2 q1))))
      (else fail))))

(define repeated-mul
  (lambda (n q nq)
    (conde
      ((poso n) (== '() q) (== '(1) nq))
      ((== '(1) q) (== n nq))
      ((>1o q)
       (fresh (q1 nq1)
         (+o q1 '(1) q)
         (repeated-mul n q1 nq1)
         (*o nq1 n nq)))
      (else fail))))

(define expo
  (lambda (b q n)
    (logo n b q '())))

;;;  'trace-vars' can be used to print the values of selected variables
;;;  in the substitution.
(define-syntax trace-vars
  (syntax-rules ()
    ((_ title x ...)
     (lambdag@ (s)
       (begin
         (display title)
         (newline)
         (for-each (lambda (x_ t) 
                     (display x_)
                     (display " = ")
                     (write t)
                     (newline))
           `(x ...) (reify (walk* `(,x ...) s)))
         (unit s))))))

;;; (run* (q)
;;;   (fresh (r)
;;;     (== 3 q)
;;;     (trace-vars "What it is!" q r)))
;;;
;;; What it is!
;;; q = 3
;;; r = _.0
;;; (3)
)
