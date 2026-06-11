; BLOCKS.LISP
; 5/6/2021

; This file shows a revised representation for definitional rules using
; actions for the blocks world. Each rule includes antecedents for: 
; 1. Relations (often unary) that do not change over time
; 2. Relations that hold when an action starts but not when it ends
; 3. Relations that hold when an action ends but not when it starts
; The second and third types correspond to add and delete statements, 
; respectively. Some antecedents note the start time, some the end
; time, and others both of them. 
; 
; Note that negated antecedents, which precede the predicate with NOT, 
; indicate when the relation initially becomes false, when it ceases
; to be false, or both times. 

(setq generics* nil)
(setq definitions* nil)
(setq constraints* nil)

(setq filter-match* '(some-constants some-connection))
; (setq filter-match* '(some-constants some-connection nonassumables-matched))
; (setq filter-match* '(some-connection all-bound))
; (setq filter-match* '(some-connection all-but-one-bound))
; (setq filter-match* '(all-matched))

(create-definitions

((pickup ^id (?block ?table) ^time (?t1 ?t2))
  :conditions ((block ^id ?block ^verity t)
	       (table ^id ?table ^verity t)
	       (hand ^id ?hand ^verity t)
	       (clear ^id (?block) ^verity t ^time (?t0 ?t3))
	       (empty ^id (?hand) ^verity t ^time (?t4 ?t1))
	       (ontable ^id (?block ?table) ^verity t ^time (?t5 ?t1))
	       (holding ^id (?hand ?block) ^verity t ^time (?t2 ?t6)))
  :tests      ((=+1 ?t2 ?t1) (<= ?t0 ?t1) (<= ?t1 ?t3)
	       (< ?t1 ?t6) (< ?t4 ?t2) (< ?t5 ?t2)))

; Check to see whether we can replae (=+1 ?t2 ?t1) with (< ?t1 ?t2)
; without abduction getting out of control. 

((putdown ^id (?block ?table) ^time (?t1 ?t2))
  :conditions ((block ^id ?block ^verity t)
	       (table ^id ?table ^verity t)
	       (hand ^id ?hand ^verity t)
	       (holding ^id (?hand ?block) ^verity t ^time (?t3 ?t1))
	       (empty ^id (?hand) ^verity t ^time (?t2 ?t4))
	       (ontable ^id (?block ?table) ^verity t ^time (?t2 ?t5)))
  :tests      ((=+1 ?t2 ?t1)))

; Need to add other temporal tests to above rule. 

((stack ^id (?block1 ?block2) ^time (?t1 ?t2))
  :conditions ((block ^id ?block1 ^verity t)
	       (block ^id ?block2 ^verity t)
	       (hand ^id ?hand ^verity t)
	       (clear ^id (?block2) ^verity t ^time (?t3 ?t1))
	       (holding ^id (?hand ?block1) ^verity t ^time (?t4 ?t1))
	       (empty ^id (?hand) ^verity t ^time (?t2 ?t5))
	       (on ^id (?block1 ?block2) ^verity t ^time (?t2 ?t6)))
  :tests      ((not (eq ?block1 ?block2)) (=+1 ?t2 ?t1) 
	       (<= ?t3 ?t1) (<= ?t4 ?t1) (<= ?t2 ?t5) (<= ?t2 ?t6) 
	       (< ?t1 ?t5) (< ?t1 ?t6) (< ?t3 ?t2) (< ?t4 ?t2)))

((unstack ^id (?block1 ?block2) ^time (?t1 ?t2))
  :conditions ((block ^id ?block1 ^verity t)
	       (block ^id ?block2 ^verity t)
	       (hand ^id ?hand ^verity t)
	       (clear ^id (?block1) ^verity t ^time (?t0 ?t3))
	       (empty ^id (?hand) ^verity t ^time (?t4 ?t1))
	       (on ^id (?block1 ?block2) ^verity t ^time (?t5 ?t1))
	       (holding ^id (?hand ?block1) ^verity t ^time (?t2 ?t6)))
  :tests      ((not (eq ?block1 ?block2)) (=+1 ?t2 ?t1)
	       (<= ?t0 ?t1) (<= ?t1 ?t3) (< ?t1 ?t5) (< ?t4 ?t2)))

((pickup-and-stack ^id (?block1 ?table ?block2) ^time (?t1 ?t4))
  :conditions ((pickup ^id (?block1 ?table) ^verity T ^time (?t1 ?t2))
	       (stack ^id (?block1 ?block2) ^verity T ^time (?t3 ?t4)))
  :tests      ((=+1 ?t3 ?t2) (< ?t1 ?t3) (< ?t1 ?t4) (< ?t2 ?t4)))

; ((build-tower ^id (?top ?middle ?bottom ?table) ^time (?t1 ?t4))
;   :conditions ((pickup-and-stack ^id (?middle ?table ?bottom) ^verity T)
; 	       (pickup-and-stack ^id (?top ?table ?middle) ^verity T)))

((build-tower ^id (?top (?middle ?table ?bottom)) ^time (?t1 ?t4))
  :conditions ((pickup-and-stack ^id (?middle ?table ?bottom)
				 ^verity T ^time (?t1 ?t2))
	       (pickup-and-stack ^id (?top ?table ?middle)
				 ^verity T ^time (?t3 ?t4)))
  :tests      ((=+1 ?t3 ?t2) (< ?t1 ?t3) (< ?t1 ?t4) (< ?t2 ?t4)))

)

(defun =+1 (x y)
  (= x (1+ y)))

(create-constraints

((only-one-action ?end)
  :options ((pickup ^verity T ^time (?s1 ?end))
	    (putdown ^verity T ^time (?s2 ?end))
	    (stack ^verity T ^time (?s3 ?end))
	    (unstack ^verity T ^time (?s4 ?end))))

((only-one-action ?start)
  :options ((pickup ^verity T ^time (?start ?e1))
	    (putdown ^verity T ^time (?start ?e2))
	    (stack ^verity T ^time (?start ?e3))
	    (unstack ^verity T ^time (?start ?e4))))

((only-one-pickup ?id1 ?id2)
  :options ((pickup ^id ?id1 ^verity T ^time (?s1 ?e1))
	    (pickup ^id ?id2 ^verity T ^time (?s2 ?e2)))
  :tests   ((not (equal ?id1 ?id2)) 
	    (overlaps ?s1 ?e1 ?s2 ?e2)))

((only-one-putdown ?id1 ?id2)
  :options ((putdown ^id ?id1 ^verity T ^time (?s1 ?e1))
	    (putdown ^id ?id2 ^verity T ^time (?s2 ?e2)))
  :tests   ((not (equal ?id1 ?id2)) 
	    (overlaps ?s1 ?e1 ?s2 ?e2)))

((only-one-stack ?id1 ?id2)
  :options ((stack ^id ?id1 ^verity T ^time (?s1 ?e1))
	    (stack ^id ?id2 ^verity T ^time (?s2 ?e2)))
  :tests   ((not (equal ?id1 ?id2)) 
	    (overlaps ?s1 ?e1 ?s2 ?e2)))

((only-one-unstack ?id1 ?id2)
  :options ((unstack ^id ?id1 ^verity T ^time (?s1 ?e1))
	    (unstack ^id ?id2 ^verity T ^time (?s2 ?e2)))
  :tests   ((not (equal ?id1 ?id2)) 
	    (overlaps ?s1 ?e1 ?s2 ?e2)))

((only-one-on ?under)
  :options ((on ^id (?block1 ?under) ^verity T ^time (?s1 ?e1))
	    (on ^id (?block2 ?under) ^verity T ^time (?s2 ?e2)))
  :tests   ((not (eq ?block1 ?block2))
	    (overlaps ?s1 ?e1 ?s2 ?e2)))
;	    (between ?s2 ?s1 ?e1)))

; ((only-one-on ?under)
;   :options ((on ^id (?block1 ?under) ^verity T ^time (?s1 ?e1))
; 	      (on ^id (?block2 ?under) ^verity T ^time (?s2 ?e2)))
;   :tests   ((not (eq ?block1 ?block2))
; 	      (between ?s1 ?s2 ?e2)))

((only-on-one ?above) 
  :options ((on ^id (?above ?block1) ^verity T ^time (?s1 ?e1))
	    (on ^id (?above ?block2) ^verity T ^time (?s2 ?e2)))
  :tests   ((not (eq ?block1 ?block2))
	    (overlaps ?s1 ?e1 ?s2 ?e2)))
;	    (between ?s2 ?s1 ?e1)))

; ((only-on-one ?above) 
;   :options ((on ^id (?above ?block1) ^verity T ^time (?s1 ?e1))
; 	      (on ^id (?above ?block2) ^verity T ^time (?s2 ?e2)))
;   :tests   ((not (eq ?block1 ?block2))
; 	      (between ?s1 ?s2 ?e2)))

((only-one-on ?above)
  :options ((ontable ^id (?above ?table) ^verity T ^time (?s1 ?e1))
	    (on ^id (?above ?block) ^verity T ^time (?s2 ?e2)))
  :tests   ((overlaps ?s1 ?e1 ?s2 ?e2)))
; :tests   ((between ?s2 ?s1 ?e1)))

; ((only-one-on ?above)
;   :options ((ontable ^id (?above ?table) ^verity T ^time (?s1 ?e1))
; 	      (on ^id (?above ?block) ^verity T ^time (?s2 ?e2)))
;   :tests   ((between ?s1 ?s2 ?e2)))

((only-holds-one ?hand)
  :options ((holding ^id (?hand ?block1) ^verity T ^time (?s1 ?e1))
	    (holding ^id (?hand ?block2) ^verity T ^time (?s2 ?e2)))
  :tests   ((not (eq ?block1 ?block2))
	    (overlaps ?s1 ?e1 ?s2 ?e2)))
;	    (between ?s2 ?s1 ?e1)))

; ((only-holds-one ?hand)
;   :options ((holding ^id (?hand ?block1) ^verity T ^time (?s1 ?e1))
; 	      (holding ^id (?hand ?block2) ^verity T ^time (?s2 ?e2)))
;   :tests   ((not (eq ?block1 ?block2))
; 	      (between ?s1 ?s2 ?e2)))

((not-holds-and-empty ?hand)
  :options ((holding ^id (?hand ?block) ^verity T ^time (?s1 ?e1))
	    (empty ^id (?hand) ^verity T ^time (?s2 ?e2)))
  :tests   ((overlaps ?s1 ?e1 ?s2 ?e2)))
; :tests   ((between ?s2 ?s1 ?e1)))

; ((not-holds-and-empty ?hand)
;   :options ((holding ^id (?hand ?block) ^verity T ^time (?s1 ?e1))
; 	      (empty ^id (?hand) ^verity T ^time (?s2 ?e2)))
;   :tests   ((between ?s1 ?s2 ?e2)))

((not-on-and-clear ?block)
  :options ((on ^id (?above ?block) ^verity T ^time (?s1 ?e1))
	    (clear ^id (?block) ^verity T ^time (?s2 ?e2)))
  :tests   ((overlaps ?s1 ?e1 ?s2 ?e2)))
; :tests   ((between ?s2 ?s1 ?e1)))

; ((not-on-and-clear ?block)
;   :options ((on ^id (?above ?block) ^verity T ^time (?s1 ?e1))
; 	      (clear ^id (?block) ^verity T ^time (?s2 ?e2)))
;   :tests   ((between ?s1 ?s2 ?e2)))

)

; OVERLAPS inputs the start and end times for two intervals. The
; function returns T if the start of the second interval falls in
; the first interval or if the start of the first interval falls 
; in the second interval. If either a start or end time is a skolem, 
; then it is ingnored in the comparison. 
; Note: This function has been replaced by calls to BETWEEN. 

; (defun overlaps (s1 e1 s2 e2)
;   (or (and (<= s1 s2) (<= s2 e1))
;       (and (<= s2 s1) (<= s1 e2))))

(defun overlaps (s1 e1 s2 e2)
  (or (and (not (skolemp s1)) (not (skolemp s2)) (not (skolemp e1))
	   (<= s1 s2) (<= s2 e1))
      (and (not (skolemp s2)) (not (skolemp s1)) (not (skolemp e2))
	   (<= s2 s1) (<= s1 e2))))

(defun overlaps (s1 e1 s2 e2)
  (or (and (numberp s2) (numberp s1) (numberp e2) (<= s2 s1) (<= s1 e2))
      (and (numberp s1) (numberp s2) (numberp e1) (<= s1 s2) (<= s2 e1))
      (and (numberp s2) (numberp e1) (numberp e2) (<= s2 e1) (<= e1 e2))
      (and (numberp s1) (numberp e2) (numberp e1) (<= s1 e2) (<= e2 e1))))

; BETWEEN returns T if Y is less than or equal to X and if X is less
; than or equal to Z; i.e., if X falls between Y and Z inclusive. 

(defun between (x y z)
  (and (<= y x) (<= x z)))

; Option 1: Observations include a set of entities that exist throughout 
; the trajectory and a set of action instances that do not nonoverlap 
; in time. Negated beliefs are not explicitly encoded as observed facts, 
; but they can be inferred during the explanation process. 
; This option would require extending Penumbra to connect observed beliefs
; by chaining downward through rules instead of upward. 

(defun o ()
  (setq observations*
	'(((block ^id A ^time (1 nil))
	   (block ^id B ^time (1 nil))
	   (block ^id C ^time (1 nil))
	   (table ^id D ^time (1 nil))
	   (hand ^id H ^time (1 nil))
	   (pickup ^id (B D) ^time (1 2))
	   (stack ^id (B C) ^time (3 4))
	   (pickup ^id (A D) ^time (5 6))
	   (stack ^id (A B) ^time (7 8))))))

; Option 2: Observations include a set of entities that exist throughout 
; the trajectory and a set of relations (fluents) that change over time. 
; Negated beliefs are not explicitly encoded as observed facts, but they 
; can be inferred during the explanation process, along with actions. 
; This option would produce to an explanatory chain that connects the 
; changed relations through a set of "flat" actions. 

(setq ignorables* '(block table hand))
(setq assumables* '(holding empty on ontable clear))

(defun o ()
  (setq observations*
	'(((block ^id A ^verity T ^time (1 nil))
	   (block ^id B ^verity T ^time (1 nil))
	   (block ^id C ^verity T ^time (1 nil))
	   (table ^id D ^verity T ^time (1 nil))
	   (hand ^id H ^verity T ^time (1 nil))
	   (ontable ^id (C D) ^verity T ^time (1 nil))
	   (ontable ^id (B D) ^verity T ^time (1 2))
	   (holding ^id (H B) ^verity T ^time (2 4))
	   (on ^id (B C) ^verity T ^time (4 nil))
	   (ontable ^id (A D) ^verity T ^time (1 6))
	   (holding ^id (H A) ^verity T ^time (6 8))
	   (on ^id (A B) ^verity T ^time (8 nil))))))

(defun o ()
  (setq observations*
	'(((block ^id A ^verity T ^time (1 10))
	   (block ^id B ^verity T ^time (1 10))
	   (block ^id C ^verity T ^time (1 10))
	   (table ^id D ^verity T ^time (1 10))
	   (hand ^id H ^verity T ^time (1 10))
	   (ontable ^id (C D) ^verity T ^time (1 10))
; ------------------------------------------------------------
	   (empty ^id (H) ^verity T ^time (1 2))   ;;;
	   (clear ^id (B) ^verity T ^time (1 8))
	   (ontable ^id (B D) ^verity T ^time (1 2))
; ------------------------------------------------------------
;	   (pickup ^id (B D) ^time (2 3))
; ------------------------------------------------------------
	   (holding ^id (H B) ^verity T ^time (3 4))
	   (clear ^id (C) ^verity T ^time (1 4))
; ------------------------------------------------------------
;	   (stack ^id (B C) ^time (4 5))
; ------------------------------------------------------------
	   (on ^id (B C) ^verity T ^time (5 10))
	   (empty ^id (H) ^verity t ^time (5 6))   ;;;
	   (clear ^id (A) ^verity T ^time (1 10))
	   (ontable ^id (A D) ^verity T ^time (1 6))
; ------------------------------------------------------------
;	   (pickup ^id (A D) ^time (6 7))
; ------------------------------------------------------------
	   (holding ^id (H A) ^verity T ^time (7 8))
;	   (clear ^id (B) ^verity T ^time (1 8))     [Redundant]
; ------------------------------------------------------------
;	   (stack ^id (A B) ^time (8 9))
; ------------------------------------------------------------
	   (on ^id (A B) ^verity T ^time (9 10))
	   (empty ^id (H) ^verity t ^time (9 10))   ;;;
	   ))))

(defun p ()
  (setq observations*
	'(((block ^id B ^verity T ^time (1 10))
	   (block ^id C ^verity T ^time (1 10))
	   (table ^id D ^verity T ^time (1 10))
	   (hand ^id H ^verity T ^time (1 10))
	   (ontable ^id (C D) ^verity T ^time (1 10))
; ------------------------------------------------------------
	   (empty ^id (H) ^verity T ^time (1 2))
	   (clear ^id (B) ^verity T ^time (1 8))
	   (ontable ^id (B D) ^verity T ^time (1 2))
; ------------------------------------------------------------
;	   (pickup ^id (B D) ^time (2 3))
; ------------------------------------------------------------
	   (holding ^id (H B) ^verity T ^time (3 4))
	   (clear ^id (C) ^verity T ^time (1 4))
; ------------------------------------------------------------
;	   (stack ^id (B C) ^time (4 5))
; ------------------------------------------------------------
	   (on ^id (B C) ^verity T ^time (5 10))
	   (empty ^id (H) ^verity t ^time (5 10))
	   ))))

(defun q ()
  (setq observations*
	'(((block ^id A ^verity T ^time (1 10))
	   (block ^id B ^verity T ^time (1 10))
	   (block ^id C ^verity T ^time (1 10))
	   (table ^id D ^verity T ^time (1 10))
	   (hand ^id H ^verity T ^time (1 10))
	   (ontable ^id (C D) ^verity T ^time (1 10))
; ------------------------------------------------------------
;	   (empty ^id (H) ^verity T ^time (1 2))   ;;;
;	   (clear ^id (B) ^verity T ^time (1 8))   ;;; !!!
	   (ontable ^id (B D) ^verity T ^time (1 2))
; ------------------------------------------------------------
;	   (pickup ^id (B D) ^time (2 3))
; ------------------------------------------------------------
	   (holding ^id (H B) ^verity T ^time (3 4))   ;;; ***
;	   (clear ^id (C) ^verity T ^time (1 4))   ;;; !!!
; ------------------------------------------------------------
;	   (stack ^id (B C) ^time (4 5))
; ------------------------------------------------------------
	   (on ^id (B C) ^verity T ^time (5 10))
;	   (empty ^id (H) ^verity t ^time (5 6))   ;;;
;	   (clear ^id (A) ^verity T ^time (1 10))   ;;; !!!
	   (ontable ^id (A D) ^verity T ^time (1 6))
; ------------------------------------------------------------
;	   (pickup ^id (A D) ^time (6 7))
; ------------------------------------------------------------
	   (holding ^id (H A) ^verity T ^time (7 8))
;	   (clear ^id (B) ^verity T ^time (1 8))     [Redundant]
; ------------------------------------------------------------
;	   (stack ^id (A B) ^time (8 9))
; ------------------------------------------------------------
	   (on ^id (A B) ^verity T ^time (9 10))
;	   (empty ^id (H) ^verity t ^time (9 10))   ;;;
	   ))))
