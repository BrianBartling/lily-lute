\include "grobs.ily"

%%%
%%% Define TabArticulation Events
%%%

#(hashq-set! music-name-to-property-table 'TabArticulationEvent 
  '((name . TabArticulationEvent) (types post-event event tab-articulation-event)))

#(define-event-class 'tab-articulation-event 'annotate-output-event)

%%%
%%% Initialize tab-articulation
%%%

#(define (init-tab-articulation translator s-event note-head articulation-type font-size padding)
  (let* ((ta-grob   (ly:engraver-make-grob translator 'TabArticulation s-event)))

   (ly:grob-set-parent! ta-grob X note-head)
   (ly:grob-set-parent! ta-grob Y note-head)
   (ly:grob-set-object! ta-grob 'articulation-type articulation-type)
   (ly:grob-set-object! ta-grob 'font-size font-size)
   (ly:grob-set-object! ta-grob 'padding padding)))

%%%
%%% tab-articulation engraver definition
%%%

#(define-public tab-articulation-engraver
  (lambda (context)

   (let ((s-event            '())
         (nh-grobs           '())    
	 (note-head          '())
	 (articulation-type  '())
	 (font-size          '())
	 (padding            '())
	 (nev-count           -1)
	 (which-grob          -1))

    (make-engraver

     (listeners
      ((note-event engraver event)
       (let* ((articulation-list  (ly:event-property event 'articulations))
       	      (articulation      '()))

	(set! nev-count (+ nev-count 1))
        (if (not (null? articulation-list))
	 (begin
	  (set! articulation (ly:event-property (car articulation-list) 'music-cause))
          (if (equal? (ly:music-property articulation 'name)
               'TabArticulationEvent)
	   (begin
	    (set! which-grob nev-count)
	    (set! s-event (car articulation-list))
	    (set! articulation-type (ly:music-property articulation 'articulation-type))
	    (set! font-size (ly:music-property articulation 'font-size))
	    (set! padding (ly:music-property articulation 'padding))))))))

      ((tab-articulation-event engraver event)
       (set! s-event event)
       (set! articulation-type (ly:event-property event 'articulation-type))
       (set! font-size (ly:event-property event 'font-size))
       (set! padding (ly:event-property event 'padding))))

     (acknowledgers
      ((note-head-interface engraver grob source-engraver)
       (set! note-head grob)      
       (set! nh-grobs (append nh-grobs (list grob)))))

     ((stop-translation-timestep translator)
      (if (and (> which-grob -1)
               (not (null? nh-grobs))
      	       (> (length nh-grobs) 1))
        (set! note-head (list-ref nh-grobs which-grob)))

       (if (and (not (null? note-head))
            (not (null? articulation-type)))
	 (init-tab-articulation 
           translator s-event note-head articulation-type font-size padding))

       (set! s-event           '())
       (set! nh-grobs          '())       
       (set! articulation-type '())
       (set! font-size         '())
       (set! padding           '())
       (set! nev-count          -1)
       (set! which-grob         -1))

   ))))
