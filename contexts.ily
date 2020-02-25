%%%
%%% Contexts
%%%

\layout {
  \context {
    \Global
    \grobdescriptions #all-grob-descriptions
  }

  \context {
    \TabVoice
    \consists "Fingering_engraver"
  }

  \context {
    \TabStaff
    \alias "TabStaff"

    \name "FrenchTabStaff"

    \consists #tab-duration-engraver
    \consists #col-line-engraver
    \consists #tab-articulation-engraver

    tablatureFormat = #fret-letter-tablature-format

    \omit Clef
    \omit TimeSignature
    \omit Arpeggio

    \revert TextScript.stencil

    \override Fingering.direction = #DOWN
    \override Fingering.staff-padding = #'()
    \override Fingering.padding = #0.5

    \override Flag.style = #'default
    \override Flag.stencil = #old-straight-flag

    \override TabNoteHead.Y-offset = 
    #(lambda (grob)
      (let ((default (ly:staff-symbol-referencer::callback grob)))
  	(+ default (* (getOption '(lute-tab raiseNoteHeads))
	   	      (ly:staff-symbol-staff-space grob)))))	

    stringTunings = \stringTuning <g, c f a d' g'>
    additionalBassStrings = \stringTuning <d,>

    fretLabels = \markuplist {
      		   \label-glyph "luteFrenchFretA" \label-glyph "luteFrenchFretB"
      		   \label-glyph "luteFrenchFretC" \label-glyph "luteFrenchFretD"
      		   \label-glyph "luteFrenchFretE" \label-glyph "luteFrenchFretF"
      		   \label-glyph "luteFrenchFretG" \label-glyph "luteFrenchFretH"
      		 }
  }

  \inherit-acceptability "FrenchTabStaff" "TabStaff"
}
