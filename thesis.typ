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

The problem considered in this thesis is

$
  minimise_(x in RR^p) f(x),
$<basiceq>

where $f : RR^p arrow.r RR$ has certain desirable properties and an iterative procedure is used to approximate the solution. Beginning at an arbitrary initialisation $x_0$, the procedure uses whatever information is available about $f$ to form successive iterates $x_1, x_2, ...$, seeking to approach some $x_star in argmin(f)$ and corresponding minimum value $f_star = inf(f)$.

The optimisation of convex and smooth functions by an iterative procedure with origins commonly attributed to Cauchy #cite(<cauchy1847methode>). The classical device---known as _gradient descent_---is known to converge in the sense that $f(x_k) - f_star <= cal(O)(1\/k)$, and has several desirable properties, including so-called _point convergence_: that the iterates themselves converge as the number of iterations increases indefinitely. A break-through in the study of optimisation algorithms occurred when it was established that the fastest theoretical rate for a first-order algorithm was $cal(O)(1\/k^2)$. Initially it was unknown whether such an algorithm attaining this maximum rate existed.

The answer eventually came in the affirmative from #cite(<nesterov83>, form: "author")'s seminal paper @nesterov83, in which his _accelerated_ gradient method was originally proposed. With almost no additional computational burden, it was proven to be possible to accelerate gradient descent to $O(1\/k^2)$ . In the decades since, a large and diverse body of results on related problems has been established as optimisation has taken on renewed relevance in applications, with Artificial Intelligence being the dominant contemporary example. However, whether the point convergence property was retained under Nesterov's acceleration scheme remained an open question until very recently, when researchers were again able to answer in the affirmative @ryu2026. Perhaps fittingly, the the key innovation that provided sthe solution this longstanding open question was obtained with the assistance of a large language model.

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
- $norm(.)$ always refers to the Euclidean (or 2-norm) $norm(.)_2$. For two vectors in $RR^p$, $chevron.l x, y chevron.r$ denotes the Euclidean innner product.
- $overline(B)(x, r)$ is the closed ball
- big-$cal(O)$ notation

=  Setting

== Convex and #Lsmooth functions

Put more concretely, the recent result of #cite(<ryu2026>, form: "prose") concerns the optimisation of continuous, real-valued, convex, and smooth functions by iterative algorithms that only make use of first-order information. These terms will be used heavily throughout this work, so I begin by recalling their precise definitions. #footnote[The discussion in this section is classical in the literature. For a complete reference, see #cite(<boyd2004>)#cite(<nesterov2004>)#cite(<nesterov2018lectures>).]

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

Of course, this definition necessitates that an #Lsmooth function is differentiable at least once. The precise way that #Lsmoothness controls the behaviour of a function is embodied in the following lemma.

#lemma([Quadratic Upper Bound #cite(<nesterov2018lectures>, supplement: "Lemma 1.2.3")])[
  Let $f$ be differentiable and #Lsmooth. Then,
  $
    forall x, y in RR^p : lr(| f(y) - f(x) - chevron.l nabla f(x), y - x chevron.r |, size: #150%) <= L / 2 norm(y - x)^2.
  $
]<lma:qub>

In words, the linear approximation of an #Lsmooth function around some reference point is controlled by a quadratic in the distance from that point. This lemma is one of the central mechanisms behind the gradient descent algorithm introduced in @chapter:theplaingradientmethod. Throughout the rest of the thesis, $f$ is taken to be continuous, convex, and #Lsmooth unless otherwise stated.

== Problem of interest

Since I will be concerned with the performance of algorithms, it is worth fixing some notation and concepts with which to discuss it. A fully general treatment is not needed for what follows, so I adopt a simplified version of the setup described in #cite(<nesterov2018lectures>, supplement: "Section 1.1.2").

An optimisation problem $P$ is taken to belong to a class $scr(P)$, which fixes the form of the problem through conditions on its objective function $f$ --- for instance, that $f$ be convex and #Lsmooth. We solve $P$ not in closed form but by an iterative procedure $mu$, drawn from a class of algorithms $cal(M)$ that share a common feature. In summary:

- $scr(P)$: a class of problems, specified by conditions on the objective. In this thesis $scr(P)$ will denote the minimisation of convex, #Lsmooth functions;
- $P in scr(P)$: a particular problem, with objective $f$;
- $cal(M)$: a class of algorithms;
- $mu in cal(M)$: an iterative procedure for solving $P$.

The distinction between classes of algorithms in this thesis will be drawn according to the information to which $mu in cal(M)$ has access to solve $P$. This thesis will consider only the class of 'first-order' algorithms. Put simply, in a first-order algorithm the next iterate is a function only of the previous iterates along with the function values and gradients at those points.

#definition([First-order algorithm #cite(<nesterov2018lectures>, supplement: "Section 1.1.2")])[
  A first-order algorithm $mu in cal(M)_1$ is an interative procedure  that produces a sequence $seqfull({x_k}, k >=0) subset.eq RR^p$ using only the information contained in
  $
    seqfull({x_k, f(x_k), nabla f(x_k)}, k >= 0).
  $
  By $cal(M)_1$ we denote the class of first-order algorithms.
]

With the preceeding definitions, I am now in a position to formally restate the problem described in the previous section. As in (@basiceq), I consider the (unconstrained) optimisation problem

$
 minimise_(x in RR^p) f(x),
$<minfx>

where $f : RR^n arrow.r RR$, called the _objective_, is continuous, convex, and #Lsmooth. I am interested in the certain properties of first-order algorithms to solve (@minfx). The first and most natural, minmal property of an algorithm is convergence _in value_, meaning that the sequence $seqfull({x_k},k>=0)$ produced by $mu$ satisfies

$
  f(x_k) arrow.long.r_(k arrow.r infinity) f_star = min_(x in RR^p) f(x).
$<def:convergenceinvalue>

It is assumed throughout this thesis that there exists at least one $x_star in argmin(f)$. Theoretically, the algorithms of interest are those with the best _worst-case_ guarantee, meaning that $f(x_k) - f_star$ is smaller than some threshold for a given $k$ _whatever the problem_ $P in scr(P)$. It turns out that the algorithm described in @chapter:nesterov is in this sense the _fastest possible_ first-order algorithm: it has the best _worst-case_ guarantee of convergence in $scr(P)$.

The second property of interest in this thesis is convergence _in iterates_, or _point convergence_, meaning that

$
  x_k arrow.long.r_(k arrow.r infinity) x_infinity in argmin_(x in RR^p) f(x).
$<def:pointconvergence>

Point convergence is an important property to establish for an optimisation algorithm, for reasons both mathematical and practical. Mathematically, it is the natural question to ask once convergence in value (@def:convergenceinvalue) has been established, and an answer reflects a deep understanding of the geometry of the sequence the algorithm produces. The property also matters because the minimiser itself often carries significant meaning. In @beckteboulle2009, for instance, it represents a deblurred image, and a failure of point convergence would mean the iterates never settle: the recovered image could differ vastly depending on when the algorithm is stopped. Distinct minimisers can correspond to entirely different reconstructions even at identical objective value, complicating practical use of the procedure.

On the face of it, one might expect that (@def:pointconvergence) should follow easily from (@def:convergenceinvalue), but this is not at all the case. For example, the iterates may occisilate between two minimisers while $f(x_k)$ approaches the minimum value $f_star$. However, the implication does follow under the very restrictive assumption that $argmin(f)$ is a singleton (e.g. when $f$ is _strongly_ convex), as shown in the following simple lemma.

#lemma[
  Let $f$ be as above and assume that $x_star = argmin(f)$. Let $seqfull({x_k}, k>=0) subset.eq RR^p$. If $f(x_k) arrow.r f(x_star)$ as $k arrow.r infinity$, then $x_k arrow.r x_star$.
]<lemma:singletonargmin>

#proof[
  First, I claim that $seqfull({x_k}, k>=0)$ is bounded. Towards a contradiction, suppose that $seqfull({x_k}, x>=0)$ is unbounded. Then $norm(x_k - x_star) arrow.r infinity$. Now define $u_k := (x_k - x_star) \/ norm(x_k - x_star)$, so $seqfull({u_k}, k>=0)$ is contained in the closed unit ball, hence compact, and by the Bolzano-Weierstrass Theorem, $u_k arrow.r u_infinity$ with $norm(u_infinity) = 1$ along a subsequence. Fix $t>0$ and define another sequence $lambda_k := t \/ norm(x_k - x_star)$, with $lambda_k arrow.r 0$. Then, using (@eq:convexfunction),

  $
    f(x_star + t u _k) &= f lr(((1 - lambda_k) x_star + lambda_k x_k), size: #150%) \
    & <= (1 - lambda_k) f(x_star) + lambda_k f(x_k) \
    & = f_star + lambda_k (f(x_k) - f_star)
  $<eq:introlemma>

  As $k arrow.r infinity$, $u_k arrow.r u_infinity$, $lambda_k arrow.r 0$, and $f(x_k) - f_star arrow.r 0$ by assumption. From (@eq:introlemma), this gives $f(x_star + t u_infinity) <= f_star$, giving a contradiction $arrow.zigzag$. Since $seqfull({x_k}, k>=0)$ is bounded, it has at least one accumulation point $overline(x)$. Since $f$ is continuous, $f(overline(x)) = f_star$, and therefore $overline(x) = x_star$.

]

In general we do not restrict to situations covered by @lemma:singletonargmin, and therefore point convergence requires a  separate proof---often by a completely separate strategy---to convergence in value. The fundamental contribution of #cite(<ryu2026>, form: "prose") is such a proof for Nesterov's accelerated gradient method, the first-order algorithm that has the best possible rate guarantee for convergence in value in $scr(P)$.

== The need for an iterative scheme

Before moving on to describe Nesterov's method and our main result, it is worth pausing for a moment to recall why we have a need for iterative algorithms to solve (@minfx). When a convex function $f$ is diffentiable, we have the classical nessecary and sufficient optimality condition $nabla f(x) = 0$ #cite(<boyd2004>, supplement: "Equation 4.22"). In this case, solving (@minfx) amounts to solving this system of $p$ equations. In many problems, even simple and smooth problems, this system is too difficult or even impossible to solve #cite(<boyd2004>, supplement: "Section 1.1.2"). 

Even when the model is theoretically solvable, the size of the problem can make a solution prohibitively expensive to compute or the ill-conditioned nature of problem can make solutions meaningless in practice #cite(<beckteboulle2009>, supplement: "Section 1.1"). This neccessitates _approximate_ solutions through numerical methods, which can be costly to operate. Hence, we look for efficient, fast algorithms with attractive properties that can provide solutions with sufficient accurary under constraints on the resources that they are allowed to consume.

= Gradient Descent <chapter:theplaingradientmethod>

In this section I recall a selection of fundamental facts about the _gradient descent_ method, with the aim of having a clear base from which to describe Nesterov's accelerated method. The first result to recall is that, starting from an arbitrary point $x in RR^p$ that is not a minimiser of $f$, the negative gradient direction $- nabla f(x)$ is the solution to the optimisation problem

$
  argmin_(d in RR^p) {f^prime (x; d) + 1/2 norm(d)^2},
$<eq:gradientproblem>

where $f^prime (x;d)$ is the directional derivative in the direction $d$. This makes a small _step_ in the direction $- nabla f (x)$ a natural choice for the next iterate. By the Taylor-Lagrange theorem we can then write

$
  forall x, y in RR^p : f(y) = f(x) + chevron.l nabla f (x), y - x chevron.r + o (norm(y - x)). \
$

The problem (@eq:gradientproblem) suggests that, starting from $x$, the best course of action to move closer to $f_star$ is to take a small step of size $alpha > 0$ in the $- nabla f (x)$ direction. This gives

$
  f(x - alpha nabla f(x)) = f(x) - alpha norm(nabla f(x))^2 + o(alpha).
$<eq:alphasmallenough>

Hence for $alpha > 0$ small enough, $f(x - alpha nabla f(x)) < f(x)$, achieving a decrease in the objective.

#definition("Gradient Descent")[
  Consider a problem of class $scr(P)$ with $f: RR^p arrow.r RR$. The gradient descent method is the first-order algorithm which defined by
  $
    &x_0 in RR^p text("(arbitrary)") \
    & x_(k+1) = x_k - alpha_k nabla f (x) quad text("for") k >= 0
  $<eq:gd>
  where $seqfull({alpha_k}, k >= 0)$ is a suitable non-negative sequence called the 'learning rate'.
]<def:gd>

The deep connection to (@eq:gradientproblem) is evident when it is observed that (@eq:gd) is the solution to the following convex optimisation problem

$
  x_(k+1) = argmin_(x in RR^p) {f(x_(k)) + chevron.l x - x_k, nabla f (x_k) chevron.r + 1 / (2 alpha_k) norm(x - x_k)^2}.
$

The protocol by which a suitable step size $alpha_k$ is determined clearly plays a large role in determining the behaviour of the method. However, it is clear that so long as the learning rate it chosen such that $f(x_(k+1)) = f(x_k - a_k nabla f(x_k)) <= f(x_k)$, eventually the sequence $seqfull({f(x_k)}, k>=0)$ decreases to $f_star$.

In both theory and practice, there are many possible choices for the sequence $seqfull({alpha_k}, k>=0)$, including:

- Fixed step sizes (see below): $alpha_k = alpha > 0$ with choice dependent on $P$;
- Line search (e.g. @nesterov83): $alpha_k = argmin_(alpha >= 0) f(x_k - alpha nabla f (x_k))$;
- Decreasing step sizes (e.g. @ryu2026@beckteboulle2009): $alpha_k >= 0$ and $alpha_k arrow.r 0$.

For problems in $scr(P)$ we have the following result that will be helpful to guide the choice of step size.

#lemma[
  If $f$ is convex and #Lsmooth, then
  $
    0 <= f(y) - f(x) - chevron.l nabla f(x), y - x chevron.r <= L / 2 norm(y - x)^2.
  $<eq:quadraticub>
]<cor:convexLsmooth>

#proof[The first inequality is convexity (@eq:covexityinequality) and the second inequality is @lma:qub.
]

The power of @cor:convexLsmooth becomes clear when we apply the same logic as in (@eq:alphasmallenough). Taking again $y = x - alpha nabla f (x)$ with the fixed step size $alpha <= 1 \/ L$ gives

$
  f(x - 1 / L nabla f(x)) - f(x) <=- 1/(2L) norm(nabla f(x))^2.
$<eq:gradientstepsmoothguarantee>

That is, for problems in $scr(P)$ a 'gradient step' of size at most $1\/L$ _guarantees_ a decrease in the objective that is propotional to $norm(nabla f (x))^2$. I am now in a position to state the classical convergence results on the gradient descent method for a fixed step size.

#theorem[Consider an optimisation problem $P in scr(P)$. The gradient descent method with a constant learning rate $alpha_k = 1 \/ L$ satisfies

  _convergence in value:_
  $
    f(x_k) - f(x_star) <= (L norm(x_0 - x^*)^2) / (2k) = cal(O)(1\/k)
  $<eq:conv-in-value>
  _point convergence:_
  $
    x_k arrow.r x_infinity in arg min (f) text("as") k arrow.r infinity
  $<eq:conv-in-interates>
]<thm:gd>

I reproduce a short proof that explicitly shows the use of a _potential function_ based on a recent effort to collect a unified approach to proofs of gradient methods #cite(<gupta2019>). The potential function perspective is useful for my purposes because the same device turns out to be critical for the main result of #cite(<ryu2026>, form: "author"). See @nesterov2004@bubeck2015 for more classical expositions, upon which I also draw for the proof of point convergence.

The main idea in @gupta2019 is to define a _potential_ function of the form

$
  cal(E)_k = A_k lr(( f(x_k) - f(x_star)), size: #150%) + B_k norm(x_k - x_star)^2,
$

with $A_k, B_k >=0$ and show $cal(E)_(k+1) - cal(E)_k <= C_k$ for some real sequence $seqfull({b_k}, k>=0)$. Then, using a telescoping sum from $k = 0, ..., K$ and the fact that both terms of $cal(E)_k$ are non-negative gives

$
  sum_(k=0)^K cal(E)_(k+1) - cal(E)_k <= sum_(k=0)^K C_k arrow.double.r f(x_K) - f(X_star) <= (cal(E)_0 + sum_(k = 0)^K C_k) / A_K
$<eq:potentialbound>

which for the right choice of $A_k$ and $B_k$ will complete the proof. This is a very general proof strategy, but in general finding the right $A_k$ and $B_k$ is difficult. In this thesis I will present these potential functions in an unmotivated way, but I point the reader towards the literature on methods to search in general for Lyapunov functions, for example see #cite(<boyd1994>, form: "prose").

The proof will also require the following simple lemma.

#lemma[The gradient descent step $x_(k+1) = x_k - alpha nabla f (x_k)$ satisfies
$
  1/2 lr((norm(x_(k+1) - x_star)^2 - norm(x_k - x_star)^2), size: #150%) = alpha chevron.l nabla f(x_k), x_star - x_k chevron.r + alpha^2 / 2 norm(nabla f(x_k))^2.
$<eq:pythagorasproperty>
]<lm:pythagorasproperty>

#proof[The result follows from $norm(a + b)^2 - norm(a)^2 = 2 chevron.l a, b chevron.r + norm(b)^2$ with $a := x_k - x_star$ and $b := x_(k+1) - x_k$.
]

#proof([(@thm:gd)])[
  
_(convergence in value)_

Fix a point $x_star in argmin(f)$ and define the _potential_ function

$
cal(E)_k = k lr((f (x_k) - f(x_star)), size: #150%) + L / 2 norm(x_k - x_star)^2.
$<eq:gdpotential>

We claim that $cal(E)_k$ is weakly decreasing in $k$. To see this, consider the _potential difference_

$
  cal(E)_(k+1) - cal(E)_k = (k + 1) &lr( ( f(x_(k+1)) - f(x_k) ), size:  #150%) + lr((f(x_k) - f(x_star)), size: #150%) \
  & + L / 2 lr((norm(x_(k+1) - x_star)^2 - norm(x_k - x_star)^2), size: #150%).
$

Next we use (@eq:gradientstepsmoothguarantee), (@eq:convexfunction), (@eq:pythagorasproperty) on each of the terms respectively to find an upper bound

$
  cal(E)_(k+1) - cal(E)_k <= &(k + 1) (- 1 / (2L) norm(nabla f(x))^2) \
  &+ space chevron.l nabla f(x_), x_k - x_star chevron.r \
  &+ space L/2 ( 2 / L chevron.l nabla f(x_k), x_star - x_k chevron.r + 1 / (2L^2) norm(nabla f(x_k))^2).
$

After a cancellation of terms this can be written as

$
  cal(E)_(k+1) - cal(E)_k <= - (1/(2L)) norm(nabla f(x_k))^2 <= 0.
$

So it suffices to take $C_k = 0$ for $k >= 0$. Using the fact that $cal(E)_0 = L \/ 2 norm(x_0 - x_star)^2)$ in (@eq:potentialbound) gives the result.


_(point convergence)_

We claim that $norm(x_k - x_star)$ is decreasing. By interchanging the role of $x$ and $y$ and summing, from (@eq:quadraticub) we can conclude

$
  1 / L norm(nabla f(x) - nabla f (y))^2 <= chevron.l nabla f(x) - nabla f(y), x - y chevron.r
$<eq:twice-eval-and-add>

for all $x, y in RR^p$. We know $nabla f(x_star) = 0$ for any $x_star in argmin(f)$, hence

$
  norm(nabla f(x_k))^2 <= chevron.l nabla f (x_k), x_k - x_star chevron.r.
$

From this we can conclude $norm(x_k - x_star)$ is weakly decreasing, since

$
  norm(x_(k+1) - x_star)^2 &= norm(x_k - x_star)^2 + 1/L^2 norm(nabla(f(x_k)))^2 - 2 / L chevron.l x_k - x_star, nabla f(x_k) chevron.r \
  &<= norm(x_k - x_star)^2 - 1 / L norm(nabla f(x_k))^2 <= norm(x_k - x_star)^2.
$

What remains is a standard Fejér monotonicity argument (e.g. see @fejermonotonicity). Let $r := norm(x_0 - x_star)$. The sequence $a_k = norm(x_k - x_star)$ is non-negative, so it converges to some $l in [0, r]$; it is not yet clear that $l = 0$. In particular, $x_k in overline(B)(x_star, r)$ for all $k$, so $(x_k)$ is a bounded sequence in $RR^p$ and, by the Bolzano--Weierstrass theorem, has at least one convergent subsequence. Denote it by $x_phi(k) arrow.r x_infinity$, with $phi(k) >= k$.

By the continuity of $f$, we have $f(x_phi(k)) arrow.r f(x_infinity)$. But $seqfull({f(x_phi(k))}, k>=0)_k$ is a subsequence of the convergent sequence $seqfull({f(x_k)}, k>=0)$, and so $f(x_infinity) = f(x_star)$; that is, $x_infinity in arg min f$. Since $x_infinity$ is itself a minimiser, the same argument applied to $x_s$ in place of $x_star$ shows that $norm(x_k - x_infinity)$ converges. Passing to the subsequence $x_phi(k) arrow.r x_infinity$ forces this limit to be $0$, hence $x_k arrow.r x_infinity in arg min f$.
]

= Nesterov Acceleration <chapter:nesterov>

== The method

In #cite(<nesterov83>, form: "year"), Nesterov introduced a new method for solving problems of class $scr(P)$ with a convergence in value guarantee of $cal(O)(1\/k^2)$. The following algorithm is the method in its original form from @nesterov83.

#definition([Nesterov's Method - Original])[
  Consider a problem of class $scr(P)$. Nesterov's original method is the iterative procedure:

  _Initilisation:_
  
  Set $k = 0$, $t_0 = 1$, $alpha_0 = norm(x_0 - z) \/ norm(nabla f(y_0) - nabla f(z))$, and $x_0 = y_0 in RR^p$.

  _Iteration step:_
  $
    n_k = 
  $
  $
    x_(k+1) &= y_k - alpha_k nabla f(y_k)\
    y_(k+1) &= x_k + (t_k - 1)/t_k (x_(k+1) - x_k)
  $
]<def:nesterovmethodoriginal>

- we can see that nesterov now uses two sequences
- Note that nesterov used backtracking line search in the first iteration step.

Given @cor:convexLsmooth, the backtracking is typically avoided for simplicity and instead we just take the fixed step size $1\/L$. With this simplification, the method is typically written in the equivalent form

#definition([Nesterov's Method - Modern])[
  Consider a problem of class $scr(P)$. Nesterov's accelerated method with a fixed step size in the main se
]<def:nesterovmodern>

#lemma([#cite(<nesterov2005smooth>, supplement: "Lemma 1")#cite(<ryu2026>, supplement: "Lemma 3.1")])[
  Consider a problem of class $scr(P)$. The following method produces the same sequences $seqfull({x_k}, k>=0), seqfull({y_k}, k>=0)$ as the iterative procedure defined in @def:nesterovmodern.

  _Initilisation:_
]

== Complexity

- niemirovskii theorem about a lower bound

== The new result

- theorem of ryu 2026

- present the proof in summarised form

== The optimal gradient method

- PEP

= A non-smooth generalisation

- In the past decade before this new proof some progress on adjacent questions was made. The setting considered by FISTA builds on the ideas of Nesterov and generalises the method to a non-smooth setting.

- FISTA problem

- Definition of FISTA method and note the convergence of FISTA from Beck and Teboulle

- However, in 2015 we already had a theorem - point convergence of a slightly modified version of FISTA, but not the original FISTA itself (for otherwise there would be no need of ryu's paper since a proof of point convergence for FISTA is a proof of nesterov for convex, smooth functions).

= Conclusion and open questions

- Mention the continuous time perspective

There are several other perspectives on these proofs that the reader may find useful. One useful
perspective is that of viewing these methods as discretizations of suitable continuous dynamics; this
appears even in the classic work of Nemirovski and Yudin [18], and has been widely used recently (see,
e. g., [24, 29, 17, 30]).

- Finding the right lyapunov function

- Mention implicit bias in machine learning

/* document bibliograph */
#bibliography("thesis.bib")