\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage tab-tools

m =  { \time 4/4
       << { bes,4. } \\ { bes'16\colLine a'\2\index bes' c''\index d''8 c''16 bes'\index } >>
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
