\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage lute-tab

m = {
  \time 4/4
  <g, b d' g'\arpAbove>4
  
  c'\arpBelow\middle

  <d, d' fis'\arpAbove a'>2

  g'\arpAbove\index
  
  a\thumb
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
  piece = "Usage of 'TabArticulation'"
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
