%%%
%%% Options
%%%

\registerOption lily-lute.raiseNoteHeads              #0.32
\registerOption lily-lute.labelFont                   #"Bravura"

\registerOption lily-lute.tab-duration.useFlags       ##t
\registerOption lily-lute.tab-duration.useNoteHeads   ##f
\registerOption lily-lute.tab-duration.useGrids       ##t
\registerOption lily-lute.tab-duration.hideRepeated   ##t
\registerOption lily-lute.tab-duration.useMensural    ##t
\registerOption lily-lute.tab-duration.mensuralModifier #0
\registerOption lily-lute.tab-duration.gridSlant      #.75
\registerOption lily-lute.tab-duration.slantType      #'extend
\registerOption lily-lute.tab-duration.maxGrid        #4

\registerOption lily-lute.hold-line.attachToClosest   ##t
\registerOption lily-lute.hold-line.flatLines         ##f
\registerOption lily-lute.hold-line.diapasonLevel     #-4.5

%%%
%%% Includes
%%%

\include   "snippets/custom-music-fonts/smufl/smufldata.ily"

\include   "col-line/engine.ily"
\include   "tab-articulation/engine.ily"
\include   "tab-duration/engine.ily"
\include   "hold-line/engine.ily"

\include   "markups.ily"
\include   "contexts.ily"
