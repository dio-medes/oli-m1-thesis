/* minimal packages required */
#import "@preview/hydra:0.6.2": hydra
#import "preamble.typ": *
#show: notes

/* maths styling */
#set math.equation(numbering: "(1)")
#let nonum(eq) = math.equation(block: true, numbering: none, eq)
#set math.equation(supplement: none)

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

// bibliograph
// #set bibliography(style: "springer-basic")

/* document metadata */

#set document(title: [
Nesterov Acceleration and Point Convergence: Context for the Recent Proof of #cite(<ryu2026>, form: "author")
])

/* document begins */

// Title block
#align(center)[
  #text(size: 18pt, weight: "bold")[#context document.title]
  #v(0.5em)
  Oliver Richard Cutbill (42501673)\
  Supervised by Professor Edouard Pauwels
  // #v(1em)
  // *Abstract* \
  // ...
  //#v(1em)
]

#outline()

= Introduction

The optimisation of smooth, convex functions by an iterative, first-order method at an $O(1\/k)$ rate is a well-known result, with origins dating back to Cauchy #cite(<cauchy1847methode>). The classical device---known as _gradient descent_---has several desirable properties, including so-called _point convergence_: that the iterates themselves converge as the number of iterations increases indefinitely. A break-through in the study of optimisation algorithms occurred when it was established that the fastest theoretical rate for a first-order algorithm was $O(1\/k^2)$. Initially it was unknown whether such an algorithm attaining this maximum rate existed.

The answer eventually came in the affirmative from Nesterov's seminal paper @nesterov83, in which it was proved that the method could be accelerated to $O(1\/k^2)$ with almost no additional computational burden. In the decades since, a large and diverse body of results on related problems has been established as optimisation has taken on renewed relevance in applications, with Artificial Intelligence being the dominant contemporary example. However, whether the point convergence property was retained under Nesterov's acceleration scheme remained an open question until very recently, when researchers were again able to answer in the affirmative @ryu2026. Perhaps fittingly, the the key innovation that provided sthe solution this longstanding open question was obtained with the assistance of a large language model.

The rest of this work traces a narrow path through the literature, with the goal of providing a tightly-focused context for recent proof (Theorem 3.5 in @ryu2026) in terms of the preceeding literature. The material starts simple, assuming a familiarity with typical analysis material but not necessary iterative schemes for optimisation. I build up to the main result slowly, including providing a short introduction to optimisation algorithms in terms that concern the work of this thesis.

== Literature selection

The literature on optimisation, even for the subset of problems considered in this thesis, is extremely large.

- begins with linear programming in WWII
- different periods over the 20th century
- today there are two main branches: optimisation and netural networks (?)
- There is a wide range of potentially relelvant literature to the question studied in this thesis. I have been deliberately conservative in the topic choice, partly due to time constraints, but also for the clarity of exposition.
  - Mention some papers quickly in passing on topics that could have been relevant, and do it in section order
    - optimisation: could have discussed interior-point method contributions by Niemirovski and Nesterov, whose work features
    - algorithms: 

== Notation and conventions

- $p in NN$ and functions are written following @boyd2004 in the sense that we have $f : RR^p arrow.r RR$ and $dom(f)$ is the domain of the function $f$, and $dom(f) subset.eq RR^p$ with strict inclusion possible. However, in this thesis functions will typically be unrestricted in their domain.
- $x = (x^((1)), x^((2)), ..., x^((p))) in RR^p$
- $norm(.)$ always refers to the Euclidean (or 2-norm) $norm(.)_2$.

=  Setting

The problem considered in this thesis is

$
  minimise_(x in RR^p) f(x),
$<basiceq>

where $f : RR^p arrow.r RR$ has certain desirable properties and an iterative procedure is used to approximate the solution. Beginning at an arbitrary initialisation $x_0$, the procedure uses whatever information is available about $f$ to form successive iterates $x_1, x_2, ...$, seeking to approach some $x_star in argmin(f)$ and corresponding minimum value $f_star = inf(f)$. This thesis builds up to a recent result concerning two properties of one such algorithm: Nesterov's Accelerated Gradient Method. The two properties in question are (1) the rate at which $f(x_k)$ approaches $f_star$, and (2) whether the iterates $seqfull({x_k}, k >= 0)$ eventually converge.

== Optimisation of convex, #Lsmooth functions

More concretely, the recent result of #cite(<ryu2026>, form: "prose") concerns the optimisation of continuous, real-valued, convex, and smooth functions by iterative algorithms that only make use of first-order information. These terms will be used heavily throughout this work, so I begin by recalling their precise definitions. #footnote[The discussion in this section is classical in the literature. For a complete reference, see #cite(<boyd2004>)#cite(<nesterov2004>)#cite(<nesterov2018lectures>).]

#definition[
  A function $f : RR^p arrow.r RR$ is *convex* if $dom(f) subset.eq RR^p$ is a convex set, and
  $
    forall x, y in dom(f), forall t in [0,1] : f lr(\( (1-t)x + t y \), size: #150%) <= (1-t)f(x) + t f(y).
  $<eq:convexfunction>
]<def:convexfunction>

Convex functions, such as linear and quadratic functions, arise naturally in applications and enjoy many important properties. One of the most important such properties is the following inequality, which holds when the convex function $f$ is also differentiable:

  $
    forall x, y in RR^p : f(y) >= f(x) + chevron.l nabla f (x), y - x chevron.r.
  $<eq:covexityinequality>

As described by @boyd2004, this inequality is critical because it allows _local_ information, represented by the value of $f$ and its gradient at a point $x$, to carry _global_ information about $f$ at any other point. It is this property of convex functions that render them amenable to mathematical optimisation, particularly by algorithms which typically only have access to local information @bubeck2015.

The next key notion is that of #Lsmoothness, which like convexity links the local and global behaviour of the function $f$. 

#definition[
  A function $f: RR^p arrow.r RR$ is smooth, or more precisely #Lsmooth with $L(f) > 0$, if the gradient $nabla f : RR^p arrow.r RR^p$ is #Llips.
  $
    forall x, y in RR^p : abs(nabla f(x) - nabla f(y), size: #150%) <= L norm(x - y).
  $
  In writing $L(f)$ is typically shorterned to $L$ where no confusion is likely.
]<def:smoothfunction>

The precise way that #Lsmoothness controls the behaviour of a function is embodied in the following lemma.

#lemma([Quadratic Upper Bound #cite(<nesterov2018lectures>, supplement: "Lemma 1.2.3")])[
  Let $f$ be differentiable and #Lsmooth. Then,
  $
    forall x, y in RR^p : lr(| f(y) - f(x) - chevron.l nabla f(x), y - x chevron.r |, size: #150%) <= L / 2 norm(y - x)^2.
  $
]<lma:qub>

In words, the linear approximation of an #Lsmooth function around some reference point is controlled by a quadratic in the distance from that point. This lemma is one of the central mechanisms behind the gradient descent algorithm introduced in @chapter:theplaingradientmethod.

The final definition required to precisely state the setting of #cite(<ryu2026>, form: "prose") is that of a _first-order_ algorithm, as this is the only class of algorithms that are considered in this thesis.

#definition([First-order algorithm #cite(<nesterov2018lectures>, supplement: "Section 1.1.2")])[
  A first-order algorithm is an interative procedure $cal(M)$ that produces a sequence $seqfull({x_k}, k >=0) subset.eq RR^p$ where
  $
    x_0 in RR^p, space x_(k+1) = cal(M)(seqfull({x_k, f(x_k), nabla f(x_k)}, k >= 0)),
  $
  for the function $cal(M) : (RR^p times RR times RR^p) arrow.r RR^p$.
]

Put simply, in a first-order algorithm the next iterate is a function only of the previous iterates along with the function values and gradients at those points. More will be said about orders of algorithms and other related objects in @chapter:complexity, which were part of a major break-through in the understanding of iterative schemes in optimisation by #cite(<nemirovsky1983>, form: "prose").

I am now in a position to formally restate the problem described in the previous section. As in (@basiceq), I consider the (unconstrained) optimisation problem

$
 minimise_(x in RR^p) f(x),
$<minfx>

where $f : RR^n arrow.r RR$, called the _objective_, is continuous, convex, and #Lsmooth. I am interested in the properties of certain first-order algorithms that solve (@minfx). The first and most natural property of interest is convergence _in value_, meaning that the sequence $seqfull({x_k},k>=0)$ produced by an algorithm satisfies

$
  f(x_k) arrow.long.r_(k arrow.r infinity) f_star = min_(x in RR^p) f(x).
$<def:convergenceinvalue>

It is assumed throughout this thesis that there exists at least one $x_star in argmin(f)$. In general, we prefer _fast_ algorithms, meaning that $f(x_k) - f_star$ is smaller than some threshold for minimal $k$ (or minimal cost). It turns out that the algorithm described in @chapter:nesterov is---in a particular sense---the _fastest possible_ first-order algorithm for this problem.

The second property of interest in this thesis is convergence _in iterates_, or _point convergence_, meaning that

$
  x_k arrow.long.r_(k arrow.r infinity) x_infinity in argmin_(x in RR^p) f(x).
$<def:pointconvergence>

On the face of it, one might expect that (@def:pointconvergence) should follow easily from (@def:convergenceinvalue), but this is not at all the case. For example, the iterates may occisilate between two distinct minimisers while $f(x_k)$ approaches the minimum value $f_star$. The implication does follow under the very restrictive assumption that $argmin(f)$ is a singleton (e.g. when $f$ is _strongly_ convex), as shown in the following simple lemma.

#lemma[
  Let $f$ be as above and assume that $x_star = argmin(f)$. Let $seqfull({x_k}, k>=0) subset.eq RR^p$. If $f(x_k) arrow.r f(x_star)$ as $k arrow.r infinity$, then $x_k arrow.r x_star$.
]<lemma:singletonargmin>

#proof[
  First, I claim that $seqfull({x_k}, k>=0)$ is bounded. Towards a contradiction, $seqfull({x_k}, x>=0)$ is unbounded. Then $norm(x_k - x_star) arrow.r infinity$. Now define $u_k := (x_k - x_star) \/ norm(x_k - x_star)$. Then $seqfull({u_k}, k>=0)$ is contained in the closed unit ball, hence compact, and by the Bolzano-Weierstrass Theorem, $u_k arrow.r u_infinity$ with $norm(u_infinity) = 1$ along a subsequence. Fix $t>0$ and define another sequence $lambda_k := t \/ norm(x_k - x_star)$, with $lambda_k arrow.r 0$. Then, using (@eq:convexfunction),

  $
    f(x_star + t u _k) &= f lr(((1 - lambda_k) x_star + lambda_k x_k), size: #150%) \
    & <= (1 - lambda_k) f(x_star) + lambda_k f(x_k) \
    & = f_star + lambda_k (f(x_k) - f_star)
  $<eq:introlemma>

  As $k arrow.r infinity$, $u_k arrow.r u_infinity$, $lambda_k arrow.r 0$, and $f(x_k) - f_star arrow.r 0$ by assumption. From (@eq:introlemma), this gives $f(x_star + t u_infinity) <= f_star$, giving a contradiction $arrow.zigzag$. Since $seqfull({x_k}, k>=0)$ is bounded, it has at least one accumulation point $overline(x)$. Since $f$ is continuous, $f(overline(x)) = f_star$, and therefore $overline(x) = x_star$.

]

In general, we do not restrict to situations covered by @lemma:singletonargmin, and therefore point convergence requires separate proof.



== The need for an iterative scheme

- Before moving on to describe algorithms and  the main result, it is worth taking a step back to ask why there is a need to study interative schemes for solving optimisation problems at all.
- say the standard necessary and sufficient optimality conditions.


#lemma([$C^1$ convex functions and minima])[
  
  fermat rule: $nabla f(x) = 0$ is a necessarily condition for optimality

  $f$ convex $arrow.double.r$ local minima are global minima, and $nabla f (x) = 0$ is necessary and sufficient
]
- why can we not always use traditional analytical methods to solve optimisation problems?
  - Even if the function in question is differentiable, the system of equations $nabla f(x) = 0$ may be very difficult or even impossible to solve.

- Give examples that cannot be solved
  - Logistic regression - I believe this is a convex function
  - Look for example in Boyd
  - Non-smooth regularisation and point to the later FISTA section

= The plain gradient method<chapter:theplaingradientmethod>

- With a gradient method we have just a function value and the gradient available

== A gradient step

#corollary[
  If $f$ is convex, #Lsmooth, and differentiable, then
  $
    0 <= f(y) - f(x) - chevron.l nabla f(x), y - x chevron.r why("convexity")
  $
  and therefore from @lma:qub,
  $
    0 <= f(y) - f(x) - chevron.l nabla f(x), y - x chevron.r <= L / 2 norm(y - x)^2
  $<eq:quadraticub>
]<cor:convexLsmooth>

- State the result that the negative gradient direction is the minimiser of a certain optimisation problem

== Convergence



#theorem("Convergence of gradient descent")[

]

= Complexity in convex optimisation<chapter:complexity>

@boyd2004: _a solution method for a class of optimization problems is an algorithm that com-
putes a solution of the problem (to some given accuracy), given a particular problem
from the class, i.e., an instance of the problem._

= Nesterov Acceleration <chapter:nesterov>

== The method

== The momentum sequences and their regimes

== Point convergence

== The optimal gradient method

= A non-smooth generalisation

= The continuous time perspective

= Conclusion and open questions

/* document bibliograph */
#bibliography("thesis.bib")