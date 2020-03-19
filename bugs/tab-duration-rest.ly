\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage tab-tools

m =  { \time 4/4
       << { d'4\middle } \\ { r8 bes,8 } >>
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
