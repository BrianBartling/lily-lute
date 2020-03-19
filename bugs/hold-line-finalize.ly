\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage tab-tools

m =  { \time 4/4
       << { d4 } \\ { fis'8 c'\index } >>
       <g, b\arpAbove d' g'>4
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
