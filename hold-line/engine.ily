#(use-modules 
  (lily)
  (oop goops))

\include "grobs.ily"

%%%
%%% Modification events
%%%

#(hashq-set! music-name-to-property-table 'HoldLineEvent
  '((name . HoldLineEvent) (types post-event event hold-line-event)))

#(define-event-class 'hold-line-event 'annotate-output-event)

adjustEndpoints = #(define-event-function (params) (pair?)
                    (make-music 'HoldLineEvent 
                                'what 'adjust-endpoints
                                'value params))

removeHoldLine = #(define-event-function () ()
                   (make-music 'HoldLineEvent
		               'what 'remove))

%%%
%%% Hold Line data structure
%%%

#(define-class <hold-line> ()
  (this-mom           #:accessor this-mom
                      #:init-value       0)
  (prev-mom           #:accessor prev-mom
                      #:init-value       0)
  (this-note-column   #:accessor this-note-column
  		      #:init-value     '())
  (these-grobs        #:accessor these-grobs
                      #:init-value     '())
  (prev-note-column   #:accessor prev-note-column
                      #:init-value     '())
  (prev-grobs         #:accessor prev-grobs
                      #:init-value     '())
  (adjust             #:accessor adjust
                      #:init-value     '())
  (remove?            #:accessor remove?
                      #:init-value     #f)
  (lines              #:accessor lines
                      #:init-value     '()))

%%%
%%% Processing routines
%%%

#(define (init-hold-line context translator hold-line note-evs note-head-grobs)
  (let ((idx  0))
   (map
    (lambda (x)
     (make-hl-grob translator hold-line x (list-ref note-head-grobs idx))
     (set! idx (+ idx 1)))
    note-evs)))

#(define (make-hl-grob translator hold-line note-ev parent-grob)
  (let* ((hl-grob   (ly:engraver-make-grob translator 'HoldLine note-ev)))
   ;; Don't initialize a hold line if it's coming from a diapason
   (if (and (not (remove? hold-line))
            (not (< (ly:grob-staff-position parent-grob)
                    (getOption '(tab-tools hold-line diapason-level)))))
    (begin
     (ly:grob-set-parent! hl-grob Y parent-grob)
     (ly:grob-set-object! hl-grob 'timestep-cnt 0)
     (ly:grob-set-object! hl-grob 'start-staff-pos (ly:grob-staff-position parent-grob))
     (ly:spanner-set-bound! hl-grob LEFT parent-grob)
     (if (not (null? (adjust hold-line)))
      (begin     
       (adjust-hl hl-grob (car (adjust hold-line)) 'left)
       (ly:grob-set-object! hl-grob 'adjust-end (cdr (adjust hold-line)))))
     (set! (lines hold-line) (acons hl-grob (get-duration note-ev) (lines hold-line)))))))

#(define (process-lines translator hold-line note-head-grobs duration)
  (let ((lines-loc  '())
	(end-ev     (ly:make-stream-event (ly:make-event-class 'note-event) 
		     (list (cons 'duration duration)))))
   (begin
    (map
     (lambda (x)
      (let ((cnt  (ly:grob-object (car x) 'timestep-cnt)))
       (set-cdr! x (- (cdr x) (- (this-mom hold-line) (prev-mom hold-line))))
       (if (and (< (cdr x) 0)
                (not (null? note-head-grobs)))
        (if (<= cnt 1)
         (begin
	  (ly:grob-suicide! (car x))
   	  (set! (lines hold-line) (del-assoc x (lines hold-line))))
	 (begin
	  (end-hl-grob x hold-line translator end-ev)))
        (ly:grob-set-object! (car x) 'timestep-cnt (+ cnt 1)))))
    (lines hold-line)))))

#(define (end-hl-grob x hold-line translator end-ev)
  (let ((grob         (car x))
        (bound-grob  '()))
   (if (getOption '(tab-tools hold-line attachToClosest))
    (let ((closest-grob  '())
          (orig-sp        (ly:grob-staff-position grob)))
     (map (lambda (y)
           (if (null? closest-grob)
	    (set! closest-grob y)
	    (begin
                 (round (ly:grob-staff-position closest-grob))))
	    (if (closer-to-zero? (round orig-sp) (round (ly:grob-staff-position y))
                 (round (ly:grob-staff-position closest-grob)))
	    (begin
             (ly:grob-set-property! y 'color red)
	     (set! closest-grob y))))
      (prev-grobs hold-line))
     (set! bound-grob closest-grob)
     (if (set-bound? (round orig-sp) (round (ly:grob-staff-position bound-grob)))
      (ly:grob-set-nested-property! grob '(bound-details right Y)
       (- (ly:grob-property closest-grob 'Y-offset) (ly:grob-staff-position grob)))))
    (set! bound-grob (prev-note-column hold-line)))
   (ly:grob-set-property! bound-grob 'color blue)
   (ly:spanner-set-bound! grob RIGHT bound-grob)
   (let ((adjust-endpoint (ly:grob-object grob 'adjust-end)))
    (if (not (null? adjust-endpoint))
      (adjust-hl grob adjust-endpoint 'right)))
   (set! (lines hold-line) (del-assoc x (lines hold-line)))
   (ly:engraver-announce-end-grob translator grob end-ev)))

#(define (nullify-hold-line hold-line)
  (set! (prev-mom hold-line) (this-mom hold-line))
  (set! (prev-note-column hold-line) (this-note-column hold-line))
  (set! (prev-grobs hold-line) (these-grobs hold-line))
  (set! (these-grobs hold-line) '())
  (set! (adjust hold-line) '())
  (set! (remove? hold-line) #f))

%%%
%%% Misc functions
%%%

#(define (adjust-hl grob value endpoint)
  (let* ((padding-list    (list 'bound-details endpoint 'padding))
         (Y-list          (list 'bound-details endpoint 'Y))
         (current-padding (grob-nested-property grob padding-list))
         (current-Y       (grob-nested-property grob Y-list))
	 (padding-adj     (+ (car value) current-padding))
	 (Y-adj           (+ (cdr value) current-Y)))
   (ly:grob-set-nested-property! grob padding-list padding-adj)
   (ly:grob-set-nested-property! grob Y-list Y-adj)))

#(define (closer-to-zero? orig-sp test-sp closest-sp)
  (let ((dist-test    (abs (- orig-sp test-sp)))
        (dist-closest (abs (- orig-sp closest-sp))))
   (cond ((= dist-test dist-closest) (< test-sp closest-sp))
	 ((< dist-test dist-closest) #t)
	 (else #f))))

#(define (set-bound? orig-sp bound-grob-sp)
  ;; Attach the end of the hold line to its closest grob, only if:	 
  ;;   - the line isn't flat, i.e. both grobs are at the same staff position
  ;;   - the resulting note head isn't below the staff, i.e. a diapason
  (and (not (= (- (abs orig-sp) (abs bound-grob-sp)) 0))
       (not (< bound-grob-sp (getOption '(tab-tools hold-line diapason-level))))))

#(define (get-duration event)
  (ly:moment-main 
   (ly:duration-length
    (ly:event-property event 'duration))))

#(define (del-assoc symlist el)
  (if (null? el) '()
   (begin
    ((if (equal? symlist (car el))
      (lambda (y) y)
      (lambda (y) (cons (car el) y)))
  (del-assoc symlist (cdr el))))))

#(define (grob-nested-property grob symlist)
  (let ((nested-list  (ly:grob-property grob (car symlist))))
   (map (lambda (sym)
         (set! nested-list (cdr (assoc sym nested-list))))
    (cdr symlist))
   nested-list))

%%%
%%% Hold Line engraver definition
%%%

#(define-public hold-line-engraver
  (lambda (context)

   (let ((hold-line           (make <hold-line>))
         (note-evs           '())
	 (note-head-grobs    '())
         (duration             0))

    (make-engraver

     (listeners
      ((note-event engraver event)
       (set! note-evs (append! (list event) note-evs))
       (set! duration (ly:moment-main 
                       (ly:duration-length 
		        (ly:event-property event 'duration)))))
      ((hold-line-event engraver event)
       (let ((event-type (ly:event-property event 'what)))
        (cond
	 ((equal? event-type 'adjust-endpoints)
	  (set! (adjust hold-line) (ly:event-property event 'value)))
         ((equal? event-type 'remove)
	  (set! (remove? hold-line) #t))))))

     (acknowledgers
      ((tab-note-head-interface engraver grob source-engraver)
        (set! note-head-grobs (append! (list grob) note-head-grobs)))
      ((note-column-interface engraver grob source-engraver)
        (let* ((note-heads  (ly:grob-object grob 'note-heads))
               (list-note-heads
                (if (null? note-heads)
		 '() (ly:grob-array->list note-heads))))
         (set! (this-note-column hold-line) grob)
         (set! (these-grobs hold-line) 
          (append (these-grobs hold-line) list-note-heads)))))

     ((stop-translation-timestep translator)
       (set! (this-mom hold-line) (ly:moment-main (ly:context-now context)))
       (process-lines translator hold-line note-head-grobs duration)
       (init-hold-line context translator hold-line note-evs note-head-grobs)

       ;;Prepare for next time step
       (nullify-hold-line hold-line)
       (set! note-evs '())
       (set! note-head-grobs '()))
      ))))
