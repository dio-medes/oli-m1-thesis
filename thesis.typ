/* document template */
#import "template.typ": thesis_title
#set page(paper: "a4", margin: (x: 2.5cm, y: 3cm))

/* document metadata */

#set document(title: [
Nesterov Accelerated Gradient Descent
])

#show: thesis_title.with(
  authors: (
    (
      name: "Oliver Richard Cutbill",
      affiliation: "Toulouse School of Economics",
      email: "oliver-richard.cutbill@ut-capitole.fr",
    ),
  ),
  abstract: "this is an abstract"
)

/* document begins */

== Introduction

This thesis is based on @jang2026pointconvergencenesterovsaccelerated. Consider a function $f: bb(R)^p arrow.r bb(R)$ that is convex, $L$-smooth, and satisfies $inf(f) > -infinity$. Then ...


/* document bibliograph */
#bibliography("thesis.bib")