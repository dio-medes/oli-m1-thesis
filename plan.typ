#import "preamble.typ": *
#show: notes
#set page(numbering: "1")

#set math.equation(numbering: "(1)")
#let nonum(eq) = math.equation(block: true, numbering: none, eq)
#set math.equation(supplement: none)

#title("Thesis outline")

= Research Question

Is it possible to accelerate the gradient algorithm using only first-order information? The well known answer to this question has been yes since Nesterov's the seminal paper @Nesterov83. However, only very recent contributions to the literature (@ryu2026, @ChambolleDossal2025) have been able to show that popular acceleration methods retain the desirable property of point convergence of the plain gradient algorithm.

= Scaffold

== Introduction

== Min cvx smooth functions
broad technical context

talk about applications

arg min is the quantity of interest, favourable

== Nesterov's method

Algo, rate, upper bounds

== Complexity in cvx optimisation

semi, lower bounds

== Point convergence

chambolle, dossal, ryu

== Extensions, variations

Non-smooth prox FISTA

continuous time

PEP

== Conclusion

non-smooth is not so bad but non-convex is nightmare



#bibliography("thesis.bib")