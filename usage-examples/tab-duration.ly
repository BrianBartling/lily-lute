\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage lute-tab

m = {
  \time 4/4
  <g, b d' g'>4 
  
  <c e' g'>

  <d, d' fis' a'>2

  <g, b d' g'>1

  \break

  <g, b d' g'>4 
  
  <c e' g'>

  <d, d' fis' a'>2

  <g, b d' g'>1

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
  piece = "Usage of 'TabDuration' + 'TabGrid'"
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
