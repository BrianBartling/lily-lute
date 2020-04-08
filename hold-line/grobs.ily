\include "../make-grobs.ily"

%%%
%%% Grob descriptions
%%%

#(add-grob-definition 'HoldLine
  `(
    (after-line-breaking . ,ly:spanner::kill-zero-spanned-time)
    (bound-details . ((left . (;(Y . ,side-position-interface::y-aligned-side)
			       (padding . 0.2)
			       (attach-dir . ,RIGHT)
			     ))
		      (right . (;(Y . 3.5)
				(padding . 0.5)
				(attach-dir . ,LEFT)
			      ))
		    ))
    (left-bound-info . ,ly:line-spanner::calc-left-bound-info)
    (normalized-endpoints . ,ly:spanner::calc-normalized-endpoints)
    (right-bound-info . ,ly:line-spanner::calc-right-bound-info)
    (thickness . 1.5)
    (stencil . ,ly:line-spanner::print)
    (style . line)
    (X-extent . #f)
    (Y-extent . #f)
    (Y-offset . ,side-position-interface::y-aligned-side)
    (direction . ,DOWN)
    (side-axis . ,Y)
    (meta . ((class . Spanner)
	     (interfaces . (line-interface
			    line-spanner-interface
			    self-alignment-interface))))))