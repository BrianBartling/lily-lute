#(use-modules 
  (lily)
  (oop goops))

\include "grobs.ily"

%%%
%%% Hold Line data structure
%%%

#(define-class <hold-line> ()
  (this-mom           #:accessor this-mom
                      #:init-value       0)
  (prev-mom           #:accessor prev-mom
                      #:init-value       0)
  (lines              #:accessor lines
                      #:init-value     '()))

%%%
%%% Functions
%%%

#(define (init-hold-line context translator hold-line note-ev duration)
  (let* ((hl-grob (ly:engraver-make-grob translator 'HoldLine note-ev)))
   (set! (lines hold-line) (acons hl-grob duration (lines hold-line)))
  ))

#(define (process-lines hold-line)
  (let ((lines-loc  '()))
   (begin
    (format #t "\nThis mom: ~a, Prev mom: ~a\n" (this-mom hold-line) (prev-mom hold-line))
    (map
     (lambda (x)
     (format #t "x: ~a\n" x)
      (set! x (cons (car x) (- (cdr x) (this-mom hold-line))))
      (format #t "This x: ~a\n" x)
      (if (<= (cdr x) 0)
       (ly:engraver-announce-end-grob engraver (car x) rhythm-ev)
       (set! lines-loc (append! x (list lines-loc))))
     (format #t "This line: ~a\n" x))
    (lines hold-line)))
   (set! (lines hold-line) lines-loc)))

%%%
%%% Hold Line engraver definition
%%%

#(define-public hold-line-engraver
  (lambda (context)

   (let ((hold-line    (make <hold-line>))
         (note-ev     '())
   	 (threshold     1)
         (duration      0))

    (make-engraver

     (listeners
      ((note-event engraver event)
       (set! note-ev event)
       (set! duration (ly:moment-main 
                       (ly:duration-length 
		        (ly:event-property event 'duration))))))

       ((process-music translator)
	(set! (this-mom hold-line) (ly:moment-main (ly:context-now context)))
        (if (>= duration threshold)
         (begin
 	 (init-hold-line context translator hold-line note-ev duration))))

       ((stop-translation-timestep translator)
	(process-lines hold-line)
	(set! (prev-mom hold-line) (this-mom hold-line)))

      ))))
