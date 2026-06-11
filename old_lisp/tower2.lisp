
; This version does not work because system cannot use bound start times
; to keep from firing pyramid rule recursively. 

(setq generics* nil)
(setq definitions* nil)
(setq constraints* nil)

; (setq filter-match* '(some-constants some-connection))
(setq filter-match* '(some-constants some-connection nonassumables-matched))
; (setq filter-match* '(all-matched))


(create-definitions 

((pyramid ^type p1 ^id (?id1 ?id2) ^top ?id1 ^bottom ?id2 ^start ?t1 ^end ?t4)
   :conditions ((block ^id ?id1 ^width ?w1)
		(block ^id ?id2 ^width ?w2)
;		(not (stack ^end ?t1))
		(pick-up ^object ?id1 ^start ?t1 ^end ?t2)
		(stack ^top ?id1 ^bottom ?id2 ^start ?t3 ^end ?t4)
		(not (pyramid ^top ?id2)))
  :tests      ((=+1 ?w2 ?w1)(> ?t3 ?t2)))

 ((pyramid ^type p2 ^id (?id1 ?idp) ^top ?id1 ^bottom ?idp ^start ?t1 ^end ?t6)
   :conditions ((block ^id ?id1 ^width ?w1)
		(block ^id ?id2 ^width ?w2)
		(pyramid ^id ?idp ^top ?id2 ^bottom ?id3
			 ^start ?t1 ^end ?t2)
		(pick-up ^object ?id1 ^start ?t3 ^end ?t4)
		(stack ^top ?id1 ^bottom ?id2 ^start ?t5 ^end ?t6))
;		(not (pyramid ^top ?id2)))
   :tests      ((=+1 ?w2 ?w1)(not (eq ?idp ?id1))(> ?t3 ?t2)(> ?t5 ?t4)))
;  :tests      ((not (eq ?idp ?id1))(not (eq ?idp ?id2))(not (eq ?id1 ?id2))))
;  :tests      ((not (eq ?idp ?id1))(> ?t3 ?t2)(> ?t5 ?t4)))

)

(defun =+1 (x y)
  (= x (1+ y)))

(create-constraints
; ((bp ^top ?idt)
;  :options  ((pyramid ^type p1 ^top ?idt)
;	      (pyramid ^type p2 ^top ?idt)))
; ((bp ^top ?idt)
;  :options  ((pyramid ^id ?id1 ^top ?idt)
;      (pyramid ^id ?id2 ^top ?idt))
;  :tests    ((not (equal ?id1 ?id2))))
; ((bt ^top ?block)
;  :options  ((pyramid ^id ?id1 ^top ?block)
;	      (pyramid ^id ?id2 ^bottom ?block))
;  :tests    ((not (equal ?id1 ?id2))))
  ((bt ^top ?block)
   :options  ((stack ^top ?block)
	      (pyramid ^bottom ?block)))
  ((st ^top ?top)
   :options  ((stack ^top ?top ^bottom ?b1)
	      (stack ^top ?top ^bottom ?b2))
   :tests    ((not (equal ?b1 ?b2))))
)

(setq ignorables* '(block))
(setq assumables* '(pick-up stack))
; (setq assumables* '(pick-up))

(defun o ()
  (setq observations*
	'(((block ^id C ^width 3)
	   (block ^id B ^width 2)
	   (block ^id A ^width 1)
	   (pick-up ^object B ^start 1 ^end 2)
	   (stack ^top B ^bottom C ^start 3 ^end 4)
	   (pick-up ^object A ^start 5 ^end 6)
	   (stack ^top A ^bottom B ^start 7 ^end 8)))))

(defun o1 ()
  (setq observations*
	'(((block ^id C ^width 3)
	   (block ^id B ^width 2)
	   (block ^id A ^width 1))
	  ((pick-up ^object B ^start 1 ^end 2))
	  ((stack ^top B ^bottom C ^start 3 ^end 4))
	  ((pick-up ^object A ^start 5 ^end 6))
	  ((stack ^top A ^bottom B ^start 7 ^end 8)))))

; (defun o ()
;   (setq observations*
; 	'(((block ^id C ^width 3)
; 	   (block ^id B ^width 2)
; 	   (block ^id A ^width 1)
; 	   (pick-up ^object B ^start 1 ^end 2)
; 	   (stack ^top B ^bottom C ^start 3 ^end 4)
; 	   (pick-up ^object A ^start 5 ^end 6)
; 	   (stack ^top A ^bottom B ^start 7 ^end 8)))))

(defun p1 ()
  (setq observations*
	'(((block ^id C1 ^width 3)
	   (block ^id C2 ^width 3)
	   (block ^id B1 ^width 2)
	   (block ^id B2 ^width 2)
	   (block ^id A ^width 1))
	  ((pick-up ^object B1 ^start 1 ^end 2))
	  ((stack ^top B1 ^bottom C1 ^start 3 ^end 4))
	  ((pick-up ^object B2 ^start 5 ^end 6))
	  ((stack ^top B2 ^bottom C2 ^start 7 ^end 8))
	  ((pick-up ^object A ^start 9 ^end 10))
	  ((stack ^top A ^bottom B1 ^start 11 ^end 12)))))
