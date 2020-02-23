#(use-modules 
  (lily)
  (oop goops))

\include "grobs.ily"

%%%
%%% Tab Duration data structure
%%%

#(define-class <tab-duration> ()
  (duration             #:accessor duration
   			#:init-value 0)
  (durlog               #:accessor durlog
   			#:init-value 0)
  (durlength            #:accessor durlength
   			#:init-value 0)
  (grouping-unit        #:accessor grouping-unit)
  (td-grob              #:accessor td-grob)
  (flag                 #:accessor flag)
  (note-event           #:accessor note-event)
  (measure-position     #:accessor m-pos)
  (print-flag?          #:accessor print-flag?
   			#:init-value #t)
  (in-grid?             #:accessor in-grid?
   			#:init-value #f)
  (grid-slant           #:accessor grid-slant
  			#:init-value 0))

#(define-class <grid> ()	
  (lines                 #:accessor lines
  			 #:init-value '())
  (grobs-in-grid         #:accessor grobs-in-grid
  			 #:init-value '())
  (in-grid-count         #:accessor in-grid-count
  			 #:init-value 0)
  (start-gridline?       #:accessor start-gridline?
  			 #:init-value #f)
  (stop-gridline?        #:accessor stop-gridline?
  			 #:init-value #f)
  (num-lines             #:accessor num-lines
  			 #:init-value 0))
	     
%%%
%%% Misc functions
%%%

#(define (transparent? tab-duration prev-tab-duration)
  (begin
   (if (and (!= (durlog prev-tab-duration) 0)
	(=  (durlog prev-tab-duration) (durlog tab-duration))
	(!= (ly:moment-main (m-pos tab-duration)) 0)
	(in-grid? tab-duration)
	(in-grid? prev-tab-duration))
    (ly:grob-set-property! (td-grob tab-duration) 'transparent #t)
    (ly:grob-set-property! (flag    tab-duration) 'transparent #t))))

#(define (remove-flags tab-duration grid)
  (begin
   (if (< (length (grobs-in-grid grid)) 2)
    (set! (grobs-in-grid grid) '())
    (begin
     (map (lambda (x) (ly:grob-set-object! x 'print-flag? #f))
      (grobs-in-grid grid))
     (set! (grobs-in-grid grid) '())))))

	   #(define (raise-bound line tab-duration grid)
	     (let* ((bound-details      (ly:grob-property line 'bound-details))
		    (yraise             (cons 'Y 
					 (/ (grid-slant tab-duration)
					  (ly:staff-symbol-staff-space line))))
		    (overshoot          (ly:grob-property line 'overshoot)))

	      (begin
	       (set! bound-details
		(append-map 
		 (lambda (x)
		  (cond
		   ((equal? (car x) 'right)
		    (list
		     (append-map
		      (lambda (y)
		       (cond
			((and (pair? y) (equal? (car y) 'Y))
			 (list yraise))
			((and (pair? y) (equal? (car y) 'padding))
			 (list (cons 'padding (* (cdr overshoot) -1))))
			(else (list y))))
		      x)))
		   ((equal? (car x) 'left)
		    (list
		     (append-map
		      (lambda (y)
		       (cond
			((and (pair? y) (equal? (car y) 'padding))
			 (list (cons 'padding (* (car overshoot) -1))))
			(else (list y))))
		      x)))
		   (else (list x))))
		 bound-details))

	       (ly:grob-set-property! line 'bound-details bound-details)
	     )))

#(define (end-grid tab-duration grid context)
  (begin
   ;; Ending lines
   (map (lambda (x) 
	 (begin
	  (raise-bound x tab-duration grid)
	  (ly:spanner-set-bound! x RIGHT (td-grob tab-duration))
	  (ly:engraver-announce-end-grob context x (note-event tab-duration))))
    (lines grid))

   (remove-flags tab-duration grid)

   (set! (lines grid) '())
   (set! (in-grid? tab-duration) #f)
   (set! (in-grid-count grid) 0)))

#(define make-lines
  (lambda (i tab-duration grid context span delta yoffset)
   (if (not (= i 0))
    (begin
     (set! span (ly:engraver-make-grob context 'TabGrid (note-event tab-duration)))
     (ly:grob-set-parent! span Y (td-grob tab-duration))

     (set! yoffset (- delta (ly:grob-property span 'top-space) 
		    (* i (ly:grob-property span 'grid-space))))
     (ly:grob-set-property! span 'Y-offset yoffset)
     
     (ly:spanner-set-bound! span LEFT (td-grob tab-duration))
     (set! (lines grid) (append! (lines grid) (list span)))

     (make-lines (- i 1) tab-duration grid context span delta yoffset)))))

#(define (start-grid tab-duration grid context)
  (let* ((span       0)
	 (y1         (ly:grob-property (td-grob tab-duration) 'stem-begin-position))
	 (y2         (ly:grob-property (td-grob tab-duration) 'length))
	 (half-space (* (ly:staff-symbol-staff-space (td-grob tab-duration)) 0.5))
	 (delta      (- (max y2 y1) (min y1 y2)))
	 (yoffset    0))

   (begin
    (set! (num-lines grid) (- (durlog tab-duration) 2))
    (make-lines (num-lines grid) tab-duration grid context span delta yoffset)
    (set! (grobs-in-grid grid) (list (td-grob tab-duration)))
    (set! (in-grid? tab-duration) #t)
    (set! (in-grid-count grid) 1)
    (set! (grid-slant tab-duration) 0))))

#(define (set-slant tab-duration grid)
  (let 	((length    (/ (ly:grob-property (td-grob tab-duration) 'length)
		     (ly:staff-symbol-staff-space (td-grob tab-duration))))
	 (slant     (/ (getOption '(lute-tab tab-duration gridSlant))
		     (ly:staff-symbol-staff-space (td-grob tab-duration)))))

   (begin
    (if (= (grid-slant tab-duration) 0)
     (set! (grid-slant tab-duration) slant)
     (set! (grid-slant tab-duration) (+ (grid-slant tab-duration) slant)))

    (map (lambda (x) (ly:grob-set-object! x 'slant (grid-slant tab-duration)))
     (lines grid))

    (cond 
     ((equal? (getOption '(lute-tab tab-duration slantType)) 'extend)
      (ly:grob-set-property! (td-grob tab-duration) 'length
       (+ length (grid-slant tab-duration))))
     ((equal? (getOption '(lute-tab tab-duration slantType)) 'shift)
      (ly:grob-set-property! (td-grob tab-duration) 'Y-offset slant))
     (else
      (ly:warning "unrecognized slantType property: ~a" 
       (getOption '(lute-tab tab-duration slantType))))))))

#(define (process-grids tab-duration prev-tab-duration grid translator context)
  (let ((gridspace (/ (+ (ly:moment-main (m-pos tab-duration)) (durlength tab-duration))
		    (grouping-unit tab-duration))))

   ;; We may have to end the grid prematurely, i.e. if the last duration is
   ;; not the same as the current one, or if we encounter a barline
   (if (or (and (!= (durlength prev-tab-duration) 0)
	    (!= (durlength tab-duration) (durlength prev-tab-duration)))
	(not (null? (ly:context-property context 'whichBar))))
    (if (and
	 (> (in-grid-count grid) 1)
	 (integer? gridspace))
     (end-grid prev-tab-duration grid translator)
     (begin
      (map (lambda (x) (ly:grob-suicide! x)) (lines grid))
      (set! (lines grid) '())
      (set! (grobs-in-grid  grid) '())
      (set! (in-grid?       tab-duration) #f)
      (set! (in-grid-count  grid) 0))))

   ;; Determine if we should start/stop a gridline
   (if (and (not (start-gridline? grid))
	(not (stop-gridline? grid)))
    (begin

     (if (or (and (in-grid? tab-duration) (integer? gridspace))
	  (and  (= (in-grid-count grid) 0) (integer? gridspace)))
      (begin
       (set! (stop-gridline? grid) #t)))

     (if (and (not (in-grid? tab-duration)) (not (stop-gridline? grid))
	  (< (durlength tab-duration) (grouping-unit tab-duration)))
      (begin
       (set! (start-gridline? grid) #t)))

     ;; Set the slant for this grob
     (if (and (in-grid? tab-duration) 
	  (> (getOption '(lute-tab tab-duration gridSlant)) 0))
      (set-slant tab-duration grid))))

   ;; Format this grob if we are in a grid
   (if (in-grid? tab-duration)
    (begin
     (ly:grob-set-property! (td-grob tab-duration) 'outside-staff-priority #f)
     (set! (in-grid-count grid) (+ (in-grid-count grid) 1))

     (if (>= (in-grid-count grid) (getOption '(lute-tab tab-duration maxGrid)))
      (set! (stop-gridline? grid) #t))
     
     (ly:grob-set-parent! (td-grob tab-duration) Y (td-grob prev-tab-duration))
     (ly:grob-set-property! (td-grob tab-duration) 'parent-alignment-Y CENTER)

     (set! (grobs-in-grid grid) (append! (grobs-in-grid grid) (list (td-grob tab-duration))))
   ))
 ))

%%%
%%% Initialize the Tab Duration object
%%%

#(define (init-tab-duration tab-duration prev-tab-duration grid translator context)
  (let ((ts-frac        (ly:context-property context 'timeSignatureFraction))
	(td-event       (ly:make-stream-event (ly:make-event-class 'note-event)
			 (list (cons 'duration (duration tab-duration))))))

   (begin
    (set! (m-pos  tab-duration)     (ly:context-property context 'measurePosition))

    ;; td-event is a dummy stream event, the cause of TabDuration & Flag
    ;; This is needed to get through event-cause
    (set! (td-grob tab-duration) (ly:engraver-make-grob translator 'TabDuration td-event))
    (set! (flag    tab-duration) (ly:engraver-make-grob translator 'Flag td-event))

    (ly:grob-set-parent! (flag tab-duration) X (td-grob tab-duration))
    (ly:grob-set-object! (td-grob tab-duration) 'flag (flag tab-duration))
    
    ;; Tablatures require an extra flag
    (ly:grob-set-property! (td-grob tab-duration) 'duration-log 
     (+ (ly:grob-property (td-grob tab-duration) 'duration-log) 1))

    ;; Don't print a flag if the durlength = timesig or durlog < 3
    (if (or (= (/ (car ts-frac) (cdr ts-frac))
	     (durlength tab-duration))
	    (< (ly:grob-property (td-grob tab-duration) 'duration-log)
	     3))
     (ly:grob-set-object! (td-grob tab-duration) 'print-flag? #f)
     (ly:grob-set-object! (td-grob tab-duration) 'print-flag? #t))

    (if (and (getOption '(lute-tab tab-duration hideRepeated))
	 (not (in-grid? tab-duration)))
     (transparent? tab-duration prev-tab-duration))

    (if (getOption '(lute-tab tab-duration useGrids))
     (process-grids tab-duration prev-tab-duration grid translator context))

  )))

%%%
%%% Tab Duration engraver definition
%%%

#(define-public tab-duration-engraver
  (lambda (context)

   (let ((tab-duration       (make <tab-duration>))
	 (prev-tab-duration  (make <tab-duration>))
	 (grid               (make <grid>)))
    
    (make-engraver

     (listeners
      ((note-event engraver event)
       (begin
	(set! (note-event tab-duration) event)
	(set! (duration   tab-duration) (ly:event-property event 'duration))
	(set! (durlog     tab-duration) (+ (ly:duration-log (duration tab-duration)) 1))
	(set! (durlength  tab-duration) (ly:moment-main 
					 (ly:duration-length (duration tab-duration))))
	(set! (grouping-unit tab-duration) (/ (ly:moment-main (ly:context-property
							       context 'measureLength))
					    (car (ly:context-property context
						  'timeSignatureFraction)))))))     

     ((process-music translator)
      (begin
       (init-tab-duration tab-duration prev-tab-duration grid translator context)))

     (acknowledgers
      ((note-head-interface engraver grob source-engraver)
       (begin
	(ly:grob-set-object! (td-grob tab-duration) 'note-head-extent 
	 (- (cdr (ly:grob-extent grob grob X)) (car (ly:grob-extent grob grob X))))))

      ((stem-interface engraver grob source-engraver)
       (begin
	(if (ly:grob? (ly:grob-object grob 'flag))
	 (ly:grob-suicide! (ly:grob-object grob 'flag)))))

      ((note-column-interface engraver grob source-engraver)
       (begin
	(if (getOption '(lute-tab tab-duration useGrids))
	 (begin
	  (if (stop-gridline? grid)
	   (end-grid tab-duration grid engraver))

	  (if (start-gridline? grid)
	   (start-grid tab-duration grid engraver))))))

      ((dots-interface engraver grob source-engraver)
       (begin
	(ly:grob-set-object! (td-grob tab-duration) 'dots grob))))

     ((stop-translation-timestep translator)
      (if (getOption '(lute-tab tab-duration useGrids))
       (begin
	(if (start-gridline? grid)
	 (begin
	  (if (stop-gridline? grid)
	   (ly:warning "overwriting grid"))
	  (set! (start-gridline? grid) #f)))

	(if (stop-gridline? grid)
	 (set! (stop-gridline? grid) #f))

	(map (lambda (x) (slot-set! prev-tab-duration 
			  (car x) (slot-ref tab-duration (car x)))) 
	 (class-slots <tab-duration>))
      )))
     
     ((finalize translator)
      (if (getOption '(lute-tab tab-duration useGrids))
       (begin
	(if (not (null? (lines grid)))
	 (begin
	  (ly:warning "unterminated grid line")
	  (map (lambda (x) (ly:grob-suicide! x)) (lines grid))
	  (set! (lines grid) '()))))))
     
   ))))
