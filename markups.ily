%%%
%%% Modify bar line extents
%%%

#(define (modify-bar-line-extent grob)
  (let* ((staff-extent     (ly:bar-line::calc-bar-extent grob))
         (staff-space      (ly:staff-symbol-staff-space grob))
	 (rev-staff-extent (cons
	                    (+ (car staff-extent) staff-space)
			    (- (cdr staff-extent) staff-space))))
   rev-staff-extent))

shortenBarLine =
 #(define-music-function () ()
   #{
     \once\override TabStaff.BarLine.bar-extent = #modify-bar-line-extent
   #})

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

#(define-markup-command (label-glyph layout props glyphname) (string?)
  (let* ((glyph-assoc (assoc glyphname smufl-map)))
   (begin
    (ly:debug "Using glyph ~a : ~a from font ~a\n" 
    	        glyphname (cdr glyph-assoc) (getOption '(tab-tools labelFont)))
     (interpret-markup layout props
      (markup (#:fontsize 5 
      	       #:override `(font-name . (getOption '(tab-tools labelFont)))
	       #:char (cdr glyph-assoc)))))))

arpBelow = #(make-music 'TabArticulationEvent 
	     'articulation-type "luteFrenchAppoggiaturaBelow"
	     'padding -0.3
	     'font-size -1)
arpAbove = #(make-music 'TabArticulationEvent 
	     'articulation-type "luteFrenchAppoggiaturaAbove"	     
	     'padding -0.58
	     'font-size 0)