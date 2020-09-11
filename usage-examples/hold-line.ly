\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage lily-lute

	
m = {
  \time 4/4
  << { g'2 fis' e' d' } \\
     { g,1            } >>

}

\paper {
  top-margin = 10
  scoreTitleMarkup = \markup {
    \fill-line {
      \fontsize #3 \fromproperty #'header:piece
      \null\null
    }
  }
}

\header {
  piece = "Usage of 'HoldLine"
}

\score {
  \new FrenchTabStaff {
    \m
  }

  \layout {
    indent = 0\in
    ragged-last = ##t
  }
}
