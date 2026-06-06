#import "preamble.typ": *
#show: notes
#set page(numbering: "1")

#set math.equation(numbering: "(1)")
#let nonum(eq) = math.equation(block: true, numbering: none, eq)
#set math.equation(supplement: none)

#title("Draft thesis outline")

== Research Question

What is the significance of the recent proof of the point convergence of Nesterov's accelerated gradient method @ryu2026 in terms of the adjacent literature on acceleration of first-order methods for convex optimisation?

Goal of the thesis is to give an overview of the state of knowledge on this question, using @ryu2026 as an entry point and tracing a narrow path through the literature to this work starting from Nesterov's original proposal of his acceleration method @Nesterov83.

= Plan

== 1. Minimisation of smooth, convex functions

- Presentation of the problem of interest: $min f$ where $f$ is convex and $L$--smooth.
- Cover relevant important properties of convex and $L$--smooth functions. Why are these important or natural constraints on the problem? Give examples.
- Plain Gradient Descent method, give streamlined proofs of convergence in value and point convergence using Lyapunov function approach (e.g. from @Bansal2019 but motivate the introduction of 'potential functions' more clearly).

== 2. Nesterov's accelerated gradient method and complexity
- Introduce concepts: algorithms as 'black boxes' that output sequences of given length; first-order methods as a class of algorithms; oracles and computational/informational cost.
- Nesterov's Accelerated Gradient Method, introduction, simplified proof given by Nesterov (use Lyapunov approach again @Bansal2019).
- Nimerovskii complexity result on the lower bound speed of convergence in value - Nesterov's method attains this value which is why it is interesting.
- Potentially mention other more recent complexity results, like @Drori2017.

== 3. Point convergence of accelerated methods
- Present the point convergence of Nesterov's gradient method from @ryu2026
- Discuss FISTA method, point convergence, differences with NAG that allowed researchers to find the proof first (also discuss section 3 of Nesterov's original paper in this context).
- Present OGM in the context of PEP

== 4. Discuss potential paths forward
- Subject to further planning

#bibliography("thesis.bib")