\include "../make-grobs.ily"

%%%
%%% Grob descriptions
%%%

#(add-grob-definition 'HoldLine
  `(
    (after-line-breaking . ,ly:spanner::kill-zero-spanned-time)
    (bound-details . ((left . ((Y . 0)
			       (padding . 0.0)
			       (attach-dir . ,LEFT)
			     ))
		      (right . ((Y . 0)
				(padding . 0.0)
				(attach-dir . ,RIGHT)
			      ))
		    ))
    (left-bound-info . ,ly:line-spanner::calc-left-bound-info)
    (normalized-endpoints . ,ly:spanner::calc-normalized-endpoints)
    (right-bound-info . ,ly:line-spanner::calc-right-bound-info)
    (thickness . 2.5)
    (stencil . ,ly:line-spanner::print)
    (style . line)
    (X-extent . #f)
    (Y-extent . #f)
    (meta . ((class . Spanner)
	     (interfaces . (line-interface
			    line-spanner-interface
			    self-alignment-interface))))))