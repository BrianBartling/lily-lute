%%%
%%% Stylistic Functions
%%%

#(define (tab-note-head-offset grob)
  (let ((default (ly:staff-symbol-referencer::callback grob)))
   (+ default (* (getOption '(lily-lute raiseNoteHeads))
                 (ly:staff-symbol-staff-space grob)))))

%%%
%%% Use mensural flags for stems with more than one flag
%%%

#(define (modified-mensural-flag grob)
  (let* ((stem-grob (ly:grob-parent grob X))
         (log (ly:grob-property stem-grob 'duration-log))
         (modifier (number->string (getOption '(lily-lute tab-duration mensuralModifier)))))
   (if (> log 3)
    (create-glyph-flag "mensural" modifier grob)
    (old-straight-flag grob))))

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

#(define-markup-command (thumb-fng layout props) ()
  #:properties ((height     0.78)
  	        (thickness  0.15)
		(blot        0.3))
   "Draw a straight line for the thumb"
   (let  ((height-interval      (cons 0 height))
   	  (thickness-interval   (cons 0 thickness)))
    (interpret-markup layout props
     (markup #:filled-box thickness-interval
     	     		  height-interval
			  blot))))

#(define-markup-command (index-fng layout props) ()
  #:properties ((radius  0.15)
                (hoffset 0))

  "Draw a dot for the index finger."
  (interpret-markup layout props
   (markup #:hspace hoffset
   #:draw-circle radius 0 #t)))

#(define-markup-command (middle-fng layout props) ()
  #:properties ((radius      0.15)
		(separation  -0.25)
		(hoffset     0.4))
  "Draw two dots for the middle finger."
  (interpret-markup layout props
   (markup #:hspace hoffset
    #:draw-circle radius 0 #t
    #:hspace separation
    #:draw-circle radius 0 #t)))

thumb = -\tweak staff-padding #'()
        -\tweak padding #0.2
        _\finger\markup\thumb-fng
index = -\tweak staff-padding #'()
        -\tweak padding #0.2
        _\finger\markup\index-fng
middle = -\tweak staff-padding #'()
         -\tweak padding #0.2
         _\finger\markup\middle-fng

colLine = #(make-music 'ColLineEvent)

#(define-markup-command (label-glyph layout props glyphname) (string?)
  (let* ((glyph-assoc (assoc glyphname smufl-map)))
   (begin
    (ly:debug "Using glyph ~a : ~a from font ~a\n" 
    	        glyphname (cdr glyph-assoc) (getOption '(lily-lute labelFont)))
     (interpret-markup layout props
      (markup (#:fontsize 5 
      	       #:override `(font-name . ,(getOption '(lily-lute labelFont)))
	       #:char (cdr glyph-assoc)))))))

arpBelow = #(make-music 'TabArticulationEvent 
	     'articulation-type "luteFrenchAppoggiaturaBelow"
	     'padding -0.3
	     'font-size -1)
arpAbove = #(make-music 'TabArticulationEvent 
	     'articulation-type "luteFrenchAppoggiaturaAbove"	     
	     'padding -0.58
	     'font-size 0)
mordUp   = #(make-music 'TabArticulationEvent
	     'articulation-type "luteFrenchMordentUpper"
	     'padding -0.2
	     'font-size -7
	     )