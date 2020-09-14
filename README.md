# lily-lute

*lily-lute* contains a variety of tools used for typesetting
French-style Renaissance lute tablature.

This package is intended to be used with GNU LilyPond.
It belongs to *openLilyLib*, LilyPond's community library system.
Therefore getting and installing *lily-lute* is automatically handled by
preparing *openLilyLib*.
See its [home page](https://github.com/openlilylib/openlilylib) for details.

As part of *openLilyLib*, this library is released under the
GNU General Public License. See *openLilyLib*'s license for details.

## Overview

A short list of *lily-lute*'s features includes:

* Utilities for drawing durational flags & grids, a style seen often in English Renaissance tablature
* The `FrenchTabStaff` context
* The `\colLine` function, which draws a vertical line between the bass and
  treble note(s)
* Functions for drawing RH-fingering directives
* Hold lines and other assorted markups

## Getting Started

### Installing the Font Files

*lily-lute* requires the Bravura fonts ands its accompanying SMuFL encoding definitions (snippets/custom-music-fonts/smufl/smufldata.ily).
Both are available in the
`snippets/custom-music-fonts/smufl` OLL package, but the font can also be installed
from the [the SMuFL website](http://www.smufl.org/fonts/)

### Using the Package

Prerequisite to using *lily-lute* is activating *openLilyLib* with

```lilypond
\include "oll-core/package.ily"
```

*openLilyLib* will only be initialized once so it is safe to use this command in 
multiple initialization files. *lily-lute* is loaded with *openLilyLib*'s `\loadPackage` utility:

```lilypond
\loadPackage lily-lute
```

All of *lily-lute*'s internal modules are loaded implicitly, so
there is no need to declare modules to be loaded explicitly.

The current options for *lily-lute* are:

* raiseNoteHeads: How much the note-head labels should be raised in staff-space units
  (default - `0.32`)
* labelFont: Which font should be used to typeset the note-head labels? Currently the
  only option is `"Bravura"`, but can be set to another font if implemented according to 
  the smufl encoding definitions.
  (default - `"Bravura"`)

* tab-duration.useFlags: Should durations use flags?
  (default - `#t`)
* tab-duration.useNoteHeads: Should durations use noteheads?
  (default - `#f`)
  
  *Either tab-duration.useFlags or tab-duration.useNoteHeads should be `#t`*

* tab-duration.useGrids: Should grids be used?
  (default - `#t`)
* tab-duration.hideRepeated: Should repeated durations print a flag?
  (default - `#t`)
* tab-duration.useMensural: Should non-grid durations use mensural flags?
  (default - `#t`)
* tab-duration.mensuralModifier: The mensural flags are taken from the parmesan fonts. Which set of flags?
  (default - `0`)
* tab-duration.gridSlant: How much slant in the duration grids in staff-space units
  (default - `0.75`)
* tab-duration.slantType: Should the grid poles be extended (`'extend`) or shifted
  (`'shift`) to accomodate the slant
  (default - `'extend`)
* tab-duration. maxGrid: The total number of notes allowable in a grid
  (default - `4`)

* hold-line.allLines: Attach a hold line to all potential note values
  (default - `#f`)
* hold-line.attachToClosest: Should the hold line try to attach to the closest notehead?
  (default - `#t`)
* hold-line.flatLines: Should the hold lines be flat by default?
  (default - `#f`)