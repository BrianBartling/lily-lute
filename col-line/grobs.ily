\include "../make-grobs.ily"

%%%
%%% Grob properties
%%%

#(define-grob-property 'col-padding pair? "padding above and below note heads")

%%%
%%% Grob routines
%%%

#(define (col-line::print me)
  (let* ((blot            (ly:output-def-lookup (ly:grob-layout me) 'blot-diameter))
	 (ref-grobs       (ly:grob-object me 'ref-grobs))
	 (thickness       (ly:grob-property me 'thickness))
	 (col-padding     (ly:grob-property me 'col-padding))
	 (distance        (+ (abs (ly:grob-property (car ref-grobs) 'Y-offset)) 
			   (abs (ly:grob-property (cdr ref-grobs) 'Y-offset))))
	 (x-extent        (cons (* (/ thickness 2) -1) (/ thickness 2)))
	 (y-extent        (cons (car col-padding) (- distance (cdr col-padding))))
	 (mol             (ly:round-filled-box x-extent y-extent blot)))

   mol))

%%%
%%% Grob descriptions
%%%

#(add-grob-definition 'ColLine
  `(
    (stencil . ,col-line::print)
    (col-padding . (.75 . .75))
    (thickness . 0.15)
    (parent-alignment-X . ,CENTER)
    (parent-alignment-Y . ,CENTER)
    (Y-offset . ,ly:self-alignment-interface::aligned-on-y-parent)
    (X-offset . ,ly:self-alignment-interface::aligned-on-x-parent)
    (Y-extent . ,grob::always-Y-extent-from-stencil)
    (meta . ((class . Item)
	     (interfaces . (note-column-interface
			    self-alignment-interface))))))
