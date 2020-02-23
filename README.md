# lute-tab

*lute-tab* is a set of tools and fonts used for typesetting lute tablature
in the calligraphic styles that reflect those found in selected manuscripts.
This package is intended to be used with GNU LilyPond.
It belongs to *openLilyLib*, LilyPond's community library system.
Therefore getting and installing *lute-tab* is automatically handled by
preparing *openLilyLib*.
See its [home page](https://github.com/openlilylib/openlilylib) for details.

As part of *openLilyLib*, this library is released under the
GNU General Public License. See *openLilyLib*'s license for details.

## Overview

*lute-tab*'s development is ongoing, but it currently includes a font and
a number of functions used for typesetting Renaissance Lute music in French-
style tablature. A short list of these includes:

* The `Welde` font, which was designed to match the calligraphic style found
  in the __Welde Lute Book__
* The `FrenchTabStaff` context
* The `\colLine` function, which draws a vertical line between the bass and
  treble note(s)
* Functions for drawing RH-fingering directives
* Utilities for drawing durational flags & grids

## Getting Started

### Installing the Font Files

The correct fonts will need to be installed. Currently, the Welde font only 
includes glyphs for note labels (a--g), and the RH articulations are borrowed
from the Bravura font. Both fonts should be installed by copying the OTF file
into the directory `/usr/share/lilypond/<version>/fonts/otf/` of the LilyPond
installation (or to `out/share/lilypond/current/fonts/otf/` if running from
source code).

The Welde font OTF is available in `fonts/otf/Welde.otf`, and the Bravura font
is available either from OLL -- `snippets/custom-music-fonts/smufl` -- or from
the [the SMuFL website](http://www.smufl.org/fonts/)

### Using the Package

Prerequisite to using *lute-tab* is activating *openLilyLib* with

```lilypond
\include "oll-core/package.ily"
```

*openLilyLib* will only be initialized once so it is safe to use this command in 
multiple initialization files. *lute-tab* is loaded with *openLilyLib*'s `\loadPackage` utility:

```lilypond
\loadPackage lute-tab
```

Currently, all of *lute-tab*'s internal modules are loaded implicitly, so
there is no need to declare modules to be loaded explicitly.

The current options for *lute-tab* are:

* raiseNoteHeads: How much the note-head labels should be raised in staff-space units
  (default - 0.32)
* labelFont: Which font should be used to typeset the note-head labels? Currently the
  only options are 'Bravura or 'Welde. 
  (default - 'Welde)

* tab-duration.hideRepeated: Should repeated durations print a flag?
  (default - #t)
* tab-duration.useGrids: Should grids be used?
  (default - #t)
* tab-duration.gridSlant: How much slant in the duration grids in staff-space units
  (default - 0.75)
* tab-duration.slantType: Should the grid poles be extended ('extend) or shifted
  ('shift) to accomodate the slant
  (default - 'extent)
* tab-duration. maxGrid: The total number of notes allowable in a grid
  (default - 4)
