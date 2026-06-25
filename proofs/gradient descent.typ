#import "../preamble.typ": *
#show: notes

#set page(numbering: "1")

#set math.equation(numbering: "(1)")
#let nonum(eq) = math.equation(block: true, numbering: none, eq)
#set math.equation(supplement: none)

= Gradient Descent

_Collection of essential background on gradient descent_

Following @jang2026pointconvergencenesterovsaccelerated, for $f : RR^p arrow.r RR$ we consider the optimisation problem

$
  min_(x in RR^p) f(x)
$

under certain assumptions on the function $f$.

The basic intuition for why an algorithm based on gradient steps can work is the following. Let $f in C^1 (RR^P, RR)$. By Taylor-Lagrange, we have
#nonum(
  $
    forall x, y in RR^p : f(y) = f(x) - chevron.l nabla f (x), y - x chevron.r + o (norm(y - x)) \
    therefore y = x - alpha nabla f(x) arrow.double.r f(x - alpha nabla f(x)) = f(x) - alpha norm(nabla f(x))^2 + o(alpha)
  $
)
  hence for $alpha > 0$ small enough, $f(x - alpha nabla f(x)) < f(x)$.

== Preliminaries

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

Used less often is the notation of *strict* convexity, where the convexity inequality holds strictly.

#lemma(title: "All convex functions are continuous")[
  Let $f : RR^p arrow.r RR$ be convex. The $f in C(RR^p, RR)$.
]

#proof[
  Via a 'bowtie' around a point and then using the squeeze law.
]

#lemma(title: [$C^1$ convex functions and minima])[
  
  If $f in C^1(RR^p, RR)$ is convex, then
  1. $f$ convex $arrow.double.r$ local minima are global minima ($nabla f (x^*) = 0$ in @lem:foc)
  2. $f$ strictly convex $arrow.double.r$ if it exists, $x^*$ is unique and global (same proof)
  3. $f$ strongly convex $arrow.double.r$ $x^*$ the global minimiser exists and is unique (coercive)
]

It is possible to show at least the first result above without assuming that $f$ is differentiable, and taking only the definition of local minimum as
#nonum(
$
  exists epsilon > 0 space forall x in B(x^*, epsilon) : f(x) >= f(x^*).
$
)
Take $y!=x$ arbitrary. Rearranging the convexity inequality to
$
  f((1 - t)x^* + t y) - f(x^*) <= t (f(y) - f(x^*))
$
and taking $t < epsilon \/ norm(y - x^*)$ gives
$
  norm(lr(\(, size: #150%) (1 - t) x^* + t y lr(\), size: #150%) - x) < t norm(y - x) < epsilon space arrow.double.r (1 - t) x^* + t y in B(x^*, epsilon)
$
and hence from above and since $x^*$ is a local minimum
$
  0 <= f(y) - f(x^*).
$
Therefore $x^*$ is a global minimum.

#lemma(title: "First order characterisation")[
  Let $f in C^1(RR^p, RR)$ be convex. Then
  $
    forall x, y in RR^p : f(y) >= f(x) + chevron.l nabla f (x), y - x chevron.r.
  $<eq:eq1>
  Moreover, if $f$ is $mu$--strongly convex then
  $
    forall x, y in RR^p : f(y) >= f(x) + chevron.l nabla f (x), y - x chevron.r + mu/2 norm(y - x)^2.   
  $ 
]<lem:foc>

For the convex case, the above lemma can be seen as a _supporting hyperplane_ result if you consider that the _epigraph_ of a convex function is a convex set. The epigraph consists of points in $RR^(p+1)$ and its members have the form $(f(x), x) in RR^(p+1)$. The supporting hyperplane vector is then $(1, - nabla f (x))$.

If $x^* in arg min f$, then by Fermat's rule we have $nabla f(x^*) = 0$. Using this in the equation above yields
$
  forall y in RR^p : f(y) - f(x^*) >= mu / 2 norm(y - x^*)^2.
$
This is important because it means that any bound on the bevhaiour of $f(x) - f(x^*)$ automatically translates to a bound on $norm(x - x^*)^2$ -- which is a critical connection for reasoning about convergence rates of algorithms.

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

#remark(title: [Strongly convex duality with $L$--smooth])[
  Putting together the strongly convex inequality and the quadratic upperbound we have that for $f: RR^p arrow.r RR$ strongly convex and $L$--smooth, if $x^* arg min f$ then
$
  forall x in RR^p : mu / 2 norm(x - x^*)^2 <= f(x) - f(x^*) <= L / 2 norm(x - x^*)^2.
$

So $mu$ provides a lower bound on the function values and $L$ proves an upper bound. Such functions $f$ are therefore bounded by two quadratics.
]

#theorem(title: "Subgradient inequality under smoothness")[
  
  Let $f: RR^p arrow.r RR$ be such (@eq:quadraticub) holds (no another assumptions). Then we have the following inequality too:
  $
    forall x, y in RR^p : f(x) - f(y) &<= \ chevron.l nabla &f(x), x - y chevron.r - 1/(2L) norm(nabla f(x) - nabla f(y))^2
  $
]<thm:subgradient>

#proof[
  The key to the proof is to consider the point $z = x - 1 / beta (nabla f(x) - nabla f(y))$. Writing $f(y) - f(x)$ as $f(y) - f(z) + f(z) - f(x)$ and then using the above inequality twice and substituting in the definition of $z$ gives the result.
]


#corollary(title: [Inequality characterisation of convexity and $L$-smoothness])[
  
  Let $f: RR^p arrow.r RR$. Then $f$ is convex and $L$--smooth if and only if
  $
    0 <= f(y) - f(x) - chevron.l nabla f(x), y - x chevron.r <= L / 2 norm(y - x)^2
  $
  That is, (@eq:quadraticub) is a characterisation of convexity and $L$--smoothness. 
  
  _Note that both inequalities here are important._
]<cor:convexityLSmoothness>

#proof[
  $arrow.double.r$ is @cor:convexLsmooth, and $arrow.double.l$ is @thm:subgradient (eval at $(x,y)$ and $(y, x)$, then add the inequalities).
]

== Gradient Descent Algorithm

#definition(title: "Gradient Descent")[
  Let $f: RR^p arrow.r RR$. The gradient descent method generates the sequence $(x_k) subset.eq RR^p$ by:
  $
    &x_0 in RR^p text("(arbitrary)") \
    & x_(k+1) = x_k - alpha_k nabla f (x) quad text("for") k = 0, 1, ...
  $
  where $(alpha_k) > 0$ is called the 'learning rate' (can be dynamic or fixed).
]<def:gd>

The essential results on gradient descent under the typical assumptions on $f$ are contained in the following theorem.

#theorem(title: [Gradient Descent for convex, $L$--smooth functions])[
  
  Let $f: RR^p arrow.r RR$ be a convex differentiable function that has a minimiser $x^*$ and whose gradient is $L$--Lipschitz ($f$ is $L$--smooth).

  Gradient descent with a constant learning rate $alpha_k = 1 \/ L$ satisfies

  _convergence in value:_
  $
    f(x_k) - f(x^*) <= (L norm(x_0 - x^*)^2) / (2k) = O(1\/k)
  $<eq:conv-in-value>
  _convergence in iterates:_
  $
    x_k arrow.r x_infinity text("as") k arrow.r infinity
  $<eq:conv-in-interates>
]<thm:gd>

#proof[ The proof of convergence in value is a more verbose and personal reproduction of that in @Bubeck_2015, which is itself a simplified version of Nesterov's proof in his 2004 lecture notes.

From @cor:convexLsmooth we know that a single gradient step satisfies
$
  f(x - 1 / L nabla f(x)) - f(x) <=- 1/(2L) norm(nabla f(x))^2.
$
or more generally
$
  f(x_(k+1)) - f(x_k) <= 1/(2L) norm(nabla f (x))^2.
$<eq:gradstep>
Define
$
  delta_k := f(x_k) - f(x^*) text("for") k = 0, 1, ...
$
Then we have

$
 delta_(k+1) equiv f(x_(k+1)) - f(x^*) &<=_((#ref(<eq:gradstep>))) f(x_k) - f(x^*) - 1/(2L) norm(nabla f (x_k))^2 \ &equiv delta_k - 1/(2L) norm(nabla f (x_k))^2.
$<eq:tool1>

Since $f$ is convex, by the first order characterisation we have
$
  delta_k equiv f(x_k) - f(x^*) &<= chevron.l f(x_k), x_k - x^* chevron.r \
  &<= norm(x_k - x^*) dot norm(nabla f (x_k)) quad why("Cauchy Schwarz")
$<eq:tool2>

The next idea is to show that $norm(x_k - x^*)$ is weakly decreasing in $k$. It turns out that if we can show show, the above recurrence inequality will telescope to exactly what we want.

From @cor:convexityLSmoothness, we have (by same twice-eval-and-add trick noted in the proof):

$
  1 / L norm(nabla f(x) - nabla f (y))^2 <= chevron.l nabla f(x) - nabla f(y), x - y chevron.r
$<eq:twice-eval-and-add>

Then, since $nabla f(x^*) = 0$, we have

$
  norm(x_(k+1) - x^*)^2 &= norm(x_k - 1/L nabla f(x_k) - x^*) = norm((x_k - x^*) - (1/L nabla f(x_k))) \
  &= norm(x_k - x^*)^2 + 1/L^2 norm(nabla f(x_k))^2 - 2/L chevron.l x_k - x^*, nabla f (x_k) chevron.r \
  &= norm(x_k - x^*)^2 + 1/L^2 norm(nabla f(x_k))^2 \
  & #h(3.5cm) - 2/L chevron.l x_k - x^*, nabla f (x_k) - nabla f(x^*) chevron.r \
  &<= norm(x_k - x^*)^2 + 1/L^2 norm(nabla f(x_k))^2 \ 
  & #h(3.5cm)- 2/L (1/L norm(nabla f (x_k) - nabla f(x^*))^2) #why(ref(<eq:twice-eval-and-add>)) \
  &= norm(x_k - x^*)^2 + 1/L^2 norm(nabla f(x_k))^2 - 2/L^2 norm(nabla f (x_k))^2 #why($nabla f(x^*) = 0$) \
  &= norm(x_k - x^*)^2 - 1/L^2 norm(nabla f(x_k))^2 \
  &<= norm(x_k - x^*)^2
$

With $norm(x_k - x^*)$ proven to weakly decrease in $k$, the next idea is to use (@eq:tool1) and (@eq:tool2) together and find a telescoping sum. Squaring (@eq:tool2), we get

$
  delta_k^2 / norm(x_k - x^*)^2 <= norm(nabla f(x_k))^2
$

and since $norm(x_k - x^*) <= norm(x_0 - x^*)$,

$
  delta_k^2 / norm(x_0 - x^*)^2 <= delta_k^2 / norm(x_k - x^*)^2 <= norm(nabla f(x_k))^2.
$

Using this in (@eq:tool1) we get

$
  delta_(k+1) <= delta_k - delta_k^2 / (2 L norm(x_0 - x^*)^2) = delta_k - A delta_k^2
$

after letting $A := 1 \/ (2 L norm(x_0 - x^*)^2)$. The idea is now to reduce to a single index rather than depending on both $k$ and $k+1$.

$
 A delta_k^2 + delta_(k+1) <= delta_k
$

Dividing by $1 \/ delta_k delta_(k+1) > 0$,

$
  A delta_k / delta_(k+1) + 1 / delta_k <= 1/ delta_(k+1)
$
and then since $delta_(k+1) <= delta_k$ (by @eq:tool1),
$
  A <= 1/ delta_(k+1) - 1 / delta_k
$
and we have found our candidate for the telescoping sum. Summing over $k = 0, ..., t - 1$,
$
  t A <= sum_(k = 0)^(t-1) 1/ delta_(k+1) - 1 / delta_k = 1 / delta_t - 1 / delta_1 <= 1 / delta_t.
$
Unpacking the definition of $A$ gives (@eq:conv-in-value), and we have $f(x_k) arrow.r f(x^*)$ at the $O(1/k)$ rate.

Proving point covergence in this case is much easier. Let $r = norm(x_0 - x^*)$. We know a few things from the above work. First, the sequence $a_k := norm(x_k - x^*)$ converges to some $l in [0, r]$. In particular, we do not yet know that $l = 0$. 


Second, we know $x_k in overline(B)(x^*, r)$. Therefore $(x_k)$ is a bounded sequence in $RR^p$, has at least one convergent subsequence by the Bolzano-Weierstrass theorem. Let this subsequence be $x_phi(k) arrow.r x_s$ for $phi(k) >= k$. By the continuity of $f$, we know $f(x_phi(k)) arrow.r f(x_s)$. But the sequence
$
  (f(x_phi(k)))_k
$
is itself a subsequence of the convergent sequence $f(x_k)$. This means that $f(x_s) = f(x^*)$, so $x_s in arg min f$. Hence, we know $norm(x_k - x_s) arrow.r l in [0, r]$, since $x_s$ is a minimiser. But $x_phi(k) arrow.r x_s$, hence by _SLAP_, $x_k arrow.r x_s in arg min f$.


]




/* document bibliograph */
#bibliography("../thesis.bib")