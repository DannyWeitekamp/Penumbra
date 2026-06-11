; *** Need to fix this bug. 
; Here (CLEAR ^ID (B) ^TIME (*1 *2)) was abduced earlier. When the
; two HOLDING beliefs are merged, the end time for CLEAR should be
; replaced with 9 as well.  

; Focus: (ON ^ID (A B) ^VERITY T ^TIME (9 10))
; Firing 5
; (BLOCK ^ID A ^VERITY T)
; (BLOCK ^ID B ^VERITY T)
; (HAND ^ID H ^VERITY T)
; (CLEAR ^ID (B) ^VERITY T ^TIME (*1 *2))
; (HOLDING ^ID (H A) ^VERITY T ^TIME (*9 *2))
; (EMPTY ^ID (H) ^VERITY T ^TIME (9 *10))
; (ON ^ID (A B) ^VERITY T ^TIME (9 10))
;  => (STACK ^ID (A B) ^TIME (*2 9)) [0.71428573]
; Elaborated worlds: w
; Merging (HOLDING ^ID (H A) ^VERITY T ^TIME (*9 *2))
; with (HOLDING ^ID (H A) ^VERITY T ^TIME (7 8))
; Updating (PICKUP ^VERITY T ^ID (A D) ^TIME (6 7))
; Updated  (PICKUP ^VERITY T ^ID (A D) ^TIME (6 7))
; Updating (PICKUP ^VERITY T ^ID (A D) ^TIME (6 7))
; Updated  (PICKUP ^VERITY T ^ID (A D) ^TIME (6 7))
; Status of old belief: OBSERVED
; Status of new belief: ABDUCED
; Updating w [0.7714286] <5>

; *** Need to fix this bug. 
; This rule instance should NOT be selected for application because
; (ON ^ID (B C) ^VERITY T ^TIME (5 10)) is already an observed belief,
; so a more specific instance should match and have a better score. 
; *** Also need to remove (ON ^time (*2 *3) when conflict detected. 

; Focus: (CLEAR ^ID (C) ^VERITY T ^TIME (1 4))
; Firing 3
; (BLOCK ^ID B ^VERITY T)
; (BLOCK ^ID C ^VERITY T)
; (HAND ^ID H ^VERITY T)
; (CLEAR ^ID (C) ^VERITY T ^TIME (1 4))
; (HOLDING ^ID (H B) ^VERITY T ^TIME (3 4))
; (EMPTY ^ID (H) ^VERITY T ^TIME (*2 2))
; (ON ^ID (B C) ^VERITY T ^TIME (*2 *3))
;  => (STACK ^ID (B C) ^TIME (4 *2)) [0.85714287]
; Elaborated worlds: w
; Merging (ON ^ID (B C) ^VERITY T ^TIME (*2 *3))
; with (ON ^ID (B C) ^VERITY T ^TIME (5 10))
; Status of old belief: OBSERVED
; Status of new belief: ABDUCED
; Updating w [0.85714287] <3>

; Need to fix multiple problems with definition selection, including: 
; 
; 1. Finding matches that omit the focus belief, which should be 
;    part of each one. (Done)
; 2. Finding different numbers of partial matches for rules with the
;    same number of conditions (but this may be related to item 1). 
; 3. Filtering mechanism not eliminating matches that it should, 
;    at least for ALL-MATCHED, which leaves some partial matches. (Done)
; 
; Each should be corrected before returning to efficiency of matching. 

; Need to fix two refraction-related problems that are causing time 
; per inference cycle to grow with size of working memory: 
; 
; 1. Alter REMOVE-SUBMATCHES to retrieve justifications stored with
;    each definition rather than searching linearly through the global 
;    variable JUSTIFICATIONS*. 
; 2. Either remove NONREPEATED entirely (which appears to cause extra
;    rule firings) or alter it to retrieve rule instances stored with
;    beliefs that they produced as derivations. (Removed. Not needed?)
; 
; In longer term, explore the idea of storing all partial matches 
; with each definition, removing ones that are applied (along with
; partial variants of them), and expanding the list only when new
; beliefs produce them. This is similar in spirit to Rete networks'
; technique of storing rule instances with rule nodes, removing them
; after they are fired, and readded them only if one or more of their
; matched elements are refreshed. 

; *** Deconflict world-dmatches and world-justifications, along with
;     related confusions.

; *** Incorporate update-world into functions for conflict repair. 
;     Need to index dmatches by beliefs on which they depend and 
;     remove them along with dependent beliefs. 

; *** Close world if inconsistent belief depends on zero assumptions? No. 
;     This can't be right or we could never generate multiple parses. 

; *** REMOVE CLOSED WORLDS BEFORE CREATING CHILDREN FROM CONFLICTS AND
;     BEFORE ADDING BELIEFS DURING ELABORATION. [Done?]
;     MOREOVER, REPLACE CLOSED WORLDS WITH CHILDREN FOR ALL BELIEFS
;     NOT INVOLVED IN THE CONFLICT. [Done]
;     ALSO, ONLY PRINT BELIEFS THAT APPEAR IN ACTIVE WORLDS. [Done]
;     Check with "The old man the boats" sentence. 

; For each world P in which a conflict occurs, 
;     Create two children C1 and C2 of P
;     For each nonbelief N in W, remove W from N, add C1 and C2 to N
;     Copy beliefs and nonbeliefs of P to C1 and C2
;     Remove conflict-related beliefs from C1 and C2

; *** When generating children of world W, copy beliefs associated with
;     W and store them with the new children. Also update the worlds 
;     associated with these beliefs. 

; *** Apparent bug that appears in incremental TOWER2.LISP run in which,
;     after skolemized (TOWER A B) is removed for violating a constraint, 
;     the unskolemized (TOWER A B) is added after (STACK A B) has been
;     observed. The system should detect the conflict again but does 
;     not. Reproduce this bug by allowing repeated inferences by 
;     commenting out (NONREPEATED MATCHES) in FILTER-MATCHES. 
;     [A variant still occurs on the garden path trace, in which a 
;     skolemized (TOWER A B2) is never eliminated because its score
;     is so low that it never attracts attention. 

; *** Add parameter to calculate score for each world. Should this be
;     called only on creation or after each elaboration? Can we update
;     the score after each belief added or removed from a world? 

; *** When firing a rule, ensure that any matched but assumed beliefs 
;     are stored as supporters for the derived head. 

; *** Upon merging a new belief N with an old one O, retrieve all beliefs
;     that O supports and replace skolems with constants based on the 
;     new to old mapping, doing this recursively for all beliefs that
;     are derived from O. [Mostly done, but need to update any other 
;     assumptions generated by same rule firing that share skolems] 

; *** Upon merging a new belief with an old one, eliminate assumptions 
;     on which the old one depends but add new ones if they exist. 

; *** Implement merging of skolemized and observed beliefs (see item 1
;     below). [Done] (But item 2 may NOT yet be done.] 

; *** Incorporate TEST-MATCHES into DETECT-CONFLICTS-AUX2 (e.g., to
;     handle neq relations) and uncomment it in FIND-MATCHES-AUX. 
;     Should we also modify TEST-MATCHES to work on single matches?  

; *** Support negated conditions that are not yet present, treating
;     them as default assumptions that make score worse. [Done?] 

; *** Add filters to rule definition selection to eliminate any
;     matches that would derive negation of belief that exists in
;     relevant worlds. We might do the same to avoid deriving an
;     existing belief in a new way.
;     But what if negated belief exists in some worlds but not others? 
;     That should count in the evaluation score but not forbid firing. 

; **********************************************************************
; EXPLAIN.LISP
; Abductive inference code for incremental explanation
; Pat Langley
; (c) Institute for the Study of Learning and Expertise 2017
; **********************************************************************

; Revise code to handle beliefs with skolems as arguments: 
; 
; 1. If the focus belief is observed and unifies with another belief
;    that includes skolems, replace the latter with the former. 
; 2. If the system applies a rule that matches against elements 
;    with skolems that are bound elsewhere in the rule, replace 
;    the skolemized beliefs with instantiated versions. Ie., ensure 
;    that rule matching includes beliefs with skolem arguments and 
;    replaces them with constants that appear in other beliefs. 
; 3. Use the number of skolem arguments in a belief to bias the 
;    selection of a focus belief or introduce a hard constraint 
;    to filter out candidates with too many skolems. [Done]
; 
; The first two items take a greedy approach to the problem, which 
; could make incorrect decisions. In the longer term, we should 
; encode each world as a set of generic beliefs and a bindings list, 
; either of which can be extended or retracted in children. 
; (Should this also apply to numeric constraints?) 

; Need to address immediate problems:  
; a. Deactivate worlds that include an assumption or derivation that
;    conflicts with an observed belief. When a violated constraint 
;    leads to creation of child worlds but only one child depends 
;    on assumed beliefs, deactivate the other child because it is
;    inconsistent with observations. [Done]
;    [An alternative would be to not create a child world for the 
;     problematic assumed beliefs.]  
; b. Find out why VP rule does not fire on cycle 4, even when the 
;    belief (NP1 (A CAT) CAT 7 10) is the focus. [Because the NP1 
;    structure does not lead to VP1's retrieval.] [Done] 
; c. Revise matcher to detect same belief with different arg order. [Done] 
; d. Keep rule instances from applying repeatedly on same cycle, 
;    especially when matching off abduced beliefs created by earlier
;    applications of the same rule. [No longer happening, but why?]
; e. Add list of assumable predicates. [Done]

; Still need to: 
; 0. Define printing functions to reveal structures after runs. 
; 1. Use contents of BELIEFS* to select focus of attention and beliefs
;    stored with GENERICS* during rule matching. Limit the former to
;    a fixed length, using the command
;    (setf (cdr (nthcdr (- (length beliefs*) n) beliefs*)) nil)
;    to remove elements at the end when N new elements are added or
;    refreshed during rule application. 
; 2. Modify CREATE-BELIEF to check for, and merge with, existing beliefs. 
;    Also use this function to update worlds. 
; 3. Define DETECT-CONFLICTS and ELIMINATE-CONFLICT. [Done] 
; 4. Define RANK-WORLDS and associated evaluation criterion. 
; 5. Incorporate Will's idea as a parametric option. 
; 6. Use constraints to inherit predicate names (e.g., NP for NP1). [Done]
; 7. Add empirical constraints that do not specify a head (e.g., to 
;    state that an object cannot be in two places at the same time). 

; EFFORT* is a system parameter that specifies the maximum number
; of inference cycles used to process a round of observations. 

(defvar effort*)
; (setq effort* 100000000)
(setq effort* 5)

; CYCLE* is the number of observation cycles that have occurred 
; since the start of processing. 

(defvar cycle*)

; FIRED* is the number of definitional rules that have been applied
; since the start of processing. 

(defvar fired*)

; FIRED-LIST* is the number of definitional rules applied since the
; start of processing in a series of runs. 

(defvar fired-list*)

; CPU-FIRED* is the total CPU time that has been taken to select and
; apply definitional rules in a run. This does not include time to 
; select a focus belief, detect and resolve conflicts, or to decide
; no definition should be selected. 

(defvar cpu-fired*)

; CPU-FIRED-LIST* is a list of CPU times per definitional rules in 
; a series of runs. 

(defvar cpu-fired-list*)

; CPU-CONNECTED* is the CPU time taken to retrieve definitions with an 
; antecedent that unifies with the focus belief. 

(defvar cpu-connected*)

(defvar cpu-connected-list*)

; CPU-MATCHED* is the CPU time taken to find all matches of retrieved
; definitions and return these instantiations. This does NOT include
; the time to score and filter those matches. 

(defvar cpu-matched*)

(defvar cpu-matched-list*)

; CPU-REMOVED* is the CPU time taken to eliminate duplicate matches
; that have been applied on earlier cycles. 

(defvar cpu-removed*)

(defvar cpu-removed-list*)

; CPU-REPEATED* is the CPU time taken to eliminate matches with heads
; that already appear as beliefs. 

(defvar cpu-repeated*)

(defvar cpu-repeated-list*)

; CONFLICTS* is the number of constraint violations the system has
; detected since the start of processing. 

(defvar conflicts*)

; DETECTED* is the number of constraint violations the system has
; detected since the start of processing. 

(defvar detected*)

; RESOLVED* is the number of constraint violations the system has
; resolved since the start of processing. 

(defvar resolved*)

; FOCUS-MEMORY* is a list of focus beliefs in reverse order of when
; the received attention. 

(defvar focus-memory*)

; OPEN* is the list of open worlds that are still in contention. 

(defvar open*)

; CLOSED* is the list of closed worlds that violate some constraint. 

(defvar closed*)

; WROOT* is a global variable that denotes the initial (root) world. 

(defvar wroot*)

; Worlds

(defvar world-count*)

; With a distributed representation, we may not need to stores beliefs, 
; and nonbeliefs with each world. 

; (defstruct world name beliefs nonbeliefs dmatches score parent children)
(defstruct world name beliefs nonbeliefs justifications score recency 
                 parent children)

; Beliefs

; Each belief structure has content (a predicate, id, and set of attribute
; value pairs, a generic version of the belief, start and end cycles, a 
; status (observed, derived, abduced), a list of worlds in which it does
; NOT hold, a list of supporting belief sets (terminal nodes in a proof
; tree), and a list of beliefs that it supports directly. 
; 
; Note: For now, assume content field is simply a relational literal. 

(defvar beliefs*)

(defstruct belief content generic start end status worlds score recency 
                  uses supporters supports justifications)

; Definitional rules

(defvar definitions*) 
(setq definitions* nil)

; Each rule has fields for a head, conditions, tests, variables, score, 
; and generics. The latter contains generic analogs to each condition 
; and bindings between these conditions and their analogs. The score is 
; a number that can be used during rule selection. One interpretation
; is that it denotes the probability of a rule instance appearing in 
; any given world. 

; (defstruct definition head conditions generics tests variables matches) 

(defstruct definition head conditions tests variables score generics
                      justifications)

; Should we store all matches found so far with the rule itself? 
; How can we ensure none of them are regenerated later? 

(defvar generics*)
(setq generics* nil)

; A GENERIC structure specifies a relational pattern (a predicate 
; with zero or more variables) like (on ?x ?y), and a set of beliefs
; that match that pattern, along with their bindings. These bindings
; refer to variables in the generic pattern. The structure also
; includes a list of definitional rules in which it appears as an
; antecedent or consequent, as well as a list of constraints.

(defstruct generic pattern beliefs definitions constraints) 

(defstruct match matched rule bindings score)

; A justification specifies a conclusion (head), a set of beliefs that
; support it, and the instantiated rule that link them. 

(defvar justifications*)

(defstruct justification head supporters definition match worlds score)

; Mutual exclusivity constraints

(defvar constraints*)
(setq constraints* nil)

(defstruct constraint head options binds tests) 

(defvar exclusives*)
(setq exclusives* nil) 

; Also need to define structures for rule instances of both types

(defstruct dmatch rule bindings) 

; A CMATCH specifies a set of mutually exclusive beliefs, the worlds
; in which they both hold, the constraint that states they cannot
; occur together, and bindings of that constraint.

(defstruct cmatch choices worlds rule bindings)

; UNRESPONSIVE* is a global variable that contains beliefs that have
; been selected as the focus but have not led to either detection of an
; inconsistency or application of a definitional rule. This keeps the
; system from selecting a belief repeatedly as a focus when this has
; no effect. Once either of these happens, the variable is set to NIL,
; making the beliefs available again. 

(defvar unresponsive*)

(defvar ignorables*)

; ASSUMABLES* specifies a list of predicates that may be assumed 
; during the explanation process. 

(defvar assumables*)

; EXPLAIN inputs two (optional) integers that specify the desired number 
; of observation cycles and the desired number of inferences cycles 
; after each observation. The function returns a ranked list of worlds
; that do not violate any (detected) constraints. 

(defun explain (&optional (n 1) (k effort*))
  (setq cycle* 1)
  (setq fired* 1)
  (setq cpu-fired* 0.0)
  (setq cpu-connected* 0.0)
  (setq cpu-matched* 0.0)
  (setq cpu-removed* 0.0)
  (setq cpu-repeated* 0.0)
  (setq detected* 0)
  (setq resolved* 0)
  (setq unresponsive* nil)
  (setq focus-memory* nil)
  (setq skolem-count* 0)
  (setq beliefs* nil)
  (mapc #'(lambda (g) (setf (generic-beliefs g) nil)) generics*)
  (setq conflicts* nil)
  (setq justifications* nil)
  (setq world-count* 1)
  (setq wroot* (make-world :name "w" :score 0.0))
  (setq open* (list wroot*))
  (setq closed* nil)
  (explain-aux n k))

(defun cexplain (&optional (n -1) (k effort*))
  (explain-aux (+ cycle* n) k))

; Outer loop observes more facts when inner loop runs out of resources
; or produces no inferences. Inner loop selects and applies a rule
; repeatedly until it runs out of resources or quiesces, checking
; before each rule application for constraint violations, which in 
; turn lead to world splits.
; Should also halt early if no more inferences suggest themselves.
; When elaboration returns no new beliefs or if it has run for EFFORT*
; cycles, then it applies FUNCALL to OBSERVE* to generate a new set
; of observations.  
; 
; Q. Do we need to set halt flag if nothing observed or should we 
;    continue until cycles run out? 

; NOTE: The global variable OBSERVE* takes as its value a function 
;       which returns a set of ground literals that encode facts. 
;       This function may walk through a list of lists of literals, 
;       read them from a file, or interface to a simulator. 

; Q. Should we store justifications on a global variable or instead 
;    with each belief created in APPLY-RULE? The latter seems more
;    useful for belief removal during world forking. 

(defun explain-aux (n k)
  (do () 
      ((> cycle* n)
;      (terpri)(princ cycle*)(princ " > ")(princ n)
       (decf cycle*)
       (decf fired*)
       (cond ((not (null ctrace*))
	      (rank-worlds open*)
	      (print-statistics))))
      (say-cycle)
      (let ((count 1)
	    (selected-rule t)
	    (observed (mapcar #'(lambda (o) (create-belief o 'observed nil))
			      (funcall observe*))))
;	(say-beliefs)
	(do ()
	    ((or (> count k) (null selected-rule)) nil)
;	    (say-beliefs)
	    (let ((focus (select-focus beliefs*)))
	      (cond ((not (null focus))
		     (say-focus focus)
		     (let* ((conflicts (detect-conflicts focus))
			    (conflict (cond ((null conflicts) nil)
					    (t (select-conflict conflicts)))))
		       (cond ((not (null conflict))
			      (setq unresponsive*
				    (set-difference unresponsive*
						    (cmatch-choices conflict)
						    :test 'equal))
			      (eliminate-conflict conflict))
			     ((eq (belief-status focus) 'abduced)
			      (push (belief-content focus) unresponsive*))
			     (t (let* ((cpu-apply (cpu-seconds))
				       (match (select-match focus)))
				  (cond ((not (null match))
					 (setq unresponsive*
					       (set-difference unresponsive*
							(match-matched match)
							:test 'equal))
					 (apply-rule match)
					 (setq fired* (1+ fired*))
;				         (update-beliefs match)
					 (update-uses (match-matched match))
;					 (push match justifications*)
					 (incf cpu-fired*
					       (- (cpu-seconds) cpu-apply)))
					(t (push (belief-content focus)
						 unresponsive*))))))))
		     (t (say-no-focus)
			(setq count k))))
	      (incf count))
	(incf cycle*))))

; UPDATE-USES inputs a list of belief contents, retrieves the belief 
; structure for each one, and increments the count in its :USES field. 
; This keeps track of how many rule firings a belief as taken part in. 

(defun update-uses (contents)
  (do* ((cnext (car contents) (car contents))
	(bnext (retrieve-belief cnext) (retrieve-belief cnext)))
      ((null contents) nil)
      (setf (belief-uses bnext) (1+ (belief-uses bnext)))
      (pop contents)))

(defvar bmax*)
(setq bmax* 20)

; Actually, this may not be needed. We can just take the first BMAX*
; elements of BELIEFS* and work from them. In fact, we can make this
; a parameter that uses different filtering strategies, such as taking
; the first BMAX* elements or only elements within BMAX* cycles of 
; the current one. 

(defun update-beliefs (new)
  (cond ((> (length beliefs*) bmax*)
	 (let ((clip (- bmax* (length new))))
	   (setf (cdr (nthcdr clip beliefs*)) nil)))))

; NOTE: This function should no longer be necessary, but can we ensure
;       that applying definitional rules will have the effect of unifying
;       skolems with variables that are already bound? This seems likely
;       if we consider both rule instances that unify them and ones that
;       do not. Strategies that favor eager unification can be balanced 
;       by detection of constraint violation when it does not work out. 

; MERGE-BELIEFS inpurs a list of new beliefs and a list previous beliefs. 
; If it finds any new beliefs that unify with previous ones, it updates
; the latter (e.g., by replacing skolems with constants or other skolems
; by marking them as observed rather than as derived or assumed) and
; alters rule instances associated with those beliefs (e.g., by updating 
; their bindings and scores). The function returns a reduced set of
; new beliefs that appear to be genuninely new.

; (defun merge-beliefs (new beliefs) ...)

; OBSERVE* is a system parameter that specifies how to obtain a 
; new set of observed elements. 

(defvar observe*)
(setq observe* 'observe-list)

(defvar observations*)
(setq observations* nil)

; OBSERVE-LIST returns the first list of observed elements in the
; list of list OBSERVATIONS*, setting the latter to its CDR. 

(defun observe-list ()
  (cond ((null observations*) nil)
	(t (pop observations*))))

; CREATE-BELIEF inputs a ground literal (e.g., (on a b)) and a type 
; (observed, derived, abduced). It returns a belief structure with
; that literal in its :content field, a generic version in its
; :generic field, and the current observation cycle in its :recency
; field. The function also updates the :beliefs field of the generic
; structure to include the new belief.

; Q. Should it also compute and store bindings to generic variables? 

; (defun create-belief (content status worlds)
;   (let* ((generic (car (member (car content) generics* :test 'geq)))
; 	 (belief (make-belief :content content 
; 			      :status  status
; 			      :worlds  worlds 
; 			      :generic generic
; 			      :recency cycle*)))
;     (cond ((not (member belief beliefs* :test 'same-contents))
; 	   (push belief beliefs*)
; 	   (setf (generic-beliefs generic)
; 		 (cons belief (generic-beliefs generic)))))
;     belief))

; New version of CREATE-BELIEF that handles negated beliefs as well as
; regular (positive) ones. 
; 
; Need to modify function to see whether an existing belief unifies
; with the new one and, if so, merge the structures. This could be 
; dangerous, but it is a reasonable first step.

(defun create-belief (content status worlds)
  (let ((predicate (car content))
	(verity (member '^verity content)))
;   (cond ((eq (car content) 'not) (setq predicate (caadr content)))
;	  (t (setq predicate (car content))))
    (cond ((null verity)
	   (setf (cdr content) (cons '^verity (cons t (cdr content))))))
    (let* ((generic (car (member predicate generics* :test 'geq)))
	   (belief (make-belief :content content 
				:status  status
				:worlds  worlds 
				:generic generic
				:uses    0
				:recency fired*))
	   (existing (member belief beliefs* :test 'matches-contents)))
;     (terpri)(princ "Creating belief ")(princ content)
      (cond ((not (null existing))
	     (setq existing (car existing))
	     (cond ((equal (belief-content belief) (belief-content existing))
		    (update-belief belief status))
		   (t (merge-belief belief existing))))
;	    ((not (member belief beliefs* :test 'same-contents))
	    (t (push belief beliefs*)
; Revise to store new belief with :nonbeliefs field of each W in WORLDS, 
; but also store with :beliefs field of (SET-DIFFERENCE *OPEN WORLDS). 
;	       (mapc #'(lambda (w) (setf (world-beliefs w)
;					 (cons belief (world-beliefs w))))
;		     worlds)
	       (mapc #'(lambda (w) (setf (world-nonbeliefs w)
					 (cons belief (world-nonbeliefs w))))
		     worlds)
	       (mapc #'(lambda (w) (setf (world-beliefs w)
					 (cons belief (world-beliefs w))))
		     (set-difference open* worlds))
	       (cond ((not (null generic))
		      (setf (generic-beliefs generic)
			    (cons belief (generic-beliefs generic)))))))
      belief)))

; MATCHES-CONTENTS inputs two belief structures. The function returns T 
; if the content of the second belief matches the content of the first
; belief when skolems are treated as variables. 

; (defun matches-contents (b1 b2)
;   (unify-one (belief-content b2) (belief-content b1) nil))

(defun matches-contents (b1 b2)
  (let ((match (unify-one (belief-content b2) (belief-content b1) nil)))
    (cond ((and (not (null match))
		(consistent-times (match-matched match)
				  (match-bindings match)))
	   match))))

(defun consistent-times (content bindings)
 (let ((interval (member '^time content)))
   (cond ((null interval) t)
	 (t (setq interval (subst-all bindings (cadr interval)))
	    (and (numberp (car interval))
		 (numberp (cadr interval))
		 (< (car interval) (cadr interval)))))))

; MATCHES-CONTENT is similar to MATCHES-CONTENTS but assumes the first
; argument is a literal rather than a belief structure. 

(defun matches-content (b1 b2)
  (unify-one b1 (belief-content b2) nil))

; UPDATE-BELIEF inputs an existing new belief structure, updates its
; status, uses, and recency fields, and returns the modified belief. 
; The function resets the USES field to zero to encourage the system
; to attend to it again.  

(defun update-belief (belief status)
  (say-updating belief)
  (setf (belief-status belief) status)
; (setf (belief-uses belief) (1+ (belief-uses belief)))
  (setf (belief-uses belief) 0)
; (terpri)(princ "Unresponsives before:")
; (mapc #'(lambda (b) (terpri)(princ b)) unresponsive*)
  (setq unresponsive* (remove (belief-content belief) unresponsive*
			      :test 'equal))
; (terpri)(princ "Unresponsives after:")
; (mapc #'(lambda (b) (terpri)(princ b)) unresponsive*)
  (setf (belief-recency belief) fired*)
  belief)

(defun say-updating (belief)
  (cond ((not (null ctrace*))
	 (terpri)(princ "Updating ")(princ (belief-content belief)))))

(defun say-updated (belief)
  (cond ((not (null ctrace*))
	 (terpri)(princ "Updated  ")(princ (belief-content belief)))))

; MERGE-BELIEF inputs a new belief structure and an old structure. 
; The function replaces fields of the old belief with those of the
; new one, then returns the modified old structure. 

; (defun merge-belief (new old)
;  (say-merging new old)
;  (merge-supporters old (match-bindings (matches-contents new old)))
;  (setf (belief-content old) (belief-content new))
;  (terpri)(princ "Changing status of ")(princ (belief-content old))
;  (terpri)(princ "from ")(princ (belief-status old))
;  (setf (belief-status old) (belief-status new))
;  (princ " to ")(princ (belief-status new))
;  (setf (belief-worlds old) (belief-worlds new))
;  (setf (belief-uses old) (1+ (belief-uses old)))
;  (setf (belief-recency old) (belief-recency new))
;  old)

(defun merge-belief (new old)
  (say-merging new old)
; (terpri)(princ "Matching ")(princ (belief-content old))
; (terpri)(princ "with     ")(princ (belief-content new))
; (terpri)(princ (matches-contents new old))
  (let ((bindings (match-bindings (matches-contents new old))))
    (merge-supporters old bindings)
    (setf (belief-content old)
	  (subst-all bindings (belief-content old)))
;   (cond ((not (eq (belief-status old) (belief-status new)))
    (terpri)(princ "Status of old belief: ")(princ (belief-status old))
    (terpri)(princ "Status of new belief: ")(princ (belief-status new))
    (cond ((and (eq (belief-status old) 'abduced)
		(not (eq (belief-status new) 'abduced)))
	   (terpri)(princ "Changing status of ")(princ (belief-content old))
	   (terpri)(princ "from ")(princ (belief-status old))
	   (princ " to ")(princ (belief-status new))
	   (setf (belief-status old) (belief-status new))))
    (setf (belief-worlds old) (belief-worlds new))
    (setf (belief-uses old) (1+ (belief-uses old)))
    (setf (belief-recency old) (belief-recency new))
    old))

(defun merge-supporters (belief bindings)
  (let ((supporters (belief-supports belief)))
    (do ((snext (car supporters) (car supporters)))
	((null supporters) nil)
	(say-updating snext)
	(setf (belief-content snext)
	      (subst-all bindings (belief-content snext)))
	(say-updated snext)
	(merge-supported snext bindings)
	(pop supporters))))

(defun merge-supported (belief bindings)
  (say-updating belief)
  (setf (belief-content belief)
	(subst-all bindings (belief-content belief)))
  (setf (belief-supporters belief)
	(winnow-supporters (belief-supporters belief)))
  (setf (belief-worlds belief)
	(union-of-worlds (belief-supporters belief)))
  (say-updated belief)
  (mapc #'(lambda (b) (merge-supported b bindings))
	(belief-supports belief)))

; WINNOW-SUPPORTERS inputs a list of supporting beliefs that may have
; been merged and returns a possibly reduced list that contains only
; assumed (abduced) beliefs. 

(defun winnow-supporters (supporters)
  (cond ((null supporters) nil)
	((eq (belief-status (car supporters)) 'abduced)
	 (winnow-supporters (cdr supporters)))
	(t (cons (car supporters) (winnow-supporters (cdr supporters))))))

(defun say-merging (new old)
  (cond ((not (null ctrace*))
	 (terpri)(princ "Merging ")(princ (belief-content new))
	 (terpri)(princ "with ")(princ (belief-content old)))))

; SAME-CONTENTS inputs two belief structures. The function returns T 
; if the literals in each belief's content fields are equal. 

(defun same-contents (b1 b2)
; (terpri)(princ (belief-content b1))
; (princ " ~ ")(princ (belief-content b2)) 
; (princ " = ")(princ (equal (belief-content b1) (belief-content b2)))
  (equal (belief-content b1) (belief-content b2)))

; GEQ inputs a predicate (e.g., on) and a generic structure. The
; function returns T if the predicate equals the car of :pattern 
; for the generic structure.

(defun geq (predicate generic)
  (eq predicate (car (generic-pattern generic))))

; CREATE-WORLD inputs an existing world structure and creates a new 
; world structure, storing the former as parent of the latter and the
; latter as a child of the former, with the child inheriting the score
; of the parent. The function returns the new world. 

(defun create-world (pworld)
  (let* ((cworld (make-world :name (name-world pworld)
			     :parent pworld)))
;			     :score (world-score pworld)
;			     :recency fired*)))
    (setf (world-children pworld) (cons cworld (world-children pworld)))
    (push cworld open*)
    cworld))

; NAME-WORLD inputs a WORLD and generates a unique name for a new 
; child that encodes its position in the phylogenetic tree. The name
; of the root is simply "world", its children would be "world.1",
; "world.2", ..., and their children would be "world.1.1", "world.1.2", 
; "world.2.1", and so forth.

(defun name-world (world)
  (let ((parent-name (world-name world))
        (child-count (length (world-children world))))
    (setq world-count* (1+ world-count*))
    (concatenate 'string parent-name "."
                 (write-to-string (1+ child-count)))))

; NOTE: This should also support application of rules that connect
;       existing beliefs but introduce no new ones. However, its 
;       parent function expects it to return a nonnull list. 
;       This should include existing derived heads, which we need
;       to check for existence before creating. 
; Q. Do we need to separate rule instances that have applied and 
;    ones that are still unused? 
; A. Yes, and we need to incorporate new beliefs into them when 
;    possible, rather than using them to create new rule instances. 

; APPLY-RULE inputs a definitional match and a set of beliefs. The
; function generates an instantiated head and body for the rule, then
; returns the subset that is not present in the existing beliefs.

; NOTE: Need to generate belief structures from belief contents. 
;       This should also determine the worlds in which they hold. 

; Q. Do we need to specify 'equal as the test for intersection? 
; A. No. We need to a unification function that lets skolem terms
;    match anything if done consistently. 
;    We also need to generate skolem terms for unmatched variables, 
;    whether in the conditions or the head. 

; (defun apply-rule (match beliefs)
;   (let* ((bindings (match-bindings match))
; 	   (head (definition-head (match-rule match)))
; 	   (conditions (definition-conditions (match-rule match)))
; 	   (results (subst-all bindings (cons head conditions)))
; 	   (new (infer-new results (match-matched match))))
;     (say-applied new)
;     (intersection results beliefs)))

; (defun apply-rule (match)
;   (setq fired* (1+ fired*))
;   (let* ((rule (match-rule match))
; 	 (bindings (match-bindings match))
; 	 (unbound (unbound-variables (definition-variables rule) bindings))
; 	 (skolems (bind-to-skolems unbound))
; 	 (bindings (append bindings skolems))
; 	 (head (subst-all bindings (definition-head rule)))
; 	 (conditions (subst-all bindings (definition-conditions rule)))
; 	 (ccopy conditions)
; 	 (matched (match-matched match))
; 	 (mbeliefs (mapcar #'(lambda (m) (retrieve-belief m)) matched))
; 	 (worlds (union-of-worlds mbeliefs))
; 	 (hbelief (create-belief head 'derived worlds))
; 	 (abeliefs nil))
;     (say-applied (cons head conditions))
;     (do ((cnext (car ccopy) (car ccopy)))
; 	((null ccopy)
; 	 (update-supports hbelief mbeliefs abeliefs) nil)
; 	(let ((match (already-present cnext matched bindings)))
; 	  (cond ((null match)
; 		 (push (create-belief cnext 'abduced worlds) abeliefs))
; 		(t nil)))
; 	(pop ccopy))))

(defun apply-rule (match)
; (setq fired* (1+ fired*))
  (let* ((rule (match-rule match))
	 (bindings (match-bindings match))
	 (unbound (unbound-variables (definition-variables rule) bindings))
	 (skolems (bind-to-skolems unbound))
	 (bindings (append bindings skolems))
	 (head (subst-all bindings (definition-head rule)))
	 (conditions (subst-all bindings (definition-conditions rule)))
	 (ccopy conditions)
	 (matched (match-matched match))
	 (mbeliefs (mapcar #'(lambda (m) (retrieve-belief m)) matched))
	 (worlds (union-of-worlds mbeliefs))
	 (abeliefs nil))
    (say-applied (cons head conditions) (match-score match))
    (cond ((not (null utrace*))
	   (terpri)(princ "Elaborated worlds:")
	   (mapc #'(lambda (w) (princ " ")(princ (world-name w)))
		 (set-difference open* worlds))))
;   (mapc #'(lambda (w) (update-world match w)) (set-difference open* worlds))
    (do ((cnext (car ccopy) (car ccopy)))
	((null ccopy)
	 (let ((hbelief (create-belief head 'derived worlds)))
	   (create-justification hbelief (append mbeliefs abeliefs) match
				 rule (set-difference open* worlds))
	   (update-supports hbelief mbeliefs abeliefs)))
	(let ((match (already-present cnext matched bindings)))
	  (cond ((null match)
;		 (terpri)(princ cnext)(princ " is not present.")
		 (push (create-belief cnext 'abduced worlds) abeliefs))
		(t nil)))
;		   (merge-beliefs match 'abduced worlds))))
	(pop ccopy))))

; (defun memequal (x y)
;   (member x y :test 'equal))

; UPDATE-WORLD inputs a match and a world. The function adds the match
; to the list of matches stored with that world and computes the world's
; score using the parameter SCORE-WORLD*, which is set to a function.  

; (defun update-world (match world)
;   (cond ((not (null utrace*))
; 	 (terpri)(princ "Updating ")(princ (world-name world))
; 	 (setf (world-dmatches world) (cons match (world-dmatches world)))
; 	 (setf (world-score world) (funcall score-world* world))
; 	 (princ " [")(princ (world-score world))(princ "]"))))

(defun update-world (just world)
  (setf (world-justifications world)
	(cons just (world-justifications world)))
; (cond ((not (null utrace*))
;	 (terpri)(princ "Adding justification for ")
;	 (princ (belief-content (justification-head just)))
;	 (princ " to ")(princ (world-name world))))
  (setf (world-score world) (funcall score-world* world))
; (setf (world-recency world) fired*)
  (setf (world-recency world) (greatest-recency (world-beliefs world) 0))
  (cond ((not (null utrace*))
	 (terpri)(princ "Updating ")(princ (world-name world))
	 (princ " [")(princ (world-score world))(princ "]")
	 (princ " <")(princ (world-recency world))(princ ">"))))

(defun greatest-recency (beliefs recency)
  (cond ((null beliefs) recency)
;	((eq (car (belief-content (car beliefs))) 'not)
	((negated (belief-content (car beliefs)))
	 (greatest-recency (cdr beliefs) recency))
	((> (belief-recency (car beliefs)) recency)
	 (greatest-recency (cdr beliefs) (belief-recency (car beliefs))))
	(t (greatest-recency (cdr beliefs) recency))))

; SCORE-WORLD* is the parameter that controls caculation of the score
; for each match of a definitional rule. 

(defvar score-world*)

(setq score-world* 'average-just-score)

; AVERAGE-MATCH-SCORE inputs a world and returns the average score of
; the matched definitions associated with it. 

; (defun average-match-score (world)
;   (let* ((matches (world-dmatches world))
; 	 (scores (mapcar #'match-score matches)))
;     (/ (apply #'+ scores) (length scores))))

; AVERAGE-JUST-SCORE inputs a world and returns the average score of
; the justifications (instantiated definitions) associated with it. 

(defun average-just-score (world)
  (let* ((justifications (world-justifications world))
	 (scores (mapcar #'justification-score justifications)))
    (/ (apply #'+ scores) (length scores))))

; UPDATE-SUPPORTS inputs a derived belief, a set of matched beliefs, 
; and a set of abduced beliefs associated with a rule application. 
; The function updates the :supports field for the matched and abduced
; beliefs to show they support the derived belief. It also updates the
; :supported field of the derived belief to include the abduced beliefs
; and all abduced beliefs on which the matched ones depend. 

; NOTE: Because a belief may have multiple justifications, we should 
;       really store a LIST of lists in the head's :supported field. 
; Question: Should we also store supporters for abduced beliefs? They
;       would not exist if matched beliefs had not been inferred. Or 
;       is this handled by making the head their supporter? 

(defun update-supports (head matched abduced)
  (mapc #'(lambda (b) (cond ((not (member head (belief-supports b)
					  :test 'same-contents))
			     (setf (belief-supports b)
				   (cons head (belief-supports b))))))
	matched)
  (mapc #'(lambda (b) (setf (belief-supports b) (list head))) abduced)
  (do ((mnext (car matched) (car matched)))
      ((null matched) 
;     (terpri)(princ "Supporters for ")(princ (belief-content head))(princ ":")
;     (mapc #'(lambda (a) (terpri)(princ (belief-content a))) abduced)
       (setf (belief-supporters head) abduced))
      (cond ((eq (belief-status mnext) 'abduced)
	     (push mnext abduced))
	    (t (setq abduced (append (belief-supporters mnext) abduced))))
      (pop matched)))

; CREATE-JUSTIFICATION inputs a belief, a list of supporting beliefs, the
; match on which these are based, the definition involved, and a list of
; worlds for which the matched definition holds. The function creates 
; a new justification, indexes it by its supporting beliefs, and adds
; it to the global variable JUSTIFICATIONS*. 

(defun create-justification (belief supports match rule worlds)
  (let ((just (make-justification :head belief :supporters supports
				  :definition rule :match match 
				  :worlds worlds :score (match-score match))))
;   (mapc #'(lambda (b) (setf (belief-justifications b)
;			      (cons just (belief-justifications b))))
;	  supports)
    (setf (belief-justifications belief)
	  (cons just (belief-justifications belief)))
;   (cond ((not (null utrace*))
;	   (terpri)(princ "Adding justification for ")
;	   (princ (belief-content belief))))
    (mapc #'(lambda (w) (update-world just w)) worlds)
    (setf (definition-justifications rule)
	  (cons just (definition-justifications rule)))
    (push just justifications*)))

; RETRIEVE-BELIEF takes a relational literal as input and returns the
; belief structure with which it is associated. 

(defun retrieve-belief (content)
  (car (member content beliefs* :test 'same-content)))

; UNION-OF-WORLDS inputs a list of beliefs. The function finds the
; worlds associated with each element (those in which it does NOT
; hold) and returns their union. 

(defun union-of-worlds (beliefs) 
  (union-all (mapcar #'(lambda (b) (belief-worlds b)) beliefs)))

; (defun union-of-worlds (beliefs) 
;   (union-all (mapcar #'retrieve-worlds beliefs)))

; (defun retrieve-worlds (content)
;   (let ((belief (car (member content beliefs* :test 'same-content))))
;     (belief-worlds belief)))

; SAME-CONTENT inputs a relational literal and a belief structure. The
; function returns T if the literal equals the literal in the belief's
; :content field. 

(defun same-content (content belief)
  (equal content (belief-content belief)))

(defun subset-content (content belief)
  (same-att-values content (belief-content belief)))

(defun same-att-values (b1 b2)
  (cond ((eq (car b1) (car b2))
	 (same-att-aux (cdr b1) (cdr b2)))))

(defun same-att-aux (b1 b2)
  (cond ((null b1) t)
	(t (let* ((att1 (car b1))
		  (val1 (cadr b1))
		  (analog (member att1 b2)))
;	     (terpri)(princ val1)(princ " =?= ")(princ (cadr analog))
	     (cond ((and (not (null analog))
			 (equal (cadr analog) val1))
		    (same-att-aux (cddr b1) b2)))))))

; UNION-ALL inputs a list of lists, e.g., (union-all '((a b) (b c) (c d))). 
; The function returns the union of all their elements, e.g., '(a b c d). 

(defun union-all (sets)
  (cond ((null sets) nil)
	(t (union (car sets) (union-all (cdr sets))))))

; ALREADY-PRESENT returns NIL if a condition does not match any member 
; of a set of elements and the match structure if it does. 

(defvar existing*)

(defun already-present (condition elements bindings)
  (cond ((null elements) nil)
	((setq existing* (unify-one condition (car elements) bindings))
	 existing*)
	(t (already-present condition (cdr elements) bindings))))

; MERGE-BELIEFS inputs a match structure (with content and bindings) 
; and a belief type. The function finds the corresponding belief 
; structure in BELIEFS*, merges information in the bindings, and 
; updates the belief's status and recency fields. 

; NOTE: Need to take union of worlds for old and new beliefs. This
;       function is not operational anyway and should be completed. 

(defun merge-beliefs (match type worlds)
  (let ((content (match-*** match))
	(bindings (match-bindings match))
	(beliefs beliefs*))
    (do ((bnext (car beliefs) (car beliefs)))
	((equal (belief-content bnext) content)
	 (merge-beliefs-aux bnext content bindings type))
	(pop beliefs))))

(defun merge-beliefs-aux (old content bindings type)
  (setf (belief-content old) (rsubst bindings content))
  (setf (belief-status old) type)
; (setf (belief-status old) (union (list type) (belief-status old)))
  (setf (belief-recency old) fired*)
  old)

; UNBOUND-VARIABLES inputs a list of variables and a list of bindings. 
; The function returns the sublist of variables that are unbound.  

(defun unbound-variables (variables bindings)
  (cond ((null variables) nil)
	((assoc (car variables) bindings)
	 (unbound-variables (cdr variables) bindings))
	(t (cons (car variables)
		 (unbound-variables (cdr variables) bindings)))))

; BIND-TO-SKOLEMS inputs a list of unbound variables and returns a
; list of dotted pairs in which the CAR is a variable and the CDR 
; is a unique, newly generated skolem. 

(defun bind-to-skolems (variables)
  (mapcar #'(lambda (v) (cons v (generate-skolem))) variables))

(defvar skolem-symbol*)
(setq skolem-symbol* "*")

(defvar skolem-count*)
(setq skolem-count* 0)

; GENERATE-SKOLEM increments the skolem counter and returns a new atom
; that starts with the skolem symbol and ends with the updated count. 

(defun generate-skolem ()
  (incf skolem-count*)
; (intern (concatenate 'string skolem-symbol*
  (intern (concatenate 'string "*" 
		       (write-to-string skolem-count*))))

; **********************************************************************
; Functions for detecting and resolving constraint violations
; **********************************************************************
 
; We need a parameters that specify: 
; 1. How thoroughly to check for violations
; 2. Which violation to focus on if more than one found
; 3. How to handle detected conflicts (e.g., remove most recent 
;    element or fork worlds). 

; DETECT-CONFLICTS inputs a single belief that is the current focus of
; attention. The function retrieves all constraints with a condition 
; that unifies with it and returns all conflicts between this belief

; and other beliefs. Each element in the returned list is a conflict
; structure that specifies the conflicting beliefs, a constraint, and
; a set of bindings. 

; Should DETECT-CONFLICTS only check elements generated on the latest
; cycle for constraint violations? This seems unlikely. 

; (defun detect-conflicts (focus)
;   (let ((connected (constraint-connected focus))
; 	(conflicts nil))
;     (do ((cnext (car connected) (car connected)))
; 	((null connected) conflicts)
; 	(setq conflicts
; 	      (append (detect-conflicts-aux cnext) conflicts))
; 	(pop connected))))

(defun detect-conflicts (focus)
  (let ((constraints constraints*)
	(conflicts (detect-temporal-conflicts focus)))
    (do ((cnext (car constraints) (car constraints)))
;	((null constraints)
;	 (remove-duplicates conflicts))
	((null constraints) conflicts)
	(setq conflicts
	      (append (detect-conflicts-aux focus cnext) conflicts))
	(pop constraints))))

; DETECT-TEMPORAL-CONFLICTS inputs a focus belief. The function compares
; it to other beliefs and, if any of them are identical except for 
; their time interval and if the two intervals are inconsistent, it
; returns a list of such conflicts. 

; Retrieve other beliefs with same predicate
; Compare in terms of content
; If equal content, then compare intervals
; If inconsistent, then add to conflict list
; (make-cmatch :choices focus ...)

(defun detect-temporal-conflicts (focus)  
  (let ((others (generic-beliefs (belief-generic focus)))
	(conflicts nil))
    (do ((bnext (car others) (car others)))
	((null others) conflicts)
	(cond ((eq bnext focus) nil)
	      ((and (same-relation (belief-content bnext)
				   (belief-content focus))
		    (inconsistent-times (belief-content bnext)
					(belief-content focus)))
	       (let ((c (make-cmatch :choices (list focus bnext)
				 :worlds (find-shared-worlds focus bnext))))
		 (cond ((and (not (null (cmatch-worlds c)))
			     (not (member c conflicts*
					  :test 'same-conflict)))
			(say-time-conflict focus bnext)
			(push c conflicts*)
			(push c conflicts))))))
	(pop others))))

; SAME-RELATION inputs the contents of two beliefs and returns T if 
; their predicates, verity value, and id value are equal. 

(defun same-relation (content1 content2)
  (and (eq (car content1) (car content2))
       (eq (cadr (member '^verity content1))
	   (cadr (member '^verity content2)))
       (equal (cadr (member '^id content1))
	      (cadr (member '^id content2)))))
  
; INCONSISTENT-TIMES inputs the contents of two beliefs and returns T
; if there is any overlap (inclusive) between the associated intervals. 
; The function ignores start and end times that are skolems. 

; (between ?s1 ?s2 ?e2)))  [3 5] [2 4]  (between 3 2 4)
; (between ?s2 ?s1 ?e1)))  [2 4] [3 5]  (between 3 2 4)
; (between ?e1 ?s2 ?e2)))  [2 4] [3 5]  (between 3 2 4)
; (between ?e2 ?s1 ?e1)))  [3 5] [2 4]  (between 3 2 4)
; 
; The first two and last two tests seem redundant but they are needed
; to handle cases in which some of the times are skolems. 

(defun inconsistent-times (content1 content2)
  (let ((int1 (cadr (member '^time content1)))
	(int2 (cadr (member '^time content2))))
    (cond ((betweenp (car int1) (car int2) (cadr int2)) t)
	  ((betweenp (car int2) (car int1) (cadr int1)) t)
	  ((betweenp (cadr int1) (car int2) (cadr int2)) t)
	  ((betweenp (cadr int2) (car int1) (cadr int1)) t))))

(defun betweenp (x y z)
  (and (numberp x) (numberp y) (numberp z)
       (<= y x) (<= x z)))

; DETECT-CONFLICTS-AUX inputs a focus belief and a constraint. The
; function iterates through existing beliefs and returns a list of 
; CMATCH structures that specify which other beliefs, if any, conflict
; with the focus belief.

(defun detect-conflicts-aux (focus constraint)
; (terpri)(princ "Testing constraint: ")(princ (constraint-head constraint))
  (let ((options (constraint-options constraint))
	(ocopy (constraint-options constraint))
	(content (belief-content focus))
	(results nil))
    (do ((onext (car options) (car options)))
	((null options)
	 results)
	(let ((match (unify-one onext content nil)))
	  (cond ((not (null match))
		 (setq results
		       (append (detect-conflicts-aux2 focus
						 (remove onext ocopy)
				                 (match-bindings match)
						 constraint)
			       results)))))
	(pop options))))

; DETECT-CONFLICTS-AUX2 inputs a focus belief, a constraint, and a set
; of bindings. The function returns a list of CMATCH structures that 
; specify which other beliefs, if any, conflict with the focus belief. 

; Note: This code does not ensure that FOCUS and ONEXT unify with 
;       different mutually exclusive options in CONSTRAINT. 

; (defun detect-conflicts-aux2 (focus constraint bindings)
;   (terpri)(princ "Aux2: ")
;   (let ((beliefs beliefs*)
; 	(results nil))
;     (do ((bnext (car beliefs) (car beliefs)))
; 	((null beliefs) results)
; 	(cond ((not (eq bnext focus))
; 	       (terpri)(princ (belief-content bnext))
; 	       (let ((options (constraint-options constraint)))
; 		 (do ((onext (car options) (car options)))
; 		     ((null options) nil)
; 		     (let ((match (unify-one onext (belief-content bnext)
; 					     bindings)))
; 		       (cond ((not (null match))
; 			      (let ((c (make-cmatch :rule constraint
; 					    :choices (list focus bnext)
; 					    :bindings (match-bindings match))))
; 				(cond ((not (member c conflicts*
; 						    :test 'same-conflict))
; 				       (say-conflict focus bnext constraint)
; 				       (push c results)))))))
; 		     (pop options)))))
; 	(pop beliefs))))

(defun detect-conflicts-aux2 (focus options bindings constraint)
; (terpri)(princ "Aux2: ")
  (let ((beliefs beliefs*)
	(tests (constraint-tests constraint))
	(results nil))
    (do ((bnext (car beliefs) (car beliefs))
	 (ocopy options options))
	((null beliefs) results)
	(cond ((not (eq bnext focus))
;	       (terpri)(princ (belief-content bnext))
	       (do ((onext (car ocopy) (car ocopy)))
		   ((null ocopy) nil)
		   (let ((match (unify-one onext (belief-content bnext)
					   bindings)))
;		     (cond ((not (null match))
;			    (terpri)(princ "Bindings: ")
;			    (princ (match-bindings match))))
		     (cond ((and (not (null match))
;				 (bound-tests-satisfied tests
				 (all-tests-satisfied tests 
					      (match-bindings match)))
			    (let ((c (make-cmatch :choices (list focus bnext)

				       :worlds (find-shared-worlds focus bnext)
				       :rule     constraint
				       :bindings (match-bindings match))))
			      (cond ((and (not (null (cmatch-worlds c)))
					  (not (member c conflicts*
						       :test 'same-conflict)))
				     (say-conflict focus bnext constraint)
				     (push c conflicts*)
				     (push c results)))))))
		   (pop ocopy))))
	(pop beliefs))))

; The next function is not needed since we can use REMOVE-DUPLICATES, 
; which is already defined in Common Lisp. 

; REMOVE-REPLICATES inputs a list of conflicts and returns a reduced list
; that contains no duplicates. The function uses the 'SAME-CONFLICTS test
; to determine membership. 

; (defun remove-replicates (conflicts)
;   (let ((results nil))
;     (do ((cnext (car conflicts) (car conflicts)))
; 	((null conflicts) results)
; 	(pop conflicts)
; 	(cond ((not (member cnext conflicts :test 'same-conflict))
; 	       (push cnext results))))))

; (defun same-conflict (x y)
;   (and (eq (cmatch-rule x) (cmatch-rule y))
;        (same-set (cmatch-choices x) (cmatch-choices y))))

(defun same-conflict (x y)
  (and (eq (cmatch-rule x) (cmatch-rule y))
       (equal (cmatch-choices x) (cmatch-choices y))))

(defun same-conflict (x y)
  (equal (mapcar #'belief-content (cmatch-choices x))
	 (mapcar #'belief-content (cmatch-choices y))))

; (defun same-conflict (x y)
;   (let ((xc (mapcar #'belief-content (cmatch-choices x)))
; 	  (yc (mapcar #'belief-content (cmatch-choices y))))
;     (terpri)(princ "******************")
;     (terpri)(princ xc)(terpri)(princ yc)
;     (equal xc yc)))

(defun same-set (state1 state2)
  (not (set-exclusive-or state1 state2 :test 'equal)))

(defun say-conflict (focus belief constraint)
  (cond ((not (null ctrace*))
	 (terpri)(princ "Detected conflict between ")
	 (terpri)(princ (belief-content focus)) 
	 (princ " and ")(terpri)
	 (princ (belief-content belief))
	 (terpri)(princ "in constraint ")
	 (princ (constraint-head constraint)))))

(defun say-time-conflict (focus belief)
  (cond ((not (null ctrace*))
	 (terpri)(princ "Detected conflict between ")
	 (terpri)(princ (belief-content focus)) 
	 (princ " and ")(terpri)
	 (princ (belief-content belief))
	 (terpri)(princ "due to overlapping time intervals"))))

; CONSTRAINT-CONNECTED and CONSTRAINT-CONNECTED-ONE are not used. 

; (defun constraint-connected (focus)
;   (let* ((generic (belief-generic focus))
; 	 (content (belief-content focus))
; 	 (constraints (generic-constraints generic))
; 	 (connected nil))
;     (do ((cnext (car constraints) (car constraints)))
; 	((null cnext) connected)
; 	(setq connected
; 	      (append (constraint-connected-one content cnext) connected))
; 	(pop constraints))))

; CONSTRAINT-CONNECTED-ONE inputs a focus belief and a constraint. The
; function returns a list of constraint structures that specify the
; conflicting beliefs, a constraint, and a set of bindings.

; (defun constraint-connected-one (focus constraint)
;   (let ((options (constraint-options constraint))
; 	(results nil))
;     (do ((onext (car options) (car options)))
; 	((null options) results)
; 	(let ((match (unify-one onext focus nil)))
; 	  (cond ((not (null match))
; 		 (push (make-cmatch :rule constraint
; 				    :bindings (match-bindings match)
; 				    :choices (list focus))
; 		       results))))
; 	(pop options))))

(defvar filter-conflicts*)
(setq filter-conflicts* '(shared-worlds))

; FILTER-CONFLICTS inputs a list of filters (functions that take a 
; conflict as the single argument) and a list of conflicts. It returns
; the sublist of matches that return T on each filter. 

(defun filter-conflicts (filters conflicts)
  (let ((retained nil))
    (do ((cnext (car conflicts) (car conflicts)))
	((null conflicts) retained)
	(cond ((filter-conflict filters cnext)
	       (push cnext retained)))
	(pop conflicts))))

; FILTER-CONFLICT inputs a list of filters (functions that take a
; conflict as the single argument) and a single conflict. The function
; returns T if each filter returns T on the match and NIL otherwise.

(defun filter-conflict (filters conflict)
  (cond ((null filters) t)
	((funcall (car filters) conflict)
	 (filter-conflict (cdr filters) conflict))))

; SHARED-WORLDS inputs a conflict and returns T if the :worlds field
; is nonempty (i.e., the conflicting beliefs share one or more world).

(defun shared-worlds (conflict)
  (cond ((not (null (cmatch-worlds conflict))) t)))

(defvar select-conflict*)
(setq select-conflict* 'at-random)

(defun select-conflict (conflicts)
; (mapc score-conflict* conflicts)
  (funcall select-conflict* conflicts))

; ELIMINATE-CONFLICT inputs a conflict (a CMATCH structure) and resolves
; it by deactivating the inconsistent worlds in which it occur, creating
; child worlds, and removing assumptions and derivations that depend on
; them from the relevant children. The function returns NIL but alters
; the world history and some of its worlds. 

; NOTE: Also need to add negation of conflict to relevant worlds. 
; 
; NOTE: Do not let rule fire in a world where a belief occurs that 
;       matches the negation of its head or a needed assumption. 
;       Also incorporate this into evaluation function for rules.  

; NOTE: Modify to handle cases where one or both beliefs are observed. 

(defun eliminate-conflict (conflict) 
  (cond ((not (null ctrace*))
	 (terpri)(princ "Shared worlds:")
	 (mapc #'(lambda (w) (princ " ")(princ (world-name w)))
	       (cmatch-worlds conflict))))
  (let* ((choices (cmatch-choices conflict))
	 (belief1 (car choices))
	 (belief2 (cadr choices))
	 (shared-worlds (cmatch-worlds conflict))
	 (gak (change-status shared-worlds))
	 (worlds1 (find-cworlds belief1 shared-worlds))
	 (worlds2 (find-cworlds belief2 shared-worlds))
	 (assumed1 (belief-supporters belief1))
	 (assumed2 (belief-supporters belief2))
	 (shared (intersection assumed1 assumed2))
	 (unique1 (set-difference assumed1 shared))
	 (unique2 (set-difference assumed2 shared)))
    (incf resolved*)
    (cond ((not (null ctrace*))
	   (terpri)(princ "First supporters:")
	   (mapc #'(lambda (b) (terpri)(princ (belief-content b))) assumed1)
	   (terpri)(princ "Second supporters:")
	   (mapc #'(lambda (b) (terpri)(princ (belief-content b))) assumed2)
	   (terpri)(princ "Shared supporters:")
	   (mapc #'(lambda (b) (terpri)(princ (belief-content b))) shared)
	   (terpri)(princ "First difference:")
	   (mapc #'(lambda (b) (terpri)(princ (belief-content b))) unique1)
	   (terpri)(princ "Second difference:")
	   (mapc #'(lambda (b) (terpri)(princ (belief-content b))) unique2)))
;   (eliminate-from unique1 worlds2)
;   (negate-belief belief1 worlds2)
;   (eliminate-from unique2 worlds1)
;   (negate-belief belief2 worlds1)
    (cond ((eq (belief-status belief1) 'observed)
	   (setq open* (set-difference open* worlds2))
	   (setq closed* (append worlds2 closed*)))
	  (t (negate-belief belief1 worlds2 worlds1)))    
    (eliminate-from unique1 worlds2)
    (cond ((eq (belief-status belief2) 'observed)
	   (setq open* (set-difference open* worlds1))
	   (setq closed* (append worlds1 closed*)))
	  (t (negate-belief belief2 worlds1 worlds2)))
    (eliminate-from unique2 worlds1)
    (mapc #'update-after-removal worlds2)
    (mapc #'update-after-removal worlds1)))

; UPDATE-AFTER-REMOVAL updates the score and recency of a world by 
; calling the functions SCORE-WORLD* and GREATEST-RECENCY, which 
; finds the recency of its most recent belief.  

(defun update-after-removal (world)
  (let ((recency (greatest-recency (world-beliefs world) 0)))
    (setf (world-recency world) recency)
    (setf (world-score world) (funcall score-world* world))
    (cond ((not (null utrace*))
	   (terpri)(princ "Updating ")(princ (world-name world))
	   (princ " [")(princ (world-score world))(princ "]")
	   (princ " <")(princ recency)(princ ">")))))

(defun change-status (shared-worlds)
  (mapc #'(lambda (w) (setq open* (remove w open*))) shared-worlds)
  (setq closed* (append shared-worlds closed*))
  nil)

; FIND-CWORLDS inputs a belief involved in a constraint violation and
; a list of worlds in which it holds. The function deactivates these
; worlds, and, for each of them, it creates / activates two new worlds
; that are their children. It returns a list of child worlds in which 
; the belief should be abandoned.

; NOTE: We should generalize function to handle K conflicting beliefs. 

(defun find-cworlds (belief shared-worlds) 
  (let* ((children nil))
    (do ((snext (car shared-worlds) (car shared-worlds)))
	((null shared-worlds) children)
	(let ((child (create-world snext)))
	  (inherit-from snext child)
	  (push child children))
; Not clear if we want to remove beliefs from closed worlds
;	(setf (world-beliefs snext) nil)
	(pop shared-worlds))))

; INHERIT-FROM stores the beliefs associated with the world PARENT and
; stores them with one of its children, CHILD. The function also adds
; this child to the list of worlds associated with each of PARENT's
; nonbeliefs (ones in which they do NOT hold) and removes PARENT from
; each of them. In addition, it copies various fields from PARENT to
; CHILD.

(defun inherit-from (parent child)
  (let ((beliefs (world-beliefs parent))
	(nonbeliefs (world-nonbeliefs parent)))
;   (terpri)(princ "Number of beliefs in ")(princ (world-name parent))
;   (princ " is ")(princ (length beliefs))
    (setf (world-beliefs child) beliefs)
    (setf (world-nonbeliefs child) nonbeliefs)
    (setf (world-justifications child) (world-justifications parent))
;   (setf (world-recency child) (world-recency parent))
    (setf (world-score child) (world-score parent))
    (do ((bnext (car nonbeliefs) (car nonbeliefs)))
	((null nonbeliefs)
;        (terpri)(princ "Number of beliefs in ")(princ (world-name child))
;	 (princ " is ")(princ (length (world-beliefs child)))
	 nil)
;	(terpri)(princ "Adding ")(princ (world-name child))
;	(princ " to ")(princ (belief-content bnext))
	(setf (belief-worlds bnext)
	      (cons child
		    (remove parent (belief-worlds bnext))))
	(pop nonbeliefs))))

; FIND-SHARED-WORLDS inputs two beliefs and returns the set of worlds 
; in which both participate (as opposed to ones in which they do not). 

(defun find-shared-worlds (belief1 belief2)
  (let* ((nworlds1 (belief-worlds belief1))
	 (nworlds2 (belief-worlds belief2))
	 (pworlds1 (set-difference open* nworlds1))
	 (pworlds2 (set-difference open* nworlds2)))
;   (terpri)(princ "First worlds:")
;   (mapc #'(lambda (w) (princ " ")(princ (world-name w))) pworlds1)
;   (terpri)(princ "Second worlds:")
;   (mapc #'(lambda (w) (princ " ")(princ (world-name w))) pworlds2)
    (intersection pworlds1 pworlds2)))

; NEGATE-BELIEF inputs a belief B and a set of worlds W in which its 
; negation should not hold. The function removes B from members of W and
; creates a new belief (or retrieves an existing one) that is the negation 
; of B, storing the set of worlds in its :worlds field. 

(defun negate-belief (belief worlds1 worlds2)
  (let* ((content (belief-content belief))
	 (status (belief-status belief)))
;   (cond ((not (member (car worlds1) (belief-worlds belief)))
;	   (terpri)(princ "Eliminating ")(princ (belief-content belief))
;	   (princ " from")
;	   (mapc #'(lambda (w) (princ " ")(princ (world-name w))) worlds1)
;	   (setf (belief-worlds belief)
;		 (append worlds1 (belief-worlds belief)))))
    (mapc #'(lambda (w) (eliminate-from-aux belief w)) worlds1)
    (cond ((negated content)
	   (setq content (posate (copy-list content))))
	  (t (setq content (negate (copy-list content)))))
    (create-belief content status worlds2)))

; NEGATE inputs positive belief content (with T as its ^verity value)
; and returns a negated version of the content (with NIL as the value). 

(defun negate (content)
  (setf (cadr (member '^verity content)) nil)
  content)

; POSATE inputs negated belief content (with NIL as its ^verity value)
; and returns a positive version of the content (with T as the value). 

(defun posate (content)
  (setf (cadr (member '^verity content)) T)
  content)

; NEGATED inputs the content of a belief and returns T if its ^verity 
; value is NIL, indicated the belief does not hold. 

(defun negated (content)
  (eq (cadr (member '^verity content)) nil))

; ELIMINATE-FROM inputs a set of beliefs to be retracted and a set of 
; worlds from which to remove them. The function iterates through both
; sets, calling on ELIMINATE-FROM-AUX for each belief-world pair, then
; returns NIL, relying entirely on destructive effects. 

(defun eliminate-from (beliefs worlds)
  (do ((bnext (car beliefs) (car beliefs)))
      ((null beliefs) 
       (mapc #'(lambda (w)
		 (setf (world-score w) (funcall score-world* w))) worlds)
       nil)
;     (terpri)(princ "Eliminating ")(princ (belief-content bnext))
;     (princ " from ")
;     (mapc #'(lambda (w) (princ " ")(princ (world-name w))) worlds)
      (mapc #'(lambda (w) (eliminate-from-aux bnext w)) worlds)
      (pop beliefs)))

; ELIMINATE-FROM-AUX inputs a belief and a world in which to retract 
; it. The function adds the world to the belief's world field (those 
; worlds in which it does not hold) and calls itself recursively on
; those derived beliefs that the target belief supports directly. The
; function also removes belief from the world's :beliefs field and 
; adds it to the :nonbeliefs field. It returns NIL, relying entirely 
; on destructive effects. 

(defun eliminate-from-aux (belief world)
  (cond ((and (member world open*)
	      (not (member world (belief-worlds belief))))
	 (cond ((not (null ctrace*))
		(terpri)(princ "Eliminating ")(princ (belief-content belief))
		(princ " from ")(princ (world-name world))))
	 (setf (belief-worlds belief) (cons world (belief-worlds belief)))
	 (setf (world-beliefs world) (remove belief (world-beliefs world)))
	 (setf (world-nonbeliefs world)
	       (cons belief (world-nonbeliefs world)))
	 (remove-justifications belief world)))
  (let ((supported (belief-supports belief)))
;   (terpri)(princ "=============")(terpri)
;   (mapc #'(lambda (s) (terpri)(princ (belief-content s))) supported)
    (do ((snext (car supported) (car supported)))
	((null supported) nil)
	(eliminate-from-aux snext world)
	(pop supported))))

; REMOVE-JUSTIFICATIONS inputs a belief structure and a world structure. 
; The function retrieves the justifications stored with each and removes
; those in the former from those in the latter, updating the world's 
; relevant field to reflect these deletions. 

(defun remove-justifications (belief world)
  (let ((bjusts (belief-justifications belief))
	(wjusts (world-justifications world))
	(results nil))
    (do ((wjnext (car wjusts) (car wjusts)))
	((null wjusts)
	 (setf (world-justifications world) (reverse results)))
	(cond ((not (member wjnext bjusts :test #'same-head))
	       (push wjnext results)))
;	       (cond ((not (null utrace*))
;		      (terpri)(princ "Not removing justification for ")
;		      (princ (belief-content (justification-head wjnext)))
;		      (princ " from ")(princ (world-name world)))))
;	      ((not (null utrace*))
;	       (terpri)(princ "Removing justification for ")
;	       (princ (belief-content (justification-head wjnext)))
;	       (princ " from ")(princ (world-name world))))
	(pop wjusts))))

(defun same-head (just1 just2)
  (eq (justification-head just1) (justification-head just2)))

; REMOVE-CLOSED inputs a world W, removes W from the list of open worlds, 
; and, for each belief that did not hold in W, removes it from the list
; associated with that belief. This is a clean up function to eliminate
; records of a world once it has become closed. 

(defun remove-closed (world)
  (let ((beliefs (world-nonbeliefs world)))
    (do ((bnext (car beliefs) (car beliefs)))
	((null beliefs)
	 (setq open* (remove world open*)) nil)
	(setf (belief-worlds bnext) (remove world (belief-worlds bnext)))
	(pop beliefs))))

; **********************************************************************
; Functions for showing results after run has ended
; **********************************************************************

(defun get-best-match (matches)
  (car matches))

(defun rank-worlds (worlds)
  (setq worlds (sort worlds #'> :key #'world-score))
  (mapc #'(lambda (w)
	    (terpri)(princ (world-name w))
	    (princ " [")(princ (world-score w))(princ "] ")
	    (princ "{")(princ (world-recency w))(princ "}"))
	worlds)
  nil)

(defun show-worlds ()
  (terpri)(princ "-------------")
  (show-open)(show-closed) nil)

(defun show-open ()
  (setq open* (sort open* #'> :key #'world-score))
  (terpri)(princ "Open worlds:")(terpri)(princ "-------------")
  (mapc #'(lambda (w) (show-world w)(terpri)(princ "-------------"))
	open*) nil)

(defun show-closed ()
  (setq closed* (sort closed* #'> :key #'world-score))
  (terpri)(princ "Closed worlds:")(terpri)(princ "-------------")
  (mapc #'(lambda (w) (show-world w)(terpri)(princ "-------------"))
	closed*) nil)

(defun show-world (world)
  (terpri)(princ (world-name world))
  (princ " [")(princ (world-score world))(princ "]")
  (princ " <")(princ (world-recency world))(princ ">")
  (mapc #'(lambda (b) (show-held-belief b world)) beliefs*)
  nil)

; (defun show-held-belief (belief world)
;   (cond ((not (member world (belief-worlds belief)))
; 	 (terpri)(princ (belief-content belief)))))

(defun show-held-belief (belief world)
  (cond ((and (not (member world (belief-worlds belief)))
;	      (not (eq (car (belief-content belief)) 'not)))
	      (not (negated (belief-content belief))))
	 (terpri)(princ (belief-content belief)))))

(defun show-held-belief (belief world)
  (cond ((and (not (member world (belief-worlds belief)))
;	      (not (eq (car (belief-content belief)) 'not)))
	      (not (negated (belief-content belief))))
	 (let ((status (belief-status belief)))
	   (terpri)
	   (cond ((eq status 'observed) (princ "("))
		 ((eq status 'abduced) (princ "["))
		 ((eq status 'derived) (princ "{")))
	   (princ (car (belief-content belief)))
	   (mapc #'(lambda (x) (princ " ")(princ x))
		 (cdr (belief-content belief)))
	   (cond ((eq status 'observed) (princ ")"))
		 ((eq status 'abduced) (princ "]"))
		 ((eq status 'derived) (princ "}"))))))
  nil)

(defun print-statistics ()
  (terpri)(princ "Run statistics:")
  (terpri)(princ "  Number of definitions: ")(princ (length definitions*))
  (terpri)(princ "  Number of constraints: ")(princ (length constraints*))
  (terpri)(princ "  Number of observation cycles: ")(princ cycle*)
  (terpri)(princ "  Number of inferences made: ")(princ fired*)
  (terpri)(princ "  CPU time per inference: ")
  (format t "~,5F" (/ cpu-fired* fired*))
  (terpri)(princ "  CPU time per retrieval: ")
  (format t "~,5F" (/ cpu-connected* fired*))
  (terpri)(princ "  CPU time per match: ")
  (format t "~,5F" (/ cpu-matched* fired*))
  (terpri)(princ "  Number of conflicts detected: ")
  (princ (length conflicts*))
  (terpri)(princ "  Number of conflicts resolved: ")(princ resolved*)
  (terpri)(princ "  Number of total beliefs: ")(princ (length beliefs*))
  (terpri)(princ "  Number of open worlds: ")(princ (length open*))
  (terpri)(princ "  Number of closed worlds: ")(princ (length closed*))
  (terpri)(princ "  Best world found on cycle: ")
  (princ (best-cycle open* 0.0 1))
  (terpri)(princ "  Last world found on cycle: ")
  (princ (last-cycle open* 1))
  nil)

; BEST-CYCLE returns the cycle on which the best-scoring world was 
; last modified, breaking ties in favor of earlier cycles. 

(defun best-cycle (worlds score cycle)
  (cond ((null worlds) cycle)
	((> (world-score (car worlds)) score)
	 (best-cycle (cdr worlds)
		     (world-score (car worlds))
		     (world-recency (car worlds))))
	((= (world-score (car worlds)) score)
	 (cond ((< (world-recency (car worlds)) cycle)
		(best-cycle (cdr worlds) score 
			    (world-recency (car worlds))))
	       (t (best-cycle (cdr worlds) score cycle))))
	(t (best-cycle (cdr worlds) score cycle))))

; LAST-CYCLE returns the cycle on which the most recently modified
; world was altered. 

(defun last-cycle (worlds cycle)
  (cond ((null worlds) cycle)
	((> (world-recency (car worlds)) cycle)
	 (last-cycle (cdr worlds) (world-recency (car worlds))))
	(t (last-cycle (cdr worlds) cycle))))

; **********************************************************************
; Functions for finding matches of a given definitional rule
; **********************************************************************

; General strategy: 
; - First access the generalized condition the focus matches. 
; - Find bindings between condition and focus arguments. 
; - Find all rules that include this condition (possibly more than one
;   per rule). 
; - For each one, generate a partially instantiated rule based on 
;   the focus bindings. 
; - Return this list of rule instances.  

; SELECT-MATCH inputs a focus belief and a set of beliefs (including
; the focus). The function returns a single instantiated rule based
; on the ranking parameter RULE-SCORE*. 

; (defun select-match (focus definitions)
;   (let* ((connected (find-connected focus definitions))
; 	   (matches nil))
;     (do ((cnext (car connected) (car connected)))
; 	  ((null connected)
; 	   (get-best-match matches))
; 	  (setq matches (append (find-matches cnext) matches))
; 	  (pop connected))))

; SELECT-MATCH inputs a focus belief and a set of definitional rules. 
; The function finds a set of partial matches for these rules that are 
; anchored on the focus belief, assigns a score to each one using the 
; parametric function SCORE-MATCH*, and then calls another parametric 
; function, SELECT-MATCH*, to select a single partial match based on 
; these scores. The function returns this match structure, which has
; fields for matched elements and bindings. 

(defun select-match (focus)
  (let* ((connected (find-connected focus))
	 (cpu-matched nil)
	 (cpu-removed nil)
	 (matches nil))
;   (say-connected connected)
    (do ((cnext (car connected) (car connected)))
	((null connected)
	 (mapc score-match* matches)
;	 (say-matched matches "--Matches before filtering--")
	 (setq matches (filter-matches filter-match* matches))
	 (cond ((not (null matches))
;		(say-matched matches "--Matches after filtering--")
		(funcall select-match* matches))))
	(setq cpu-matched (cpu-seconds))
	(setq matches (append (find-matches focus cnext) matches))
;  (say-matched matches "--Matches before removing duplicates--")
	(incf cpu-matched* (- (cpu-seconds) cpu-matched))
	(setq cpu-removed (cpu-seconds))
	(setq matches (remove-submatches matches))
	(incf cpu-removed* (- (cpu-seconds) cpu-removed))
;  (say-matched matches "--Matches after removing duplicates--")
;  (terpri)(princ "==========")
	(pop connected))))

(defvar filter-match*)
(setq filter-match* '(some-constants some-connection nonassumables-matched))
; (setq filter-match* '(all-matched))
; (setq filter-match* '(nonassumables-matched))

; FILTER-MATCHES inputs a list of filters (functions that take a match
; as the single argument) and a list of matches. It returns the sublist 
; of matches that return T on each filter.

; Problem: This approach will let ALL-MATCHES and similar functions
; accept a partial match if the matched conditions bind all variables
; in the condition side. Need to eliminate this bug. Does it really 
; make sense to instantiate conditions here? 

; (defun filter-matches (filters matches)
; (setq matches (nonrepeated matches))
;   (let ((retained nil))
;     (do ((mnext (car matches) (car matches)))
; 	((null matches) retained)
; 	(let ((cnext (definition-conditions (match-rule mnext))))
; 	  (setq cnext (subst-all (match-bindings mnext) cnext))
; 	  (cond ((filter-match filters cnext)
; 		 (push mnext retained))))
; 	(pop matches))))

(defun filter-matches (filters matches)
; (setq matches (nonrepeated matches))
  (let ((retained nil))
    (do ((mnext (car matches) (car matches)))
	((null matches) retained)
	(cond ((filter-match filters mnext)
	       (push mnext retained)))
	(pop matches))))

; FILTER-MATCH inputs a list of filters (functions that take a match
; as the single argument) and a single instantiated set of conditions. 
; It returns T if each filter returns T on the match and NIL otherwise. 

(defun filter-match (filters match)
  (cond ((null filters) t)
	((funcall (car filters) match)
	 (filter-match (cdr filters) match))))

; NONREPEATED inputs a list of matches and returns only the ones for
; which the instantiated head is not already a member of BELIEFS*. 
; 
; NOTE: This was a temporary fix. The function REMOVE-SUBMATCHES 
;       supercedes it by checking to see if a rule instance has 
;       applied before. 

(defun nonrepeated (matches)
  (let ((retained nil)
	(cpu-repeated (cpu-seconds)))
    (do ((mnext (car matches) (car matches)))
	((null matches)
	(incf cpu-repeated* (- (cpu-seconds) cpu-repeated))
	 retained)
	(let ((mhead (subst-all (match-bindings mnext)
				(definition-head (match-rule mnext)))))
	  (cond ((not (member mhead beliefs* :test 'same-content))
		 (push mnext retained))))
	(pop matches))))

; ALL-MATCHED inputs a match and returns T only if each of its elements
; is already present in working memory (i.e., if each element is EQUAL
; to the content of some belief). [Old version, now replaced] 

; (defun all-matched (match)
;   (cond ((null match) t)
; 	((member (car match) beliefs* :test 'subset-content)
; 	 (all-matched (cdr match)))))

; ALL-MATCHED inputs a match and returns T only if the number of 
; matched elements is the same as the number of conditions in the
; matched definition, in which case the match is complete.  

(defun all-matched (match)
  (eq (length (match-matched match))
      (length (definition-conditions (match-rule match)))))

; (defun all-bound (match)
;   (all-bound-aux (match-bindings match)))

; (defun all-bound-aux (bindings)
;   (cond ((null bindings) t)
; 	((skolemp (cdar bindings)) nil)
; 	(t (all-bound-aux (cdr bindings)))))

; ALL-BOUND inputs a match structure. The function returns T if all
; of the variables associated with its rule have bindings. 

(defun all-bound (match)
  (null (unbound-variables (definition-variables (match-rule match))
			   (match-bindings match))))

; (defun all-but-one-bound (match)
;   (> 2 (length (unbound-variables (definition-variables (match-rule match))
; 				  (match-bindings match)))))

(defun all-but-one-bound (match)
  (> 2 (+ (number-of-skolem-bindings (match-bindings match) 0)
	  (length (unbound-variables (definition-variables (match-rule match))
				     (match-bindings match))))))

(defun number-of-skolem-bindings (bindings count)
  (cond ((null bindings) count)
	((skolemp (cdar bindings))
	 (number-of-skolem-bindings (cdr bindings) (1+ count)))
	(t (number-of-skolem-bindings (cdr bindings) count))))

; NONASSUMABLES-MATCHED inputs a match and returns T only if each of 
; its elements is either already present in working memory or if its
; predicate is assumable (on the ASSUMABLES* list). 

; (defun nonassumables-matched (match)
;   (cond ((null match) t)
; 	((member (car match) beliefs* :test 'subset-content)
; 	 (nonassumables-matched (cdr match)))
; 	((and (eq (caar match) 'not)
; 	      (not (unify-one (cadar match) beliefs* nil)))
; 	 (nonassumables-matched (cdr match)))
; 	((member (caar match) assumables*)
; 	 (nonassumables-matched (cdr match)))))

; NONASSUMABLES-MATCHED inputs a match and returns T only if each of 
; its elements matches against one of the associated rule's antecedents
; or if its predicate is assumable (on the ASSUMABLES* list). 

(defun nonassumables-matched (match)
  (nonassumables-matched-aux (match-matched match)
			     (definition-conditions (match-rule match))
			     (match-bindings match)))

(defun nonassumables-matched-aux (matched conditions bindings)
  (cond ((null conditions) t)
	((unify-one (car matched) (car conditions) bindings)
	 (nonassumables-matched-aux (cdr matched) (cdr conditions) bindings))
;	((and (eq (caar match) 'not)
;	      (not (unify-one (cadar match) beliefs* nil)))
;	 (nonassumables-matched (cdr match)))
	((member (caar matched) assumables*)
	 (nonassumables-matched-aux (cdr matched) (cdr conditions) bindings))))

; SOME-CONNECTION inputs a list of matched elements (belief contents)
; and returns T if, after removing ingnorable ones (with predicates
; in IGNORABLES*) has length two or greater. This ensures that firing
; the rule connects the focus belief with at least one other belief. 

; *** Need to update assuming argument is a MATCH structure. 

(defun some-connection (match)
  (> (length (remove-ignorables-and-nonbeliefs (match-matched match))) 1))

(defun remove-ignorables-and-nonbeliefs (match)
  (cond ((null match) nil)
	((member (caar match) ignorables*)
	 (remove-ignorables-and-nonbeliefs (cdr match)))
	((not (member (car match) beliefs* :test 'subset-content))
	 (remove-ignorables-and-nonbeliefs (cdr match)))
	(t (cons (car match) (remove-ignorables-and-nonbeliefs (cdr match))))))

; SOME-CONSTANTS returns T if every element in the :matched field of 
; MATCH contains at least one constant other than their predicate. 

; *** Need to update assuming argument is a MATCH structure. 

(defun some-constants (match)
  (some-constants-aux (match-matched match)))
; (some-constants-aux match))

(defun some-constants-aux (matched)
  (cond ((null matched) t)
	((not (nonskolems (cdar matched))) nil)
	(t (some-constants-aux (cdr matched)))))

(defun only-skolems (literal)
  (cond ((null literal) t)
	((nonskolem (cadr literal)) nil)
	(t (only-skolems (cddr literal)))))

; Not quite. Need to alternate between attributes and values. Return T
; as soon as one nonskolem found. 

(defun nonskolems (belief) 
  (cond ((null belief) nil)
	((consp (car belief))
	 (or (nonskolems (car belief))
	     (nonskolems (cdr belief))))
	((attributep (car belief))
	 (nonskolems (cdr belief)))
	((or (skolemp (car belief))
	     (varp (car belief)))
	 (nonskolems (cdr belief)))
	(t t)))

(defun nonskolem (belief) 
  (cond ((null belief) nil)
	((consp (car belief))
	 (or (nonskolem (car belief))
	     (nonskolem (cdr belief))))
	((attributep (car belief))
	 (nonskolem (cdr belief)))
	((skolemp (car belief))
	 (nonskolem (cdr belief)))
	(t t)))

; ATTRIBUTEP inputs an atom and returns T if it is not a number and if
; if starts with the attribute marker (^).

(defun attributep (x)
  (and (not (numberp x))
       (eq #\^ (char (string x) 0))))

; REMOVE-SUBMATCHES inputs a set of matches and returns the subset
; that do not already appear in the JUSTIFICATIONS* list.

; (defun remove-submatches (matches)
;   (let ((new nil))
;     (do ((mnext (car matches) (car matches)))
;         ((null matches) new)
;         (cond ((not (member mnext justifications* :test 'same-rule-match))
;                (push mnext new)))
;         (pop matches))))

; REMOVE-SUBMATCHES inputs a set of matches and returns the subset that 
; do not already appear in the JUSTIFICATIONS field of the definition
; involve in each match. 

(defun remove-submatches (matches)
  (let ((new nil))
    (do ((mnext (car matches) (car matches)))
	((null matches) new)
	(let ((justifications (definition-justifications (match-rule mnext))))
	  (cond ((not (member mnext justifications :test 'same-match))
		 (push mnext new))))
	(pop matches))))

; SAME-RULE-MATCH compares two match structures. The function returns T
; if their :definitions field is equal and if the :matched elements in
; the first as a subset of the :matched elements in the second.  
; 
; NOTE: Replaced with SAME-MATCH as defined below. 

(defun same-rule-match (m1 m2)
  (and (equal (match-rule m1) (match-rule m2))
       (subsetp (match-matched m1) (match-matched m2) :test 'equal)))

; SAME-MATCH inputs a match structure M and a justification, which has
; a match structure N in one of its fields. The function returns T if
; the :definitions field of M and N are equal and if the :matched
; elements in M is a subset of the :matched elements in N.

(defun same-match (m j)
  (and (equal (match-rule m) (match-rule (justification-match j)))
       (subsetp (match-matched m)
		(match-matched (justification-match j)) :test 'equal)))

; SCORE-MATCH* is the parameter that controls caculation of the score
; for each match of a definitional rule. 

(defvar score-match*)

; (setq score-match* 'number-unmatched)
(setq score-match* 'modified-score)

; NUMBER-MATCHED inputs a match and returns the number of matched 
; beliefs in its :MATCHED field. 

(defun number-matched (match)
  (setf (match-score match) (length (match-matched match))))

; NUMBER-UNMATCHED inputs a match and returns the negative of the 
; number of matched beliefs in its :MATCHED field. This score will
; vary from zero to -N, where N is the number of rule conditions. 

(defun number-unmatched (match)
  (setf (match-score match)
	(- (length (match-matched match))
	   (number-of-positives (match-rule match)))))
;	   (length (definition-conditions (match-rule match))))))

; NUMBER-OF-POSITIVES inputs a definitional rule and returns the number
; of positive conditions (those with a ^verity value of T). 

(defun number-of-positives (rule) 
  (let ((conditions (definition-conditions rule))
	(count 0))
    (do ((cnext (car conditions) (car conditions)))
	((null conditions) count)
	(cond ((not (null (cadr (member '^verity cnext))))
	       (incf count)))
	(pop conditions))))

; MODIFIED-SCORE inputs a match and returns the product of the rule's
; score and the proportion of its conditions that are matched. 

(defun modified-score (match)
  (setf (match-score match)
	(* (definition-score (match-rule match))
	   (/ (length (match-matched match))
	      (number-of-positives (match-rule match))))))
;	      (length (definition-conditions (match-rule match)))))))

(defvar select-match*)
(setq select-match* 'best-match-score)

; BEST-MATCH-SCORE returns the element of MATCHES with the highest 
; numeric score in its :SCORE field. If two or more matches tie for
; this honor, the function returns one of them at random. 

; (defun best-match-score (matches) 
;   (car (sort matches
;              #'(lambda (x y) (> (match-score x)
;                                 (match-score y))))))

(defun best-match-score (matches)
; (mapc #'(lambda (m)
;	    (terpri)(princ (match-matched m))
;	    (princ " [")(princ (match-score m))(princ "]")) matches)
  (let ((best-list (list (car matches)))
        (best-score (match-score (car matches))))
    (pop matches)
    (do ((next (car matches) (car matches)))
        ((null matches)
	 (at-random best-list))
	(cond ((= (match-score next) best-score)
	       (push next best-list))
	      ((> (match-score next) best-score)
	       (setq best-list (list next))
	       (setq best-score (match-score next))))
        (pop matches))))

(defun at-random (options)
  (nth (random (length options)) options))

; For a given focus belief, first find all rules with antecedents or 
; head that unify with it. 
; For each rule instance, attempt to merge it with all existing rule
; instances with the same head. 
; If any new rule instances cannot be merged, then add them to the list 
; of existing instances and return the expanded list. 

; Q. Are the comments above still relevant? 

; FIND-CONNECTED inputs a single belief that is the current focus of
; attention. The function retrieves all rules with an antecedent or
; consequents that unify with it and returns one partially instantiated 
; rule for each way the focus matches one of the rule's conditions. 
; Each element in the returned list should include the rule itself, 
; a set of bindings, and an empty list of matched beliefs.

; Assume that each rule includes a field with a list of generic 
; patterns that unify with its conditions, with each generic structure
; storing all existing beliefs that match against it. 
; Also assume that the global variable GENERICS* is a list of known 
; generic patterns, each of which stores beliefs that match it and 
; rules in which it appears. 

(defun find-connected (focus) 
  (let ((generic (belief-generic focus))
	(content (belief-content focus))
	(cpu-connected nil))
	(setq cpu-connected (cpu-seconds))
	(cond ((not (null generic))
	   (let ((rules (generic-definitions generic))
		 (connected nil))
	     (do ((rnext (car rules) (car rules)))
		 ((null rnext)
		  (incf cpu-connected* (- (cpu-seconds) cpu-connected))
		  connected)
		 (setq connected
		       (append (find-connected-one content rnext) connected))
		 (pop rules)))))))

; FIND-CONNECTED-ONE inputs a focus belief and a rule that includes
; at least one antecedent or consequent that unifies with it. The 
; function returns a list of MATCH structures in which all fields are
; empty except for bindings that specify how some condition matches 
; the belief. If two or more conditions match the belief, then it 
; returns a MATCH structure for each one.  

; Note: Also need to check head of definition. 

; (defun find-connected-one (focus rule)
;   (let ((conditions (definition-conditions rule))
; 	  (results nil))
;     (do ((cnext (car conditions) (car conditions)))
; 	  ((null conditions) results)
; 	  (let ((match (unify-one cnext focus nil)))
; 	    (cond ((not (null match))
; 		   (setf (match-matched match) nil)
; 		   (push match results))))
; 	  (pop conditions))))

(defun find-connected-one (focus rule)
  (let ((conditions (definition-conditions rule))
	(results nil))
;   (terpri)(princ "Rule: ")(princ (definition-head rule))
;   (terpri)(princ (definition-conditions rule))
    (do ((cnext (car conditions) (car conditions)))
	((null conditions) results)
	(let ((match (unify-one cnext focus nil)))
;	  (cond ((null match)
;		 (terpri)(princ ": No match")))
	  (cond ((not (null match))
;		 (terpri)(princ (match-bindings match))
		 (push (make-dmatch :rule rule
				    :bindings (match-bindings match))
		       results))))
	(pop conditions))))

; FIND-MATCHES inputs a definitional rule and a partial match, which
; is a list of match structures that include a set of bindings and a
; list of matched beliefs. For the top-level call, partials is a list 
; with a single match that has bindings from the focus element but 
; with an empty list of beliefs. The function returns the set of all
; complete matches that have consistent bindings, where skolems in
; beliefs can bind with any variable as long as they appear consistently.

; (defun find-matches (drule partial)
;   (let ((conditions (definition-conditions drule))
;	  (tests (definition-tests drule))
;	  (generics (definition-generics drule)))
;    (find-matches-aux conditions generics tests partial)))

(defun find-matches (focus dmatch)
  (let* ((drule (dmatch-rule dmatch))
	 (conditions (definition-conditions drule))
	 (tests (definition-tests drule))
	 (generics (definition-generics drule))
	 (partial (make-match :bindings (dmatch-bindings dmatch)
			      :rule drule)))
;   (terpri)(princ conditions)
;   (terpri)(mapc #'(lambda (g) (princ (generic-pattern g))) generics)
    (find-matches-aux focus conditions generics tests partial)))

; *** Need to store previous firings with definition and remove them
;     in FIND-MATCHES before returning results. 

; FIND-MATCHES-AUX inputs a set of rule conditions, a set of generic
; conditions that correspond to them, a set of mappings between their
; variables, and a partial match that includes a set of elements and 
; a set of bindings. The function returns the set of all complete
; matches that have consistent bindings, where skolems in beliefs can
; bind with any variable as long as it appears consistently. 
;
; Note: The result includes matches in which some (or even all) 
;       conditions are unmatched and in which some (or even all) 
;       of their variables remain unbound. 

; Q. Should we move TEST-MATCHES into FIND-MATCHES, which would call
;    it only after finding a set of structural matches? 

(defun find-matches-aux (focus conditions generics tests partial)
  (cond ((null conditions)
	 (cond ((bound-tests-satisfied tests (match-bindings partial))
		(list partial))
	       (t nil)))
	(t (let ((match (unify-one (car conditions)
				   (belief-content focus)
				   (match-bindings partial))))
	     (cond ((not (null match))
		    (find-matches-aux focus (cdr conditions)
				      (cdr generics) tests 
				      (combine-matches match partial)))
		   (t (let ((singles (retrieve-singles (car conditions)
					       (car generics)
					       (match-bindings partial)))
			    (extended nil))
			(do ((snext (car singles) (car singles)))
			    ((null singles)
			     (setq extended 
				   (append (find-matches-aux focus
						 (cdr conditions)
						 (cdr generics) tests partial)
					   extended)))
;			    (test-matches extended tests))
			    (setq extended 
				  (append (find-matches-aux focus
					      (cdr conditions)
					      (cdr generics) tests 
					      (combine-matches snext partial))
					  extended))
			    (pop singles)))))))))

; TEST-MATCHES inputs a list of match structures and a list of tests. 
; The function returns the subset of structures that satisfy all of
; the tests, ignoring ones with unbound or skolem variables. See 
; problem-solving code for how to handle the latter. 

(defun test-matches (matches tests)
  (let ((results nil))
    (do ((mnext (car matches) (car matches)))
	((null matches) results)
	(cond ((bound-tests-satisfied tests (match-bindings mnext))
	       (push mnext results)))
	(pop matches))))

; ALL-TESTS-SATISFIED inputs a list of tests and a list of variable 
; bindings. The function returns T if the arguments of each test are
; bound and if all tests are satisfied. 

(defun all-tests-satisfied (tests bindings)
  (all-tests-satisfied-aux (qsubst-all bindings tests)))

; (defun all-tests-satisfied-aux (tests)
;   (cond ((null tests) t)
; 	((and (not (unbound-test (car tests)))
; 	      (not (null (eval (car tests)))))
; 	 (all-tests-satisfied-aux (cdr tests)))))

(defun all-tests-satisfied-aux (tests)
  (cond ((null tests) t)
	((not (null (eval (car tests))))
	 (all-tests-satisfied-aux (cdr tests)))))

; Next functions are borrowed. May need to adapt. 

; BOUND-TESTS-SATISFIED inputs a list of generic tests and a list of 
; bindings. The function substitutes the latter into the former and 
; returns T only if all of the tests are satisfied, after replacing 
; any test with unbound variables with T (i.e., assuming it is true). 

(defun bound-tests-satisfied (tests bindings)
  (setq tests (qsubst-all bindings tests))
  (setq tests
        (mapcar #'(lambda (x) (cond ((unbound-test x) t) (t x))) tests))
  (not (null (eval (cons 'and tests)))))

(defun qsubst-all (bindings expression)
  (cond ((null bindings) expression)
        (t (subst (list 'quote (cdar bindings)) (caar bindings)
                  (qsubst-all (cdr bindings) expression)))))

(defun unbound-test (test)
  (cond ((null test) nil)
        ((listp (car test))
         (cond ((unbound-test (car test)) t)
               (t (unbound-test (cdr test)))))
        ((numberp (car test)) (unbound-test (cdr test)))
        ((eq #\? (char (string (car test)) 0)) t)
        ((eq #\* (char (string (car test)) 0)) t)
        (t (unbound-test (cdr test)))))

; COMBINE-MATCHES inputs a match structure based on a single condition
; and another based on a set of conditions. The function returns a 
; new match structure that combines the matched belief of the first
; with those of the second, as well as merging their variable bindings. 
; Note: The contents of SINGLE's :matched field is a single belief, 
; while the content of PARTIAL's :matched field is a list of beliefs. 

(defun combine-matches (single partial)
  (make-match :matched  (cons (match-matched single)
			      (match-matched partial))
	      :rule     (match-rule partial)
	      :bindings (match-bindings single)))

; COMBINE-BINDINGS is no longer necessary because RETRIEVE-SINGLES
; already combines prior bindings with new ones when it returns matches 
; for individual beliefs.

(defun combine-bindings (bindings1 bindings2)
  (cond ((null bindings1) bindings2)
	((assoc (caar bindings1) bindings2 :test 'equal)
	 (combine-bindings (cdr bindings1) bindings2))
	(t (combine-bindings (cdr bindings1)
			     (cons (car bindings1) bindings2)))))

; Need to update the next function to assume that beliefs are stored
; with a generalized version of the condition. 

; Assume that definitional rules include a field that contains a list
; of generic conditions. This will let the matcher access all relevant
; matches of individual beliefs against these conditions.

; Note: We do not need separate functions for handling positive and
;       negated conditions, as both positive and negated beliefs
;       can appear in working memory. If the latter are absent, then
;       they will be treated as default assumptions. 

(defun retrieve-singles (condition generic bindings)
; (let ((bindings (match-bindings partial))
  (let ((beliefs (generic-beliefs generic))
	(results nil))
    (do ((bnext (car beliefs) (car beliefs)))
	((null beliefs) results)
	(let ((match (unify-one condition (belief-content bnext) bindings)))
	  (cond ((not (null match))
		 (push match results))))
	(pop beliefs))))

; Should we modify UNIFY-ONE to handle skolems / variables in beliefs? 
; What should it return in this case? A unification list? 
; No. The function already handles variables in beliefs. E.g., 
; (unify-one '(on ?x ?y) '(on a ?z) nil)
; => 
; #S(MATCH :MATCHED (ON A ?Z) :BINDINGS ((?Y . ?Z) (?X . A)))
; If we use variables like ?Z for unbound terms when adding default 
; assumptions to belief memory, all should be fine. 

; However, we still need to modify UNIFY-ONE to handle "default" beliefs
; stored with generic structures. These should include wild cards for
; arguments that can match against anything. 

; (defun unify-one (condition wme bindings)
;   (let ((match (unify-aux condition wme bindings)))
;     (cond ((not (null match))
;            (make-match :matched wme :bindings (cdr match))))))

; Revised version of UNIFY-ONE

(defun unify-one (condition wme bindings)
  (cond ((eq (car condition) (car wme))
	 (let ((match (unify-att (cdr condition) (cdr wme) bindings)))
	   (cond ((not (null match))
		  (make-match :matched wme :bindings (cdr match))))))))

(defun unify-att (condition wme bindings)
  (cond ((null condition)
         (cons t bindings))
        (t (let* ((catt (car condition))
		  (cval (cadr condition))
		  (watt (member catt wme))
		  (wval (cadr watt)))
	      (cond ((null watt) nil)
		    ((and (consp cval) (consp wval))
		     (setq bindings (unify-aux cval wval bindings))
		     (cond ((null bindings) nil)
;			   (t (unify-att (cddr condition) wme bindings))))
			  (t (unify-att (cddr condition) wme (cdr bindings)))))
		    ((and (atom cval) (varp cval))
		     (setq bindings (unify-aux2 cval wval bindings))
		     (cond ((null bindings) nil)
			   (t (unify-att (cddr condition) wme bindings))))
		    ((and (atom wval) (varp wval))
		     (setq bindings (unify-aux2 cval wval bindings))
		     (cond ((null bindings) nil)
			   (t (unify-att (cddr condition) wme bindings))))
                   ((eq cval wval)
		    (unify-att (cddr condition) wme bindings)))))))

(defun unify-aux (x y bindings)
  (cond ((null x)
         (and (null y) (cons t bindings)))
        (t (let ((xnext (car x))
                 (ynext (car y)))
             (cond ((and (consp xnext) (consp ynext))
                    (setq bindings (unify-aux xnext ynext bindings))
                    (cond ((null bindings) nil)
                          (t (unify-aux (cdr x) (cdr y) (cdr bindings)))))
;		   ((wildp ynext)
;		    (unify-aux (cdr x) (cdr y) bindings))
                   ((and (atom xnext) (varp xnext))
                    (setq bindings (unify-aux2 xnext ynext bindings))
                    (cond ((null bindings) nil)
                          (t (unify-aux (cdr x) (cdr y) bindings))))
                   ((and (atom ynext) (varp ynext))
                    (setq bindings (unify-aux2 ynext xnext bindings))
                    (cond ((null bindings) nil)
                          (t (unify-aux (cdr x) (cdr y) bindings))))
                   ((eq xnext ynext) (unify-aux (cdr x) (cdr y) bindings)))))))

; No longer needed. 
; The final lines handle links between symbols like NP in the body of a 
; generative rule and NP1 in the head of another generative rule, using
; the association list created from constraints at compile time. 
;		   ((member ynext (assoc xnext exclusives*))
;		    (unify-aux (cdr x) (cdr y) bindings)))))))

; NOTE: This function does not let two or more variables bind to the 
;       same constant. This avoids instantiations like ((block a)
;       (block a)(on a a)), but there may be other cases where it 
;       is desirable, so we may need to change this function and 
;       insert a different guard against such matches. 

(defun unify-aux2 (x y bindings)
  (let ((bind (assoc x bindings)))
    (cond ((null bind)
;	   (cond ((null (rassoc y bindings))
;		  (cons (cons x y) bindings))))
	   (cons (cons x y) bindings))
          ((equal (cdr bind) y) bindings))))

; (defun varp (x)
;   (cond ((numberp x) nil)
; 	(t (eq #\? (char (string x) 0)))))

; Alternative definition of VARP that treats atoms that start with 
; either a question mark (?) or an asterisk (*) as variables for 
; purposes of pattern matching. 

(defun varp (x)
  (cond ((numberp x) nil)
	((eq #\? (char (string x) 0)) t)
	((eq #\* (char (string x) 0)) t)))

(defun wildp (x)
  (cond ((numberp x) nil)
	(t (eq #\* (char (string x) 0)))))

; **********************************************************************
; Functions for selecting the focus belief
; **********************************************************************

; SELECT-FOCUS inputs a list of beliefs, assigns a score to each one
; using the parametric function SCORE-BELIEF*, and then calls another
; parametric function, SELECT-BELIEF*, to select a single belief based 
; on these scores. The function returns this belief unless its score
; is less than zero, in which case it returns NIL. 

; (defun select-focus (beliefs)
;   (mapc score-belief* beliefs)
;   (mapc filter-beliefs* beliefs)
; (mapc #'(lambda (w) (terpri)(princ "World ")(princ (world-name w))
;	              (princ " [")(princ (world-score w))(princ "]")
;		      (princ " <")(princ (world-recency w))(princ ">"))
;	open*)
; (say-foci beliefs)
;   (say-beliefs)
; (show-beliefs)
;   (let ((best (funcall select-belief* beliefs)))
;     (terpri)(princ "Selected focus: ")(princ (belief-content best))
;     (cond ((not (< (belief-score best) 0)) best))))

(defun select-focus (beliefs)
  (mapc score-belief* beliefs)
  (mapc filter-beliefs* beliefs)
  (say-beliefs)
; (show-beliefs)
  (setq beliefs (remove-negative beliefs))
  (cond ((not (null beliefs))
	 (funcall select-belief* beliefs))))

(defun remove-negative (beliefs)
  (cond ((null beliefs) nil)
	((< (belief-score (car beliefs)) 0)
	 (remove-negative (cdr beliefs)))
	(t (cons (car beliefs) (remove-negative (cdr beliefs))))))

(defvar filter-beliefs*)
; (setq filter-beliefs* 'denigrate-recent)
; (setq filter-beliefs* 'null)
(setq filter-beliefs* 'denigrate)

(defvar focus-limit*)
(setq focus-limit* 10)

; DENIGRATE inputs a belief and, if its content is a member of the
; global variable UNRESPONSIVE*, sets its belief score to a low number
; to reduce its chance of selection as the focus. The function also
; denigrates a belief if the predicate in its content field is in the
; IGNORABLES* list AND if the belief has contributed to one or more
; applications of a definitional rule. As an afterthought, it also 
; denigrates any negated belief. 

; NOTE: Denigrating the :USES score means the system will never select
;       as a focus any belief that matched a condition in any applied
;       definitional rule. This does not affect either abduced or 
;       derived beliefs. We may want to replace this scheme with one
;       that favors beliefs with fewer uses but does not rule them out. 

(defun denigrate (belief)
  (cond ((member (car (belief-content belief)) ignorables*)
	 (setf (belief-score belief) -10))
	((member (belief-content belief) unresponsive*)
	 (setf (belief-score belief) -10))
;	((eq (belief-status belief) 'abduced)
;	 (setf (belief-score belief) -10))
	((negated (belief-content belief))
	 (setf (belief-score belief) -10))
	((not-in-active-world belief)
	 (setf (belief-score belief) -10))
;	((> (belief-uses belief) 0) 
;	 (setf (belief-score belief) -10))))
	(t (setf (belief-score belief)
;		 (/ 1.0 (+ (belief-uses belief) 1.0))))))
		 (/ (belief-score belief) (+ (belief-uses belief) 1.0))))))

; NOT-IN-ACTIVE-WORLD inputs a belief and returns T if that belief does 
; not hold for any open worlds.  

(defun not-in-active-world (belief)
  (null (set-difference open* (belief-worlds belief))))

(defun denigrate-recent (belief)
; (terpri)(princ "Considering ")
; (princ (belief-content belief))(princ " for denigration.")
  (cond ((member belief (take focus-limit* focus-memory*)
		 :test 'same-content2)
;	 (terpri)(princ "Setting score for ")
;	 (princ (belief-content belief))(princ " to 100.")
	 (setf (belief-score belief) 100))))

(defun take (n lst)
  (cond ((null lst) nil)
	((zerop n) nil)
	(t (cons (car lst) (take (1- n) (cdr lst))))))

(defun same-content2 (belief1 belief2)
  (equal (belief-content belief1) (belief-content belief2)))

(defvar score-belief*)
(setq score-belief* 'recency)
; (setq score-belief* 'skolems)

; RECENCY assigns the score for a given belief to its :RECENCY field.  

(defun recency (belief)
  (setf (belief-score belief) (belief-recency belief)))

(defun skolems (belief)
  (setf (belief-score belief) (skolem-count (belief-content belief))))

; SKOLEM-COUNT inputs a literal (a belief's :content field) and returns 
; the number of symbols that start with the skolem marker (*). 

(defun skolem-count (belief) 
  (cond ((null belief) 0) 
	((consp (car belief))
	 (+ (skolem-count (car belief)) (skolem-count (cdr belief))))
	((skolemp (car belief))
	 (1+ (skolem-count (cdr belief))))
	(t (skolem-count (cdr belief)))))

; SKOLEMP inputs an atom and returns T if it is not a number and if
; if starts with the skolem marker (*). 

(defun skolemp (x)
  (and (not (numberp x))
       (eq #\* (char (string x) 0))))

(defvar select-belief*)
(setq select-belief* 'best-belief-score)
; (setq select-belief* 'at-random)

; (defun at-random (beliefs)
;   (nth (random (length beliefs)) beliefs))

; BEST-SCORE returns the element of BELIEFS with the highest numeric 
; score in its :SCORE field.   

; Note: This function is not especially efficient. Rewritten. 

; (defun best-belief-score (beliefs) 
;   (car (sort beliefs
;              #'(lambda (x y) (> (belief-score x)
;                                 (belief-score y))))))

(defun best-belief-score (beliefs) 
  (belief-belief-score-aux (car beliefs) (cdr beliefs)))

(defun belief-belief-score-aux (first rest)
  (cond ((null rest) first)
	((> (belief-score first) (belief-score (car rest)))
	 (belief-belief-score-aux first (cdr rest)))
	(t (belief-belief-score-aux (car rest) (cdr rest)))))

; **********************************************************************
; Miscellaneous support functions 
; **********************************************************************

; SUBST-ALL inputs a list of bindings encoded as dotted pairs and an
; expression. The function returns the latter after the cdr of each
; dotted pair has been substituted for the car of the pair.

(defun subst-all (bindings expression)
  (cond ((null bindings) expression)
        (t (subst (cdar bindings) (caar bindings)
                  (subst-all (cdr bindings) expression)))))

(defun rsubst-all (bindings expression)
  (cond ((null bindings) expression)
        (t (subst (caar bindings) (cdar bindings)
                  (rsubst-all (cdr bindings) expression)))))

(defun init ()
  (setq generics* nil)
  (setq definitions* nil)
  (setq constraints* nil))

; Pazzani's code for error bars based on a 95% confidence interval...

(defun square (x) (* x x))

(defun mean (lis)
  (/ (apply '+ lis) (float (length lis))))

(defun variance (lis &optional (mean (mean lis)))
  (/ (apply #'+ (mapcar #'(lambda (x) (square (- x mean))) lis))
     (float (- (length lis) 1))))

(defun standard-error (lis)
  (sqrt (/ (variance lis) (length lis))))

(defun confidence (lis) (* 1.96 (standard-error lis)))

; CPU-SECONDS returns the internal run time divided by a thousand. 
; Assuming the former is in milliseconds, this will give CPU seconds. 

(defun cpu-seconds ()
  (/ (get-internal-run-time) 1000.0))

; **********************************************************************
; Functions for tracing system behavior
; **********************************************************************

; ATRACE* controls whether the system prints out rule applications. 

(defvar atrace*)
(setq atrace* t)

; BTRACE* controls whether the system prints beliefs on each cycle. 

(defvar btrace*)
(setq btrace* t)

; CTRACE* controls whether the system prints other details on each cycle. 

(defvar ctrace*)
(setq ctrace* t)

; UTRACE* controls whether the system prints updates of world scores. 

(defvar utrace*)
(setq utrace* t)

(defun say-cycle ()
  (cond ((or (not (null atrace*))
	     (not (null btrace*)))
	 (terpri)(princ "Cycle ")(princ cycle*))))

(defun say-beliefs ()
  (cond ((not (null btrace*))
	 (terpri)(princ "-------------------")
	 (mapc #'(lambda (b)
	   	   (cond ((not (null (set-difference open* (belief-worlds b))))
			  (terpri)(princ " ")(princ (belief-content b))
;			  (princ " [")(princ (belief-score b))(princ "]"))
			  (princ " <")(princ (belief-recency b))(princ ">")
			  (princ " [")(princ (belief-score b))(princ "]"))))
	       beliefs*)
	 (terpri)(princ "-------------------")
	 nil)))

(defun say-focus (focus)
  (cond ((not (null atrace*))
	 (terpri)(princ "Focus: ")
	 (princ (belief-content focus)))))

(defun say-no-focus ()
  (cond ((not (null atrace*))
	 (terpri)(princ "Focus: None"))))

(defun say-matched (matches type)
  (cond ((not (null atrace*))
	 (terpri)(princ type)
	 (mapc #'(lambda (m)
		   (terpri)(princ (car (definition-head (match-rule m))))
		   (princ ": ")(princ (match-matched m))
		   (princ " [")(princ (match-score m))(princ "]"))
;		   (princ " [")
;		   (mapc #'(lambda (b) (princ b)) (match-bindings m))
;		   (princ "]"))
	       matches) nil)))

(defun say-connected (matches)
  (cond ((not (null atrace*))
	 (terpri)(princ "--Connected--")
	 (terpri)(princ "Number = ")(princ (length matches))
	 (mapc #'(lambda (m)
		   (terpri)(princ (car (definition-head (dmatch-rule m))))
		   (princ ": ")(princ (dmatch-bindings m)))
	       matches) nil)))

(defun say-foci (beliefs)
  (cond ((not (null atrace*))
	 (mapc #'(lambda (b)
		   (terpri)(princ (belief-content b))
		   (princ ": ")(princ (belief-score b)))
		   beliefs))))

(defun say-applied (contents score)
  (cond ((not (null atrace*))
	 (terpri)(princ "Firing ")(princ fired*)
;	 (mapc #'(lambda (c) (princ " ")(princ c)) (cdr contents))
	 (mapc #'(lambda (c) (terpri)(princ c)) (cdr contents))
	 (terpri)(princ " => ")(princ (car contents))
	 (princ " [")(princ score)(princ "]"))))

; SHOW-BELIEFS shows information about the beliefs stored in BELIEFS*. 
; For each belief structure, the function prints the content followed
; by the worlds in which that belief does NOT hold. 

(defun show-beliefs ()
  (let ((beliefs beliefs*))
    (do ((bnext (car beliefs) (car beliefs)))
	((null beliefs) nil)
;	(cond ((not (null (set-difference open* (belief-worlds bnext))))
	(cond ((and (not (null (set-difference open* (belief-worlds bnext))))
;		    (not (eq (car (belief-content bnext)) 'not)))
		    (not (negated (belief-content bnext))))
	       (terpri)
	       (princ (belief-content bnext))
	       (princ " [")
	       (mapc #'(lambda (w)
			 (princ " ")
			 (princ (world-name w)))
		     (belief-worlds bnext))
	       (princ " ]")))
	(pop beliefs))))

(defun show-supported (content)
  (let* ((belief (member content beliefs* :test 'matches-content)))
    (cond ((not (null belief))
	   (terpri)(princ content)(princ " supports:")
	   (mapc #'(lambda (s) (terpri)(princ "  ")
		               (princ (belief-content s)))
		 (belief-supports (car belief)))))
    nil))

; SHOW-GENERICS shows information about the generic structures stored
; in GENERICS*. For each generic structure, the function prints the 
; pattern, the predicates in the heads of definitions in which the
; structure appears, and beliefs that are instances of the structure. 

(defun show-generics ()
  (let ((generics generics*))
    (do ((gnext (car generics) (car generics)))
	((null generics) nil)
	(terpri)
	(princ (generic-pattern gnext))
	(terpri)
	(mapc #'(lambda (d)
		  (princ " ")(princ (car (definition-head d))))
	      (generic-definitions gnext))
	(terpri)
	(mapc #'(lambda (c) (princ " ")(princ c))
	      (mapcar #'belief-content (generic-beliefs gnext)))
	(pop generics))))

(defun print-definitions () 
  (mapc #'(lambda (r) (print-definition r 3)) definitions*) nil)

(defun pd ()
  (print-definitions))

(defun print-definition (rule blanks)
  (let ((head (definition-head rule))
	(conditions (definition-conditions rule))
	(tests (definition-tests rule))
	(score (definition-score rule)))
;	(matches (definition-matches rule)))
    (terpri)(princ head)
    (cond ((not (null conditions))
	   (terpri)(say-blanks blanks)(princ "conditions: ")
	   (princ conditions)))
    (cond ((not (null tests))
	   (terpri)(say-blanks blanks)(princ "tests:      ")
	   (princ tests)))
    (cond ((not (null score))
	   (terpri)(say-blanks blanks)(princ "score:      ")
	   (princ score)))
;   (cond ((not (null matches))
;	   (terpri)(say-blanks blanks)(princ "matches:    ")
;	   (say-matched matches)))
    nil))

(defun say-blanks (n)
; (cond ((= n 1) nil)
  (cond ((zerop n) nil)
	(t (princ " ")(say-blanks (1- n)))))

; **********************************************************************
; Functions for creating definitional rules and constraints
; **********************************************************************

(defmacro create-definitions (&rest definitions)
  (let ((new nil))
    (do ()
	((null definitions)
	 (setq definitions* (append definitions* (reverse new)))
	 nil)
	(push (create-definition (car definitions)) new)
	(pop definitions))))

; CREATE-DEFINITION inputs a definition in Prolog-like notation and
; returns a structured version of the rule. The structure includes 
; a :generics field that stores a list of generic structures that 
; correspond to each condition. The function creates these generic
; structures if they do not already exist and, if so, initializes
; them to include a default belief with skolem arguments. 

(defun create-definition (rule)
  (let ((head (car rule))
;	(id nil)
	(elements nil)
        (conditions nil)
        (tests nil)
	(score 1.0))
    (pop rule)
    (do ((fnext (car rule) (car rule))
         (snext (cadr rule) (cadr rule)))
        ((null rule)
	 (let* ((generics (mapcar #'generate-generic (cons head conditions)))
		(defn (make-definition :head head
;			    :id id
			    :conditions conditions
			    :tests tests
			    :score score
			    :generics (cdr generics)
			    :variables (extract-variables
					  (cons head conditions) nil))))
;	   (terpri)(princ defn)
	   (mapc #'(lambda (g) (setf (generic-definitions g)
				     (cons defn (generic-definitions g))))
		 generics)
	   defn))
	(cond ((eq fnext ':elements)(setq elements snext))
;             ((eq fnext ':id)(setq id snext))
              ((eq fnext ':conditions)(setq conditions snext))
              ((eq fnext ':tests)(setq tests snext))
              ((eq fnext ':score)(setq score snext))
              (t (print-error fnext "field" "definition")))
      (setq rule (cddr rule)))))

; EXTRACT-VARIABLES inputs a list of generalized literals and returns
; a list of all pattern-match variables used in them. 

(defun extract-variables (pattern variables)
  (cond ((null pattern) variables)
	((consp pattern)
	 (extract-variables (car pattern)
			    (extract-variables (cdr pattern) variables)))
	((varp pattern)
	 (cond ((member pattern variables) variables)
	       (t (cons pattern variables))))
	(t variables)))

; GENERATE-GENERIC inputs the condition of a rule and returns a generic
; structure that includes a pattern based on that rule. If a structure
; of this sort already exists, it returns that; otherwise it creates an
; entirely new structure. The arguments of the pattern are wildcards. 

(defun generate-generic (condition)
  (let* ((predicate (car condition))
	 (generic (car (member predicate generics* :test 'geq))))
    (cond ((null generic)
	   (let ((pattern (cons predicate
				(mapcar #'(lambda (x) '*) (cdr condition)))))
	     (setq generic (make-generic :pattern pattern))
	     (push generic generics*) generic))
	  (t generic))))

(defmacro create-constraints (&rest constraints)
  (let ((new nil))
    (do ()
	((null constraints)
	 (setq constraints* (append constraints* (reverse new)))
	 nil)
	(push (create-constraint (car constraints)) new)
	(pop constraints))))

(defun create-constraint (rule)
  (let ((head (car rule))
        (elements nil)
        (options nil)
        (binds nil)
        (tests nil))
    (pop rule)
    (do ((fnext (car rule) (car rule))
         (snext (cadr rule) (cadr rule)))
        ((null rule)
	 (update-exclusives (car head) (mapcar #'car options))
         (make-constraint :head head
;			  :id id
			  :options options
			  :binds binds 
			  :tests tests))
	(cond ((eq fnext ':elements)(setq elements snext))
;             ((eq fnext ':id)(setq id snext))
              ((eq fnext ':options)(setq options snext))
              ((eq fnext ':binds)(setq binds snext))
              ((eq fnext ':tests)(setq tests snext))
              (t (print-error fnext "field" "constraint")))
      (setq rule (cddr rule)))))

(defun update-exclusives (type options)
  (push (cons type options) exclusives*))

(defun print-error (next x y)
  (terpri)(princ "Syntax error: ")
  (princ next)(princ " is not a valid ")
  (princ x)(princ " for a ")
  (princ y)(princ ".") nil)

(defun l (n)
  (let ((count 0))
    (do ()
	((= count n) nil)
	(terpri)(princ "Cycle ")(princ count)
	(incf count))))

; (UNIFY-ONE '(NP ^ID ?NP ^TYPE ?NPX ^START ?T3 ^END ?T4)
;            '(NP ^TYPE NP1 ^ID (A CAT) ^HEAD CAT ^START 7 ^END 10) NIL)

; (UNIFY-ONE '(NOUN ^ID ?NOUN ^START ?T3 ^END ?T4)
;            '(NOUN ^ID DOG ^START 3 ^END 4) NIL)

(defun traceoff ()
  (setq atrace* nil)
  (setq btrace* nil)
  (setq ctrace* nil)
  (setq utrace* nil))

(defun traceon ()
  (setq atrace* t)
  (setq btrace* t)
  (setq ctrace* t)
  (setq utrace* t) nil)

(setf *print-circle* t)
