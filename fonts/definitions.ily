#(define welde-font "Welde")

#(define label-font "")

#(let ((font-option (getOption '(lute-tab labelFont))))
  (cond
   ((equal? font-option 'Bravura)
     (set! label-font smufl-font))
   ((equal? font-option 'Welde)
     (set! label-font welde-font))
   (else
    (ly:warning "unrecognized labelFont property: ~a" font-option))))

#(define welde-map '(
  ("luteFrenchFretA" . #xEBC0)
  ("luteFrenchFretB" . #xEBC1)
  ("luteFrenchFretC" . #xEBC2)
  ("luteFrenchFretD" . #xEBC3)
  ("luteFrenchFretE" . #xEBC4)
  ("luteFrenchFretF" . #xEBC5)
  ("luteFrenchFretG" . #xEBC6)
  ("luteFrenchFretH" . #xEBC7)
))

#(define-markup-command (label-glyph layout props glyphname) (string?)
  (let* ((glyph-assoc (assoc glyphname welde-map)))
   (begin
    (ly:debug "Using Welde glyph ~a : ~a\n" glyphname (cdr glyph-assoc))
     (interpret-markup layout props
      (markup (#:fontsize 5 #:override `(font-name . ,label-font) #:char (cdr glyph-assoc)))))))

