#(use-modules 
  (lily)
  (oop goops))

\include "grobs.ily"

%%%
%%% Hold Line data structure
%%%

#(define-class <hold-line> ()
  (threshold          #:accessor threshold
                      #:init-value       1)
  (this-mom           #:accessor this-mom
                      #:init-value       0)
  (prev-mom           #:accessor prev-mom
                      #:init-value       0)
  (lines              #:accessor lines
                      #:init-value     '()))

%%%
%%% Functions
%%%

#(define (make-hl-grob translator hold-line note-ev parent-grob)
  (let* ((hl-grob (ly:engraver-make-grob translator 'HoldLine note-ev)))
   (ly:grob-set-parent! hl-grob Y parent-grob)
   (set! (lines hold-line) (acons hl-grob (get-duration note-ev) (lines hold-line)))))

#(define (get-duration event)
  (ly:moment-main 
   (ly:duration-length
    (ly:event-property event 'duration))))

#(define (init-hold-line context translator hold-line note-evs note-head-grobs)
  (let ((idx  0))
   (map
    (lambda (x)
     (if (>= (get-duration x) (threshold hold-line))
       (make-hl-grob translator hold-line x (list-ref note-head-grobs idx)))
     (set! idx (+ idx 1)))
    note-evs)))

#(define (process-lines translator hold-line duration)
  (let ((lines-loc  '())
	(end-ev     (ly:make-stream-event (ly:make-event-class 'note-event) 
		     (list (cons 'duration duration)))))
   (begin
    (format #t "\nThis mom: ~a, Prev mom: ~a\n" (this-mom hold-line) (prev-mom hold-line))
    (map
     (lambda (x)
      (format #t "x: ~a\n" x)
      (set-cdr! x (- (cdr x) (this-mom hold-line)))
      (format #t "This x: ~a\n" x)
      (if (<= (cdr x) 0)
       (ly:engraver-announce-end-grob translator (car x) end-ev)))
    (lines hold-line)))))

%%%
%%% Hold Line engraver definition
%%%

#(define-public hold-line-engraver
  (lambda (context)

   (let ((hold-line           (make <hold-line>))
         (note-evs           '())
	 (note-head-grobs    '())
   	 (threshold            1)
         (duration             0))

    (make-engraver

     (listeners
      ((note-event engraver event)
       (format #t "Found note-event\n")
       (set! note-evs (append! (list event) note-evs))
       (format #t "note-evs: ~a\n" note-evs)
       (set! duration (ly:moment-main 
                       (ly:duration-length 
		        (ly:event-property event 'duration))))))

     (acknowledgers
      ((tab-note-head-interface engraver grob source-engraver)
       (set! note-head-grobs (append! (list grob) note-head-grobs))
       (format #t "note-head-grobs: ~a\n" note-head-grobs)))

       ((stop-translation-timestep translator)
	(format #t "In stop-translation-timestep\n")
	(set! (this-mom hold-line) (ly:moment-main (ly:context-now context)))
	(init-hold-line context translator hold-line note-evs note-head-grobs)
	(process-lines translator hold-line duration)
	(set! (prev-mom hold-line) (this-mom hold-line))
	(set! note-evs '())
	(set! note-head-grobs '()))
      ))))
