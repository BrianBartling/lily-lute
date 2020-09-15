\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage lily-lute

\setOption lily-lute.tab-duration.gridSlant      #0.0

m = {
  \time 4/4
  % 1
  <g b\arpAbove d' g'>2 fis4 e
  % 2
  <d fis a d' a'\arpAbove>2 <a d' a'\arpAbove>4 c
  % 3
  <b, d' g'>\colLine g a,8 g <fis\arpAbove a>4
  % 4
  <g, b\arpAbove d' g'>\colLine g\index g,2
  % 5
  <g, b'\arpAbove>8\colLine c'' d''4 <a' c''\arpAbove> <a' b'\arpAbove>
  % 6
  <d a d' a'\arpAbove> fis d4. d'8
  % 7
  <c c' e'\arpAbove>8 fis'\index g'\middle b <d a d' g'> c <d a fis'> c'\index
  % 8
  <g, b\arpAbove d' g'>4\colLine g\index g,2
  % 9
  <g, b\arpAbove d' g'>8\colLine g16 a\index b a\index b c'\index d' c'\index d'\index e' fis' e'\index fis' g'\index
  % 10
  <d fis' a'>8\colLine d'16\3 e'\index fis' e'\index fis' g'\2 a' g'\2\middle a' b'\index a'8\arpAbove\middle c
  % 11
  <b, g'>16\colLine fis'\index g' a'\index b' a'\index b' g'\index <a, a'>\colLine g'\2\index a' b'\index c'' b'\index c'' a'\index
  % 12
  <g, b'>8\colLine a'16 g'\index f' e'\index d' c'\index <b d' g'>8 g g,4
  % 13
  <g, b'>8\colLine c'' d'' g'\2 <e' c''> fis' <g' b'\arpAbove>4
  % 14
  \time 3/4
  <d d' a'>16\colLine a\index b cis'\index <d d' a'\arpAbove>4.\colLine d''8
  % 15
  \time 4/4
  <c c''>8\colLine b'\index <e a'\arpAbove>\colLine g'\index <a, cis' g'\2>4 fis'8\arpAbove c'\index
  % 16
  <g, b\arpAbove d' g'>8 f'16 e'\index d' c'\index b a\index <b\arpAbove d' g'>8 g g,4
  \shortenBarLine\bar ".."

  % 17
  <g, b d' g>4 g <d d' a'\arpAbove> fis
  % 18
  <g, d' b'>\colLine g g,2
  % 19
  <a, e' c''>4\colLine a\4 <e e' b'> <e' b'>
  % 20
  <a, cis' e' a'> a\4 a,2
  % 21
  <g, b g' d''>4. c''8 b'4 a'8\arpAbove g'\index
  % 22
  <d a d' a'\arpAbove>4. c8 b,8 a, g,4
  % 23
  <c c' e'>8 fis'\index g' e <f\5 d' g'>\colLine c <d a fis'> c'\index
  % 24
  <g, b\arpAbove d' g'>4\colLine g g,2
  \shortenBarLine\bar ".."

  % 25
  <g, g'>8\colLine fis'16 e'\index d' e'\index fis' g'\index <d a'>8\colLine g'16\2 fis'\index e' fis'\index g'\2 a'\index
  % 26
  <g, b'>8\colLine d''16 c'' d'' c''\index b' a'\index\2 <g, b'>8\colLine g'16 a'\index b' g'\index a' b'\index
  % 27
  \time 3/8
  <a, c''>8\colLine b'16 c''\index b'\arpAbove a'\index 
  \once\omit Score.BarLine
  \time 5/4
  <e e' a'>\colLine d'\3 cis' b\index <a, cis' e' a'>8\colLine b16 cis'\index d'\3 e'\index fis' g'\2 a' g'\2\index a' b'\index c'' a'\index b' c''
  % 28
  \time 4/4
  <g, d''>8\colLine b'16 c''\index d'' c''\index d'' c''\index <g, b'>8\colLine a'16 b'\index c'' b'\index a' g'\index
  % 29
  <d a d' a'\arpAbove>4. c8 b,8 a, g,4
  % 30
  <c c' e'>8 fis'\index g'\middle e <d a d' g'> c <d a fis'> c'\index
  % 31
  <g b\arpAbove d' g'>8\colLine g16 a\index b a\index b c'\index <b d' g'>8 g g,4
  \shortenBarLine\bar ".."

}

\paper {
  top-margin = 10
  scoreTitleMarkup = \markup {
    \fill-line {
      \fontsize #3 \italic \fromproperty #'header:piece
      \null\null
    }
  }
}

\header {
  tagline = ##f
  piece = "Mounsieur's Almain — Welde 14v-15r"
}

\score {
  \layout {
    indent = 0\in
    ragged-last = ##t

    \context {
      \FrenchTabStaff
      \override Flag.stencil = #flat-flag
    }
  }

  \new FrenchTabStaff {
    \omit Score.BarNumber
    \override FrenchTabStaff.TabGrid.top-space = #0.62
    \override FrenchTabStaff.TabGrid.bound-details.left.overshoot = #-0.2
    \override FrenchTabStaff.TabGrid.bound-details.right.overshoot = #-0.2
    \m
  }
}
