/* minimal packages required */
#import "@preview/hydra:0.6.2": hydra

/* document styling */

// page, margins
#set page(paper: "a4", margin: (x: 2.5cm, y: 3cm))

// page numbering, heading in top right corner
#set page(
  numbering: "1",
  number-align: center + bottom,
  header: context {
    if counter(page).get().first() >= 2 {
      align(right, hydra())
    }
  }
)

/* document metadata */

#set document(title: [
Nesterov Accelerated Gradient Descent
])

/* document begins */

// Title block
#align(center)[
  #text(size: 18pt, weight: "bold")[#context document.title]
  #v(0.5em)
  Oliver Richard Cutbill \
  Toulouse School of Economics \
  #link("mailto:oliver-richard.cutbill@ut-capitole.fr")
  #v(1em)
  *Abstract* \
  This is an abstract.
  #v(1em)
]

= Introduction

This thesis is based on @jang2026pointconvergencenesterovsaccelerated and is closed related to @bot2025iteratesnesterovsacceleratedalgorithm. Consider a function $f: bb(R)^p arrow.r bb(R)$ that is convex, $L$-smooth, and satisfies $inf(f) > -infinity$. Then ...

= Next section


/* document bibliograph */
#bibliography("thesis.bib")