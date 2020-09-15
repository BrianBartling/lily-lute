\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage lily-lute

\setOption lily-lute.tab-duration.useGrids       ##f
\setOption lily-lute.tab-duration.useMensural    ##f
\setOption lily-lute.tab-duration.useNoteHeads   ##t
\setOption lily-lute.tab-duration.useFlags       ##f

m = {
  \time 2/4 \partial 8 g'8
  <g, g'>\colLine d' <g d' g'> a'\index
  <g, g d' b'>4 <d a d' a'\arpAbove>
  <g, g'>8\colLine d'\index <d, d'>16\colLine c'\index b a\index
  g4\arpAbove g,
  \shortenBarLine\bar ".."

  \partial 8 a'8
  <a e' a'>16 a\index a a\index b'8 e'\index
  \partial 8 <a e' a'>8 \once\omit Score.BarLine
  c'' b'\index a' e'\index
  <g, e' a'>8.\colLine g'16\2 fis'8 e'\index
  fis' d, d a'
  <g, d' b'>\colLine g'\index b' a'\index
  <g, g'>\colLine d'\index g' e'\index
  <d, d'>8.\colLine c'16\index b8 a\index
  <g, b\arpAbove d' g'>4\colLine
  \shortenBarLine\bar ".."

  \time 2/4 \partial 8 g'8
  <c e'>\colLine <b, d'>\colLine <c e'>\colLine <b, d'>\colLine
  \bar ".."

  <a, c'>\arpBelow\colLine a\4 <e b> gis\index
  <cis' e' a'> a, a\4 e'\index
  <a e' a'>16 a'\index a' a'\index a'8 e'
  <cis' e' a'> a, a\4 c''
  <g, d'\index b'>\colLine a'16 g'\index <d d' b'>8\colLine a'\arpAbove\index
  <g, b d' g'>2\colLine
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
  piece = "Noel's Delight — Welde 7r"
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
