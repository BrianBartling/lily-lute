\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage lute-tab

m = {
  \time 5/8
      d'4. <g, g\arpBelow d' g'>8 fis'16\arpBelow g'\index
  \time 2/4
      <d a d' a'\arpAbove>8 <g d' b'> <c e' c''>\colLine
      <d b'>16\colLine a' <e g'>8\colLine <fis d' a'>
      <g d' b'> <fis d' a'> 
  \time 3/4
      <e d' g'> cis'\index <d d' fis' a'> a\4\index d4
  \once\revert Score.BarLine.stencil
  \shortenBarLine\bar ".."

      <d a d' a'\arpAbove>8  a'16 a'\index <d a fis'> d'\index fis' g'\index
      <d d' fis' a'>8 a\4\index d d''16 c'' <g, d' b'>8\colLine <c c''>16 b'
      <d a d' a'\arpAbove> g' a'8 
      <g, b d' g'>\colLine g g,4.
  \once\revert Score.BarLine.stencil
  \shortenBarLine\bar ".."
  
      d'8 <g, g d' g'> fis'16 g'\index <d a d' a'>8 g'16 a'\index
      <g, d' b'>8 g 
  \time 5/8
      g, d''16 c'' <g, d' b'>8\colLine a'16 b'\index
      <c e' c''> <g, d' b'>\colLine
  \time 2/4
      <d fis a d' a'>4 g,
  \once\revert Score.BarLine.stencil
  \shortenBarLine\bar ".."

      d''8 b,16 c'' <e b'>\colLine a'\2 g'8\2 <a\4 e' c''> a,16 b'\index
      <d a d' a'>8 d''16 c'' <g, d' b'>8\colLine <c c''>16\colLine b'
      <d a d' a'> g' a'8 <g, g d' g'>2
  \once\revert Score.BarLine.stencil
  \shortenBarLine\bar ".."

      d''8 b,16 c'' <e b'>\colLine a'\2 g'8\2 <a\4 e' c''> a,16 b'
      <d a d' a'>4 <g, d' b'>8\colLine a'16 b' <c e' c''>8 <g, g' b'>\colLine
      <d d' fis' a'>2\colLine
  \once\revert Score.BarLine.stencil
  \bar "|"

  \time 5/8
      d''8 b,16 c'' <e b'>\colLine a'\2 g'4\2 
  \time 2/4
      <a\4 e' c''>8 a,16 b'
      <d a d' a'>8 d''16 c'' <g, d' b'>8\colLine <c c''>16\colLine b'
      <d a d' a'> g' a'8
  \time 6/8
      <g, g d' g'>4.
  \once\revert Score.BarLine.stencil
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
  piece = "Almayne Dowland — W. 5r"
}

\score {
  \new FrenchTabStaff {
    \omit Score.BarLine
    \omit Score.BarNumber
    \m
  }

  \layout {
    indent = 0\in
    ragged-last = ##t
  }
}
