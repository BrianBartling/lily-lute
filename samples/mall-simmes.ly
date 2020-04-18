\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage tab-tools

m =  { \time 4/4
       <g, g\mordUp d' g'>2 <g d' bes\mordUp>
       <d fis d' a'\arpAbove> d,4 d''\index
       <a c''\arpAbove> <g bes'> <f a'\arpAbove> << { g'8 c'\index } \\ { ees4 } >>
       << { <a fis'>4 d'\index\arpAbove  } \\ { d2 } >> d,2
       << { <d' bes'\mordUp>4 g' } \\ { g2 } >> << { f2 } \\ { a'4\arpAbove g'\index } >>
       << { c'4 bes4 } \\ { ees2 } >> <c a\arpAbove>4 g\index
       <d\mordUp f d'>4 <bes, g'>\colLine <c e'\arpAbove> <d a fis'>
       <g, b\arpAbove d' g'> g g,2

       << { g2\mordUp } \\ { <g, d' g'>4. a'8\index\mordUp } >> << { g2 } \\ { <d' bes'>8. a'16\index g'8\middle bes'\index } >> 
       <d, a d' a'>8.\arpAbove bes'16\index a'8\middle\arpAbove g'\index fis' e'\index d' d''\index
       << { a4 } \\ { c''8\arpAbove d''\index } >>  << { g4 } \\ { bes'8 c''\index } >> << { f4 } \\ { a'8\arpAbove bes'\index } >> << { ees4 } \\ { g'8 a'\index } >>
       << { d2 } \\ { <a fis'>4 d'\index\arpAbove } >> d,4 g'8\middle a'\index
       bes'\middle << { g8~ g4 } \\ { r8 d'\middle g'\index } >> a'\middle\arpAbove f8 a d'\index
       c'\middle ees d bes\index <c a\arpAbove> bes\index g4
       d'8\middle\arpAbove d g'\middle\arpAbove bes, e'\middle\arpAbove c << { fis'4\middle } \\ { r8 d } >>
       <b\arpAbove d' g'>8 g g, c'\index <g, b\arpAbove d' g'>2
       \bar "||"

       << { bes,2 } \\ { <bes d' f' bes'>8. c''16\index d''4 } >> <f c' f' a'>8. bes'16 c''4
       << { g2 } \\ { <d'\mordUp bes'>4 a'8\middle\arpAbove g'\index } >> << { d2 } \\ { <a fis'>4 d'\index } >>
       << { bes,2 } \\ { bes8.\arpAbove c'16\index d'4\middle } >> <f, f a\arpAbove>8. bes16\index c4\middle
       <g, bes\arpAbove>4 a8\middle g\index <d fis\mordUp a d'>4 d,
       <g, g\mordUp>8. a16\index bes8 c'\index d'\middle bes\index g4\arpAbove
       <g, g bes d'>8. a,16 bes,8 c ees bes, g,4
       << { bes,2. } \\ { bes8.\arpAbove c'16\index d'8 ees'\index f' d'\index } >> bes4\arpAbove
       <bes, f bes d'>8. c16\index d8 ees <f f'> d bes,4
       <g, g\mordUp d' g'>2 <g d' bes'\mordUp>
       <d, a d' a'\arpAbove>4. g'8\index fis\middle e'\index d'\middle bes,
       <c ees'\arpAbove> f'\index g'\middle ees <d\arpAbove a d' g'> c << { d4 } \\ { fis'8 c'\index } >>
       <g, b\arpAbove d' g'>4 g g,2
       << { bes,2 } \\ { bes'16 a'\2\index bes' c''\index d''8 c''16 bes'\index } >> <f a'>16 g'\index a' bes'\index c''8 bes'16 a'\index
       <g, g'>16\colLine f'\index g' a'\index bes'8 a'16 g'\index << { d2 } \\ { fis'16 e'\index fis' g'\index a' fis'\index d'8 } >>
       <bes, bes>16 a\index bes c'\index d'8\arpAbove c'16 bes\index <f a> g\index a bes\index c'8 bes16  a\index
       <g, g> a\index bes c'\index d'8\arpAbove c'16 bes << { d4 } \\ { a16 g\index a bes\index } >> a16 fis\index d8
       d'16\middle g\index g a\index bes c'\index d' ees'\index d' c'\index bes a\index g4
       g16\middle g,\index g, a,\index bes, c\index d ees\index d c\index bes, a,\index g,4
       << { bes,2. } \\ { bes,16 bes\index bes c'\index d' c'\index d' ees'\index f' ees'\index d' c'\index } >> bes4\arpAbove
       bes16\middle bes,\index bes, c\index d c\index d ees\index f ees\index d c bes,4
       << { g2\mordUp } \\ { <g, d' g'>4. a'8\index } >> << { g2 } \\ { <d' bes'>8 g'16 a'\index bes' g'\index a' bes'\index } >>
       <d, d' a'\arpAbove>8 d'16 e'\index f' g'\index a' bes'\index a' g'\index f' e'\index << { bes,4 } \\ { d'16 e'\index f' d'\index } >>
       << { c4 } \\ { e'16 d'\index e' f'\index } >> << { ees4 } \\ { g'16 a'\index bes' g'\index } >> << { d2 } \\ { a'16 g'\2\index fis' e'\index g'32\2 fis'\index g'\2 fis'\index g'\2 fis'\index g'\2 e' fis'\index } >>
       <g, g'\arpAbove>\colLine f'16 e'\index d' c'\index b a\index g\mordUp
       \bar "|."


     }

\paper {
  top-margin = #0
  system-system-spacing = #'((basic-distance . 0.5) (padding . 0.5))
  ragged-last-bottom = ##f
  ragged-bottom = ##f
  scoreTitleMarkup = \markup {
    \vspace #3
    \fill-line {
      \fontsize #3 \italic \fromproperty #'header:piece
      \null\null
    }
  }
}

\header {
  tagline = ##f
  piece = "Mall Simmes"
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
