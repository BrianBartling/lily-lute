\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage lute-tab

\setOption lute-tab.tab-duration.gridSlant #0.2

m = {
  \time 4/4
  <g, b d' g'>4 
  <c e' g'>
  <d, d' fis' a'>2
  <g, b d' g'>1

  \break

  a8 b16 c' d' e' f' g' a'4 e'8 c' a1

  \break

  \override FrenchTabStaff.TabGrid.top-space = #2.0
  \time 2/4
  <g, b d' g'>8
  <c e' g'>
  <d, d' fis' a'>4
  <g, b d' g'>2

  \break

  \time 4/4
  \override FrenchTabStaff.TabGrid.bound-details.left.overshoot = #0.0
  \override FrenchTabStaff.TabGrid.bound-details.right.overshoot = #1.2
  a8 b16 c' d' e' f' g' a'4 e'8 c' a1

  \break

  \override FrenchTabStaff.TabGrid.grid-space = #0.75
  a8 b16 c' d' e'\killGrid f' g' a'4 e'8 c' a1
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
    \omit Score.BarNumber
    \m
  }

  \layout {
    indent = 0\in
    ragged-right = ##t
    ragged-last = ##t
  }
}
