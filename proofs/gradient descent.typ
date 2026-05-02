#import "../preamble.typ": *
#show: notes

= Gradient Descent

_Collection of essential background on gradient descent_

Following @jang2026pointconvergencenesterovsaccelerated, for $f : RR^p arrow.r RR$ we consider the optimisation problem

$
  min_(x in RR^p) f(x)
$<eq:1>

under certain assumptions on the function $f$.

== Preliminaries

#definition(title: "Convex functions")[
  A function $f : RR^p arrow.r RR$ is *convex* if $dom f subset.eq RR^p$ is a convex set and
  $
    forall x, y in RR^p, forall t in [0,1] : f((1-t)x + t y) <= (1-t)f(x) + t f(y).
  $<eq:eq1>
  A function is $mu$--*strongly convex* if $f(x) - mu / 2 norm(x)^2$ is a convex function, that is
  $
    forall x, y in RR^p, forall t in [0,1] : f((1-t)x + t y) <= (1-t)f(x) + t f(y) - (mu t (1-t))/2 norm(x - y)^2.
  $
]<def:convexfunction>

#lemma(title: "Jensen's ineqality characterisation")[
  Let $f in C^1(RR^p, RR)$ be convex. Then
  $
    forall x, y in RR^p : f(y) >= f(x) + chevron.l nabla f (x), y - x chevron.r.
  $<eq:eq1>
  Moreover, if $f$ is $mu$--strongly convex then
  $
    forall x, y in RR^p : f(y) >= f(x) + chevron.l nabla f (x), y - x chevron.r + mu/2 norm(y - x)^2.   
  $ 
]

If $x^* in arg min f$, then by Fermat's rule we have $nabla f(x^*) = 0$. Using this in the equation above yields
$
  forall y in RR^p : f(y) - f(x^*) >= mu / 2 norm(y - x^*)^2.
$
This is important because it means that any bound on the bevhaiour of $f(x) - f(x^*)$ automatically translates to a bound on $norm(x - x^*)^2$ - which is a critical connection for reasoning about convergence rates of algorithms.

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


#lemma(title: "Descent lemma")[

]

#proof[

]

== Gradient Descent Algorithm

The basic intuition for why an algorithm based on gradient steps can work is the following. Let $f in C^1 (RR^P, RR)$. By Taylor-Lagrange, we have
  $
    forall x, y in RR^p : f(y) = f(x) - chevron.l nabla f (x), y - x chevron.r + o (norm(y - x)) \
    therefore y = x - alpha nabla f(x) arrow.double.r f(x - alpha nabla f(x)) = f(x) - alpha norm(nabla f(x))^2 + o(alpha)
  $
  hence for $alpha > 0$ small enough, $f(x - alpha nabla f(x)) < f(x)$.

#definition(title: "Gradient Descent")[
  Let $f: RR^p arrow.r RR$. The gradient descent method generates the sequence $(x_k) subset.eq RR^p$ by:
  $
    &x_0 in RR^p text("(arbitrary)") \
    & x_(k+1) = x_k - alpha_k nabla f (x) quad text("for") k = 0, 1, ...
  $
  where $(alpha_k) > 0$ is called the 'learning rate' (can be dynamic or fixed).
]<def:gd>

The essential results on gradient descent under the typical assumptions on $f$ are contained in the following theorem.

#theorem(title: "Gradient Descent")[
  Let $f: RR^p arrow.r RR$ be $L$--smooth and convex. Then gradient descent
]<thm:gd>

/* document bibliograph */
#bibliography("../thesis.bib")