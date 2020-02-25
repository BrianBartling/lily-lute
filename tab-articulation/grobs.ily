\include "../make-grobs.ily"

%%%
%%% Grob routines
%%%

#(define (tab-articulation::print me)
  (let* ((articulation-type (ly:grob-object me 'articulation-type))
         (font-size         (ly:grob-object me 'font-size))
	 (padding           (ly:grob-object me 'padding))
	 (right-padding     (ly:grob-property me 'right-padding))
  	 (symbol-markup     (markup #:label-glyph articulation-type
	 		     #:hspace right-padding)))

   (ly:grob-set-property! me 'text symbol-markup)
   (if (not (null? font-size))
    (ly:grob-set-property! me 'font-size font-size))
   (if (not (null? padding))
    (ly:grob-set-property! me 'padding padding))
   (ly:stencil-translate-axis 
    (ly:stencil-aligned-to (ly:text-interface::print me) Y CENTER)
    2 X)
   ))

%%%
%%% Grob descriptions
%%%

#(add-grob-definition 'TabArticulation
  `(
    (direction . ,LEFT)
    (padding . 0)
    (right-padding . 0.15)
    (font-size . -3)
    (self-alignment-X . ,RIGHT)
    (self-alignment-Y . ,CENTER)
    (positioning-done . ,ly:script-interface::calc-positioning-done)
    (parent-alignment-X . ,LEFT)
    (parent-alignment-Y . ,LEFT)
    (stencil . ,tab-articulation::print)
    (X-offset . ,ly:self-alignment-interface::aligned-on-x-parent)
    (Y-extent . ,grob::always-Y-extent-from-stencil)
    (Y-offset . ,side-position-interface::y-aligned-side)
    (meta . ((class . Item)
	     (interfaces . (self-alignment-interface
			    text-interface
			    text-script-interface))))))
