\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage lute-tab

m = {
  \time 4/4
  <g, b d' g'>4\colLine 
  
  \once\override FrenchTabStaff.ColLine.thickness = #0.6
  <c e' g'>\colLine

  \once\override FrenchTabStaff.ColLine.col-padding = #'(2.25 . 0.25) 
  <d, d' fis' a'>2\colLine

  <g, b d' g'>4\colLine

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
  piece = "Usage of 'ColLine'"
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
