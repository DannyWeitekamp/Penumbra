
(setq generics* nil)
(setq definitions* nil)
(setq constraints* nil)

(setq filter-match* '(some-constants some-connection))
; (setq filter-match* '(some-constants some-connection nonassumables-matched))
; (setq filter-match* '(some-connection all-bound))
; (setq filter-match* '(some-connection all-but-one-bound))
; (setq filter-match* '(all-matched))

(create-definitions

((action ^id (?o1 ?o2) ^time (?start ?end))
 :conditions ((object ^id ?o1 ^verity t)
	      (object ^id ?o2 ^verity t)
	      (on ^id ?o1 ^verity t ^time (?t1 ?start))
;	      (at ^id ?o1 ^verity t ^time (?t1 ?start))
	      (on ^id ?o2 ^verity t ^time (?end ?t2))
;	      (at ^id ?o2 ^verity t ^time (?end ?t2))
	      )
 :tests      ((=+1 ?end ?start) (<= ?t1 ?start) (<= ?end ?t2)))

)

(defun =+1 (x y)
  (= x (1+ y)))


(create-constraints

((one-at-a-time ?id1 ?id2) 
  :options ((action ^id ?id1 ^time (?s1 ?e1))
	    (action ^id ?id2 ^time (?s2 ?e2)))
  :tests   ((not (equal ?id1 ?id2)) 
	    (overlaps ?s1 ?e1 ?s2 ?e2)))

)

; OVERLAPS inputs the start and end times for two intervals. The
; function returns T if the start of the second interval falls in
; the first interval or if the start of the first interval falls 
; in the second interval. If either a start or end time is a skolem, 
; then it is ingnored in the comparison. 
; Note: This function has been replaced by calls to BETWEEN. 

(defun overlaps (s1 e1 s2 e2)
  (or (and (numberp s2) (numberp s1) (numberp e2) (<= s2 s1) (<= s1 e2))
      (and (numberp s1) (numberp s2) (numberp e1) (<= s1 s2) (<= s2 e1))
      (and (numberp s2) (numberp e1) (numberp e2) (<= s2 e1) (<= e1 e2))
      (and (numberp s1) (numberp e2) (numberp e1) (<= s1 e2) (<= e2 e1))))

(setq ignorables* '(object))
(setq assumables* '(on at action))

(defun o ()
  (setq observations*
	'(((object ^id a ^time (1 10))
	   (object ^id b ^time (1 10))
	   (object ^id c ^time (1 10))
	   (object ^id d ^time (1 10))
	   (on ^id a ^time (1 2))
;	   (at ^id a ^time (1 2))
;	   (action1 ^id (a b) ^time (2 3))
	   (on ^id b ^time (3 4))
;	   (at ^id b ^time (3 4))
;	   (action1 ^id (b c) ^time (4 5))
	   (on ^id c ^time (5 6))
;	   (at ^id c ^time (5 6))
;	   (action1 ^id (c d) ^time (6 7))
	   (on ^id d ^time (7 8))
;	   (at ^id d ^time (7 8))
	   ))))
