\version "2.21.0"

\include "oll-core/package.ily"
\loadPackage lute-tab

m = \relative c { \time 2/4
		  <d a' d>4 <a' d>8 <a, a' cis>
		  \bar "|" % 1
		  <d d'>8\colLine a'4 <a, a' e'>8\colLine
		  \bar "|" % 2
		  <d a' f>8 d'8 <c, c' e> <d a' d>
		  \bar "|" % 3
		  <a a' cis e>8 a'8\4 a,4
		  \bar "|" % 4
		  <d d'>16\colLine cis'\index d e\index f g\index <a,, a' e'>8\colLine
		  \bar "|" % 5
		  <d d'>8\colLine a'4 <a, a' e'>8\colLine
		  \bar "|" % 6
		  <d a' f'>16 g'\index a f\index g f <d, e'>\colLine d'
		  \bar "|" % 7
		  <a, cis' e>8 a'\4 a,4
		  \shortenBarLine\bar ".." % 8

		  <f' c' f a>8. d'32 e\index f e\index f e\index f e\index d e\index
		  \bar "|" % 9
		  <f, f' a>8 c' f,4
		  \bar "|" % 10
		  <f a'>8 c'' b <a f>
		  \bar "|" % 11
		  <c,, c' e g> g' c,4
		  \bar "|" % 12
		  <c c' e>8. g''16\index c8 bes
		  \bar "|" % 13
		  <d,, d' a'>8.\colLine g'16 f8 
		  <f, a'>\colLine
		  \bar "|" % 14
		  <g, bes''>16\colLine a''\index g f\index <a,, a' e'>\colLine d'\index e8\middle
		  \bar "|" % 15
		  <d, fis a d> fis d4
		  \shortenBarLine\bar ".." % 16

		  <f c' f a>8. c'16\index d e\index f g\index
		  \bar "|" % 17
		  <f, a'>8\colLine f'\index c g'\index
		  \bar "|" % 18
		  <f, a'>\colLine c''\index b c\index 
		  \bar "|" % 19
		  <f, a> <c, c' e g>16 g' c,4
		  \bar "|" % 20
		  <f a' c>16 d''\index <g, bes> c\index <f, a> bes\index <e, g> a\index
		  \bar "|" % 21
		  <d,, a' f'> g'\index e f\index d8 a'\index
		  \bar "|" % 22
		  <g,, bes''>16.\colLine a''32\index g16 f <a, e'> d e8
		  \bar "|" % 23
		  <d, a' d> fis d4
		  \bar "|" % 24
		  <d a' d>16. e'32\index f8\middle cis,16 g''\middle e8\index
		  \bar "|" % 25
		  <d, a' f'>16. g'32\index a8\middle a,16 g'\middle e8
		  \bar "|" % 26
		  <d, a' f'>16 g'\index <f, a'>\colLine g'\index <g,, bes''>\colLine a''\index g f\index
		  \bar "|" % 27
		  <a,, e''>\colLine cis'\index a d\index cis a\index a e'\index
		  \bar "|" % 28
		  <d, d'>\colLine a'\index d e\index f d\index <cis, a' e'>8
		  \bar "|" % 29
		  <d a' d>16 a d e f d <a' cis e>8
		  \bar "|" % 30
		  <d, a' f'>16 g'\index a f\index <c, g''>\colLine a <bes f''>\colLine g
		  \bar "|" % 31
		  <a cis' e>\colLine <cis' e> a\4 d\3 <a, cis' a e'>4
		  \bar "|" % 32
		  <f' c' f>16. g'32\index a8 <f, a'>16.\colLine\index bes'32 c8
		  \bar "|" % 33
		  <f,, c' f>16. bes32 c8 d16. e32 f8
		  \bar "|" % 34
		  <f, f'>16. g'32\index a16. bes32 c8 a
		  \bar "|" % 35
		  <c,, c'>16. d'32 e16. f32 g8 e
		  \bar "|" % 36
		  <c, c'>16. d'32\index e8 e16.\index f32 g8\index
		  \bar "|" % 37
		  <d, a' d>16. e'32\index f16 g a f g a
		  \bar "|" % 38
		  <g,, d'' bes'>16.\colLine a''32 g16 f <a,, a' e'>\colLine d' e8\arpAbove
		  \bar "|" % 39
		  <d, a' d> fis <d a' d>4
		  \shortenBarLine\bar ".." % 40

		  <c c''>16\colLine a''\index a f\index a f\index f c\index
		  \bar "|" % 41
		  f, c'\index d f\index f g\index a8
		  \bar "|" % 42
		  <f, c''>16\colLine a'\index a f\index f a\index g f\index
		  \bar "|" % 43
		  c, g''\index c g\index a g\index e8\middle
		  \bar "|" % 44
		  c,16 g''\index c g\index a g\index f e\index
		  \bar "|" % 45
		  d a'\index d a\index bes a\index g f\index
		  \bar "|" % 46
		  <g,, g''>\colLine f''\index e d\index e d\index <a, a' e'>8
		  \bar "|" % 47
		  <d a' d> fis d8
		  \shortenBarLine\bar ".." % 48
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
  piece = "Fortune Mr. Dowland — W. 2r"
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
