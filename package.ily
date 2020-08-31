%%%
%%% Options
%%%

\registerOption lute-tab.raiseNoteHeads              #0.32
\registerOption lute-tab.labelFont                   #"Bravura"

\registerOption lute-tab.tab-duration.useFlags       ##t
\registerOption lute-tab.tab-duration.useGrids       ##t
\registerOption lute-tab.tab-duration.useNoteHeads   ##f
\registerOption lute-tab.tab-duration.hideRepeated   ##t
\registerOption lute-tab.tab-duration.useMensural    ##t
\registerOption lute-tab.tab-duration.mensuralModifier #0
\registerOption lute-tab.tab-duration.gridSlant      #.75
\registerOption lute-tab.tab-duration.slantType      #'extend
\registerOption lute-tab.tab-duration.maxGrid        #4

\registerOption lute-tab.hold-line.attachToClosest   ##t
\registerOption lute-tab.hold-line.flatLines         ##f
\registerOption lute-tab.hold-line.diapasonLevel     #-4.5

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
