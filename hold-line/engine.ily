#(use-modules 
  (lily)
  (oop goops))

\include "grobs.ily"

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
  (lines              #:accessor lines
                      #:init-value     '()))

%%%
%%% Functions
%%%

#(define (make-hl-grob translator hold-line note-ev parent-grob)
  (let* ((hl-grob (ly:engraver-make-grob translator 'HoldLine note-ev)))
   (ly:grob-set-parent! hl-grob Y parent-grob)
   (ly:grob-set-object! hl-grob 'timestep-cnt 0)
   (ly:grob-set-object! hl-grob 'start-staff-pos (ly:grob-staff-position parent-grob))
   (ly:spanner-set-bound! hl-grob LEFT parent-grob)
   (set! (lines hold-line) (acons hl-grob (get-duration note-ev) (lines hold-line)))))

#(define (end-hl-grob x hold-line translator end-ev)
  (let ((bound-grob  '()))
   (if (getOption '(tab-tools hold-line attachToClosest))
    (let ((closest-grob  '())
          (orig-sp        (ly:grob-staff-position (car x))))
     (format #t "Finding closest grob in: ~a\n" (prev-grobs hold-line))	  
     (map (lambda (y)
           (if (null? closest-grob)
	    (set! closest-grob y)
	    (if (< (- (abs orig-sp) (abs (ly:grob-staff-position y)))
                   (- (abs orig-sp) (abs (ly:grob-staff-position closest-grob))))
	     (set! closest-grob y))))
      (prev-grobs hold-line))
     (format #t "Found closest grob: ~a\n" closest-grob)
     (set! bound-grob closest-grob)
     (ly:grob-set-nested-property! (car x) '(bound-details right Y) 
      (- (ly:grob-staff-position closest-grob)
(ly:grob-staff-position (car x))
         )))
    (set! bound-grob (prev-note-column hold-line)))
   (format #t "This bound grob: ~a\n" bound-grob)
   (ly:spanner-set-bound! (car x) RIGHT bound-grob)
   (set! (lines hold-line) (remove x (lines hold-line)))
   (ly:engraver-announce-end-grob translator (car x) end-ev)))

#(define (get-duration event)
  (ly:moment-main 
   (ly:duration-length
    (ly:event-property event 'duration))))

#(define (init-hold-line context translator hold-line note-evs note-head-grobs)
  (let ((idx  0))
   (map
    (lambda (x)
     (make-hl-grob translator hold-line x (list-ref note-head-grobs idx))
     (set! idx (+ idx 1)))
    note-evs)))

#(define (remove x ls)
  (if (null? ls)
      '()
      (let ((h (car ls)))
        ((if (eqv? x h)
            (lambda (y) y)
            (lambda (y) (cons h y)))
         (remove x (cdr ls))))))

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
   	  (set! (lines hold-line) (remove x (lines hold-line))))
	 (begin
	  (end-hl-grob x hold-line translator end-ev)))
        (ly:grob-set-object! (car x) 'timestep-cnt (+ cnt 1)))))
    (lines hold-line)))))

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
		        (ly:event-property event 'duration))))))

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
       (set! (prev-mom hold-line) (this-mom hold-line))
       (set! (prev-note-column hold-line) (this-note-column hold-line))
       (set! (prev-grobs hold-line) (these-grobs hold-line))
       (set! (these-grobs hold-line) '())
       (set! note-evs '())
       (set! note-head-grobs '()))
      ))))
