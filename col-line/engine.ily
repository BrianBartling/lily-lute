\include "grobs.ily"

%%%
%%% Define ColLine events
%%%

#(hashq-set! music-name-to-property-table 'ColLineEvent
  '((name . ColLineEvent) (types post-event col-line-event event)))

#(define-event-class 'col-line-event 'arpeggio-event)

%%%
%%% Misc functions
%%%

#(define (extract-grobs note-column)
  (let* ((grob-array    (ly:grob-array->list 
			 (ly:grob-object note-column 'note-heads)))
	 (first         (list-ref grob-array 0))
	 (second        (list-ref grob-array 1)))

   (if (< (length grob-array) 2)
    (ly:warning "Attempting to make a column-line on a single note\n")
    (cons first second)
)))

%%%
%%% Initialize col-line
%%%	   

#(define (init-col-line context translator ref-grobs duration)
  (let* ((cl-event   (ly:make-stream-event (ly:make-event-class 'note-event)
		      (list (cons 'duration duration))))
	 (cl-grob    (ly:engraver-make-grob translator 'ColLine cl-event)))
   (ly:grob-set-parent! cl-grob Y (car ref-grobs))
   (ly:grob-set-parent! cl-grob X (car ref-grobs))
   (ly:grob-set-object! cl-grob 'ref-grobs ref-grobs)
   (ly:grob-set-object! cl-grob 'middleCPosition (ly:context-property context 'middleCPosition))))

%%%
%%% col-line engraver definition
%%%

#(define-public col-line-engraver
  (lambda (context)

   (let ((col-line       '())
	 (ref-grobs      '())
	 (duration        0))

    (make-engraver

     (listeners
      ((note-event engraver event)
       (set! duration (ly:event-property event 'duration)))

      ((col-line-event engraver event)
      	(set! col-line event)))
 
       (acknowledgers
	((note-head-interface engraver grob source-engraver)
	 (set! ref-grobs (append ref-grobs (list grob)))))
   
       ((stop-translation-timestep translator)
         (if (and (not (null? col-line))
        	  (not (null? ref-grobs)))
              (begin
	       (set! ref-grobs (cons (car ref-grobs) (cadr ref-grobs)))
               (init-col-line context translator ref-grobs duration)
               (set! col-line '())))
	(set! ref-grobs '()))
      ))))
    