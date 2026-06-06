#import "preamble.typ": *
#show: notes
#set page(numbering: "1")

#set math.equation(numbering: "(1)")
#let nonum(eq) = math.equation(block: true, numbering: none, eq)
#set math.equation(supplement: none)

#title("Material surveyed up to the end of May")

Includes material read and discussed.

#outline()

Following @ryu2026, for $p in NN$, $f : RR^p arrow.r RR$ we consider the optimisation problem

$
  min_(x in RR^p) f(x)
$

under certain assumptions on the function $f$. Usually these assumptions are convexity and a $L$--Lipchitz gradient ($L$--smoothness).


#definition(title: "Convex functions")[
  A function $f : RR^p arrow.r RR$ is *convex* if $dom f subset.eq RR^p$ is a convex set and
  $
    forall x, y in RR^p, forall t in [0,1] : f((1-t)x + t y) <= (1-t)f(x) + t f(y).
  $<eq:eq1>
  A function is $mu$--*strongly convex* if $f(x) - mu / 2 norm(x)^2$ is a convex function, that is
  #nonum($
    forall x, y in RR^p, forall t in [0,1] : f((1-t)x + t y) <= (1-t)f(x) + t f(y) - (mu t (1-t))/2 norm(x - y)^2.
  $)
]<def:convexfunction>

#definition(title: [$L$--Lipschitz])[
  A function $f: RR^p arrow.r RR$ is $L$--Lipschitz if
  $
    exists L > 0 space space forall x, y in RR^p : abs(f(x) - f(y)) <= L norm(x - y).
  $
]<def:Lipschitz>

Lipschitz functions are of course continuous, but it also turns out that they are differentiable _almost everywhere_. Where the derivative (or gradient) exist, the norm is bounded by $L$.

#definition(title: [$L$--smooth])[
  A function $f: RR^p arrow.r RR$ is #box[$L$--smooth] for $L > 0$ if $nabla f$ is #box[$L$--Lipschitz], that is
  $
    forall x, y in RR^p : abs(nabla f(x) - nabla f(y)) <= L norm(x - y)
  $
]<def:Lsmooth>

#lemma(title: "Quadratic Upper Bound")[
  Let $f$ be differentiable and $L$--smooth. Then
  $
    forall x, y in RR^p : lr(|, size: #150%) f(y) - f(x) - chevron.l nabla f(x), y - x chevron.r lr(|, size: #150%) <= L / 2 norm(y - x)^2
  $
]<lma:qub>

#proof[
  Idea: express $f(y) - f(x)$ as the integral of the gradient on the segment $[x, y]$ and then use the Lipschitzness to bound the gradient.
  #nonum(
  $
    f(y) - f(x) &= integral_0^1 chevron.l nabla f(x + t(y - x)), y - x chevron.r text("d")t space space (text("FTC1 on") g(t) text("over") [0,1]) \
    &= (integral_0^1 chevron.l nabla f(x + t(y - x)) - nabla f (x), y - x chevron.r text("d")t ) + chevron.l nabla f (x), y - x chevron.r \
    &<= (integral_0^1  || nabla f(x + t(y - x)) - nabla f (x)|| ||y - x||  text("d")t ) + chevron.l nabla f (x), y - x chevron.r \
    &=(integral_0^1 L t norm(y - x)^2 text("d")t) + chevron.l nabla f (x), y - x chevron.r \
    &= L / 2 norm(y - x)^2 + chevron.l nabla f (x), y - x chevron.r
  $
  )

]

#corollary[
  If $f$ is differentiable and $L$--smooth (@lma:qub), _and additionally $f$ is convex_, then
  $
    0 <= f(y) - f(x) - chevron.l nabla f(x), y - x chevron.r why("convexity")
  $
  and therefore from @lma:qub,
  $
    0 <= f(y) - f(x) - chevron.l nabla f(x), y - x chevron.r <= L / 2 norm(y - x)^2
  $<eq:quadraticub>
]<cor:convexLsmooth>

Setting $y = x - 1/ L nabla f(x)$ (i.e. one gradient step) in the above Corollary, we have for all $x in RR^p$:
$
  f(x - 1 / L nabla f(x)) - f(x) <=- 1/(2L) norm(nabla f(x))^2.
$

So one step of gradient descent is sure to decrease the function value by at least $norm(nabla f(x))^2 times$ a constant (when $f$ is convex).

= Gradient Descent

#definition(title: "Gradient Descent")[
  Let $f: RR^p arrow.r RR$. The gradient descent method generates the sequence $(x_k) subset.eq RR^p$ by:
  $
    &x_0 in RR^p text("(arbitrary)") \
    & x_(k+1) = x_k - alpha_k nabla f (x) quad text("for") k = 0, 1, ...
  $
  where $(alpha_k) > 0$ is called the 'learning rate' (can be dynamic or fixed).
]<def:gd>

#theorem(title: [Gradient Descent for convex, $L$--smooth functions])[
  
  Let $f: RR^p arrow.r RR$ be a convex differentiable function that has a minimiser $x^*$ and whose gradient is $L$--Lipschitz ($f$ is $L$--smooth).

  Gradient descent with a constant learning rate $alpha_k = 1 \/ L$ satisfies

  _value congerence:_
  $
    f(x_k) - f(x^*) <= (L norm(x_0 - x^*)^2) / (2k) = O(1\/k)
  $<eq:conv-in-value>
  point convergence:
  $
    x_k arrow.r x_infinity text("as") k arrow.r infinity
  $<eq:conv-in-interates>
]<thm:gd>

= Potential Functions

= Nesterov Gradient Descent

== Point Convergence (Jang and Ryu, 2026)

= Complexity Theory (e.g. Nemirovski textbook, Bubeck monograph)

In this context, the concept of 'complexity' refers to bounds on the worst-case performance of an algorithm that aims to minimise a function $f$. What is different to some other contexts is that the worst-case bound (if tight) is attained _for some particular function $f$_ among some class. The idea is usually to find a lowerbound for the quantity $f(x_N) - f_star$, where the lowerbound is over all functions $f$ and all algorithms after $N$ iterations. For example, @Drori2017 finds a lowerbound for this quantity for the familiar class of convex, $L$--smooth functions.


=== Informational complexity of convex, $L$--smooth functions

For the 

@Drori2017

= Extensions

== Optimal Gradient Descent

== FISTA (Beck and Toubelle 2009, Chambolle and Dossal 2015)

== Performance Estimation Problem

= Potential future work

- Potential to add some proofs into the 'unification' scheme of potential functions etc
- Calculate a minimax risk in a particular situation, perhaps a situation relevant to economics?

#bibliography("thesis.bib")