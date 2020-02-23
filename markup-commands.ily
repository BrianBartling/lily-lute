%%%
%%% Fingering markup commands
%%%

#(define-markup-command (index layout props) ()
  #:properties ((radius  0.15)
                (hoffset 0))

  "Draw a dot for the index finger."
  (interpret-markup layout props
   (markup #:hspace hoffset
   #:draw-circle radius 0 #t)))

#(define-markup-command (middle layout props) ()
  #:properties ((radius      0.15)
		(separation  -0.25)
		(hoffset     0))
  "Draw two dots for the middle finger."
  (interpret-markup layout props
   (markup #:hspace hoffset
    #:draw-circle radius 0 #t
    #:hspace separation
    #:draw-circle radius 0 #t)))

middle = \finger\markup\middle
index = \finger\markup\index

colLine = #(make-music 'ColLineEvent)

arpBelow = #(make-music 'TabArticulationEvent 'articulation-type "arpBelow")