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
  (mom                #:accessor mom
                      #:init-value       0)
  (note-column        #:accessor note-column
  		      #:init-value     '())
  (grobs              #:accessor grobs
                      #:init-value     '())
  (prev-hold-line     #:accessor prev-hold-line
                      #:init-value     '())
  (adjust             #:accessor adjust
                      #:init-value     '())
  (ta-event           #:accessor ta-event
                      #:init-value     '())
  (fng-grob           #:accessor fng-grob
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
  (let ((lines-loc  '()))

   (begin
    (map
     (lambda (x)
      (let ((cnt  (ly:grob-object (car x) 'timestep-cnt)))
       (set-cdr! x (- (cdr x) (- (mom hold-line) (mom (prev-hold-line hold-line)))))
       (if (and (< (cdr x) 0)
                (not (null? note-head-grobs)))
        (if (<= cnt 1)
         (begin
	  (ly:grob-suicide! (car x))
   	  (set! (lines hold-line) (del-assoc x (lines hold-line))))
	 (begin
	  (end-hl-grob x hold-line translator duration)))
        (ly:grob-set-object! (car x) 'timestep-cnt (+ cnt 1)))))
    (lines hold-line)))))

#(define (end-hl-grob x hold-line translator duration)
  (let ((grob         (car x))
        (bound-grob  '())
	(end-ev       (ly:make-stream-event (ly:make-event-class 'note-event)
	               (list (cons 'duration duration)))))

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
      (grobs (prev-hold-line hold-line)))
     (set! bound-grob closest-grob))
    (set! bound-grob (note-column (prev-hold-line hold-line))))
   (ly:grob-set-property! bound-grob 'color blue)
   (ly:spanner-set-bound! grob RIGHT bound-grob)
   (maybe-adjust-bound grob bound-grob hold-line)
   (set! (lines hold-line) (del-assoc x (lines hold-line)))
   (ly:engraver-announce-end-grob translator grob end-ev)))

#(define (nullify-hold-line hold-line)
  (set! (mom (prev-hold-line hold-line)) (mom hold-line))
  (set! (note-column (prev-hold-line hold-line)) (note-column hold-line))
  (set! (ta-event (prev-hold-line hold-line)) (ta-event hold-line))
  (set! (fng-grob (prev-hold-line hold-line)) (fng-grob hold-line))
  (if (not (null? (grobs hold-line)))
   (set! (grobs (prev-hold-line hold-line)) (grobs hold-line)))
  (set! (ta-event hold-line) '())
  (set! (fng-grob hold-line) '())
  (set! (grobs hold-line) '())
  (set! (adjust hold-line) '())
  (set! (remove? hold-line) #f))

%%%
%%% Misc functions
%%%

#(define (maybe-adjust-bound grob right-bound hold-line)
   ;;; Bound Adjustment
   ;;; If there are more than 2 staff spaces above or below the
   ;;; source & target notehead, attach the grob above or below the note,
   ;;; respectively.
   ;;; If there is a TabArticulation grob attached to the note head and
   ;;; the source & target grobs are not on the same staff line, attach
   ;;; above/below the target grob.
   ;;; If there is a Fingering grob, adjust for that
  (ly:grob-set-property! grob 'color red)
  (ly:grob-set-property! right-bound 'color green)
  (ly:grob-set-property! (ly:spanner-bound grob LEFT) 'color blue)
  (let*  ((left-bound        (ly:spanner-bound grob LEFT))
          (right-staff-space (ly:grob-staff-position right-bound))
	  (left-staff-space  (ly:grob-staff-position left-bound))
          (distance          (abs (- right-staff-space left-staff-space)))
          (right-offset      (ly:grob-property right-bound 'Y-offset))
          (right-extent      (abs (- (cdr (ly:grob-property right-bound 'Y-extent))
                                     (car (ly:grob-property right-bound 'Y-extent))))))

   (if (or (not (null? (ta-event hold-line)))
           (> distance 2))
    (begin
     (ly:grob-set-nested-property! grob '(bound-details right attach-dir) RIGHT)
     (if (> right-staff-space left-staff-space)
      (ly:grob-set-nested-property! grob '(bound-details right Y) (- right-offset (* right-extent 0.5)))
      (ly:grob-set-nested-property! grob '(bound-details right Y) (+ right-offset (* right-extent 0.5))))))

   (format #t "right-staff-space: ~a, left-staff-space: ~a, fng-grob: ~a\n" right-staff-space left-staff-space (fng-grob (prev-hold-line hold-line)))

   (if (and (> right-staff-space left-staff-space)
            (not (null? (fng-grob (prev-hold-line hold-line)))))
    (let  ((fng-extent     (* (abs 
                               (- (cdr 
                                   (ly:grob-property (fng-grob (prev-hold-line hold-line)) 'Y-extent))
                                  (car 
                                   (ly:grob-property (fng-grob (prev-hold-line hold-line)) 'Y-extent)))) 1.5))
           (current-offset '()))
     (if (not (null? (grob-nested-property grob '(bound-details right Y))))
      (set! current-offset (grob-nested-property grob '(bound-details right Y)))
      (set! current-offset (* 1.5 right-extent)))
     (ly:grob-set-nested-property! grob '(bound-details right Y)
      (- current-offset fng-extent))))

))

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

   (let ((hold-line                    (make <hold-line>))
         (note-evs                    '())
         (note-head-grobs             '())
         (duration                      0))

    (make-engraver
    
    ((initialize translator)
     (set! (prev-hold-line hold-line) (make <hold-line>)))

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
	  (set! (remove? hold-line) #t)))))
      ((tab-articulation-event engraver event)
        (format #t "Listening to tab-articulation-event.\n")
	(set! (ta-event hold-line) event)))

     (acknowledgers
      ((tab-note-head-interface engraver grob source-engraver)
        (set! note-head-grobs (append! (list grob) note-head-grobs)))
      ((note-column-interface engraver grob source-engraver)
        (let* ((note-heads  (ly:grob-object grob 'note-heads))
               (list-note-heads
                (if (null? note-heads)
		 '() (ly:grob-array->list note-heads))))
         (set! (note-column hold-line) grob)
         (set! (grobs hold-line) 
          (append (grobs hold-line) list-note-heads))))
      ((finger-interface engraver grob source-engraver)
        (format #t "Acknowledging finger event.\n")
	(set! (fng-grob hold-line) grob)))

     ((stop-translation-timestep translator)
       (set! (mom hold-line) (ly:moment-main (ly:context-now context)))
       (process-lines translator hold-line note-head-grobs duration)
       (init-hold-line context translator hold-line note-evs note-head-grobs)

       ;;Prepare for next time step

       (nullify-hold-line hold-line)
       (set! note-evs '())

       (set! note-head-grobs '()))

     ((finalize translator)
       (map
        (lambda (x)
	 (if (>= (ly:grob-object (car x) 'timestep-cnt) 3)
	  (end-hl-grob x hold-line translator duration)))
        (lines hold-line)))

      ))))
