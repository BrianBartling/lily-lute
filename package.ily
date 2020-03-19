%%%
%%% Options
%%%

\registerOption tab-tools.raiseNoteHeads              #0.32
\registerOption tab-tools.labelFont                   #"Bravura"

\registerOption tab-tools.tab-duration.hideRepeated   ##t
\registerOption tab-tools.tab-duration.useGrids       ##t
\registerOption tab-tools.tab-duration.gridSlant      #.75
\registerOption tab-tools.tab-duration.slantType      #'extend
\registerOption tab-tools.tab-duration.maxGrid        #4

\registerOption tab-tools.hold-line.attachToClosest   ##t
\registerOption tab-tools.hold-line.diapason-level    #-4.5

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
