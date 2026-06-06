/* minimal packages required */
#import "@preview/hydra:0.6.2": hydra
#import "preamble.typ": *

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
The literature leading to the AI-assisted proof of point convergence of Nesterov's Accelerated Gradient Method
])

/* document begins */

// Title block
#align(center)[
  #text(size: 18pt, weight: "bold")[#context document.title]
  #v(0.5em)
  Oliver Richard Cutbill \
  Supervised by Professor Edouard Pauwels
  #v(1em)
  *Abstract* \
  ...
  #v(1em)
]

= Introduction

- Definition of the main problem: minimising a continuous, convex, and L-lipschitz function
- Importance of convex and L-lipschitz, meanings, convexity and Lipschitz inequalities
- Plain gradient descent method, acceleration methods, well-known basic facts about these
- Nesterov Gradient Descent, key facts
- Ryu Theorem 3.5 stated
- Why is point convergence important
- Not doing things in chronological order but it will be noted in some pleaces

= Complexity

- Explanation of key concepts: algorithms as black boxes that generate sequences; information oracles; given a certain black box, lowerbounds on the suboptimality gaps for classes of functions
- The analysis of convex optimization algorithms via oracle complexity and lower complexity bounds were first studied








/* document bibliograph */
#bibliography("thesis.bib")