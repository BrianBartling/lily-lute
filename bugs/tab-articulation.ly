\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage tab-tools

m =  { \time 4/4
       << { g2 } \\ { <d' bes'\mordUp>2 } >>

     }

\score {
  \new FrenchTabStaff {
    \omit Score.BarNumber
    \m
  }

  \layout {
    indent = 0\in
    ragged-last = ##t
  }
}
