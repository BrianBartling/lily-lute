# tab-tools

*tab-tools* is a toolbox for typesetting lute tablature, but is currently only
implemented for the French Renaissance style.
This package is intended to be used with GNU LilyPond.
It belongs to *openLilyLib*, LilyPond's community library system.
Therefore getting and installing *tab-tools* is automatically handled by
preparing *openLilyLib*.
See its [home page](https://github.com/openlilylib/openlilylib) for details.

As part of *openLilyLib*, this library is released under the
GNU General Public License. See *openLilyLib*'s license for details.

## Overview

*tab-tools*'s development is ongoing, it currently includes a
a number of functions used for typesetting Renaissance Lute music in French-
style tablature. A short list of these includes:

* Utilities for drawing durational flags & grids
* The `FrenchTabStaff` context
* The `\colLine` function, which draws a vertical line between the bass and
  treble note(s)
* Functions for drawing RH-fingering directives

## Getting Started

### Installing the Font Files

The correct fonts will need to be installed. Currently, only the luteFrench*
glyphs from the Bravura font can be used with this package. The font
is available either from OLL -- `snippets/custom-music-fonts/smufl` -- or from
the [the SMuFL website](http://www.smufl.org/fonts/)

### Using the Package

Prerequisite to using *tab-tools* is activating *openLilyLib* with

```lilypond
\include "oll-core/package.ily"
```

*openLilyLib* will only be initialized once so it is safe to use this command in 
multiple initialization files. *tab-tools* is loaded with *openLilyLib*'s `\loadPackage` utility:

```lilypond
\loadPackage tab-tools
```

All of *tab-tools*'s internal modules are loaded implicitly, so
there is no need to declare modules to be loaded explicitly.

The current options for *tab-tools* are:

* raiseNoteHeads: How much the note-head labels should be raised in staff-space units
  (default - `0.32`)
* labelFont: Which font should be used to typeset the note-head labels? Currently the
  only options are 'Bravura or 'Welde. 
  (default - `'Welde`)

* tab-duration.hideRepeated: Should repeated durations print a flag?
  (default - `#t`)
* tab-duration.useGrids: Should grids be used?
  (default - `#t`)
* tab-duration.gridSlant: How much slant in the duration grids in staff-space units
  (default - `0.75`)
* tab-duration.slantType: Should the grid poles be extended ('extend) or shifted
  ('shift) to accomodate the slant
  (default - `'extent`)
* tab-duration. maxGrid: The total number of notes allowable in a grid
  (default - `4`)
