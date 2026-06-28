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

#set document(title: [Context for the Recent Proof of the Point Convergence of Nesterov's Accelerated Gradient Method#footnote("I am very grateful to Professor Edouard Pauwels for his guidance during this project, and all errors and omssissions in this work are of course my own.")
])

/* document begins */

// Title block
#align(center)[
  #text(size: 18pt, weight: "bold")[#context document.title]
  #v(0.5em)
  Oliver Richard Cutbill (42501673)\
  Supervised by Professor Edouard Pauwels
  #v(1em)
  *Abstract* \
  #[
    #set par(justify: true)
Since at least the time of Cauchy, gradient descent has been the foundational iterative method for solving optimisation problems. In his seminal #cite(<nesterov83>, form: "year") paper, #cite(<nesterov83>, form: "author") introduced a scheme for smooth convex functions whose values converge to the optimum at an accelerated rate. Whether the iterates themselves converge---a property known as point convergence---remained open until #cite(<ryu2026>, form: "author") recently settled it in the affirmative. This thesis traces a narrow path through the literature to give focused context for that result.
  ]
  #v(1em)
]


#outline()
#pagebreak()

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

Moreover, there are cases when the model is theoretically solvable, but the size or other characteristics of the problem can make a solution prohibitively expensive to compute or meaningless in practice #cite(<beckteboulle2009>, supplement: "Section 1.1"). This neccessitates _approximate_ solutions through iterative methods, which can be costly to operate. Hence, we look for efficient, fast algorithms with attractive properties that can provide solutions with sufficient accurary under constraints on the resources that they are allowed to consume.

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

I reproduce a short proof that explicitly shows the use of a _potential function_ based on a recent effort to collect a unified approach to proofs of gradient methods #cite(<gupta2019>). The potential function perspective is useful for my purposes because the same device turns out to be critical for the main result of #cite(<ryu2026>, form: "author"). See @nesterov2018lectures@bubeck2015 for more classical expositions, upon which I also draw for the proof of point convergence.

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

We claim that $norm(x_k - x_star)$ is decreasing. By interchanging the role of $x$ and $y$ in (@eq:quadraticub) and summing the resulting two equations, from  we can conclude

$
  1 / L norm(nabla f(x) - nabla f (y))^2 <= chevron.l nabla f(x) - nabla f(y), x - y chevron.r,
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

In #cite(<nesterov83>, form: "year"), Nesterov introduced a new method for solving problems of class $scr(P)$ with a convergence in value guarantee of $cal(O)(1\/k^2)$. The following algorithm is the method in its original form.

#definition([Nesterov's Method - Original @nesterov83])[
  Let $f: RR^p arrow.r RR$ be convex and #Lsmooth for unknown coefficient $L > 0$$$. Nesterov's original method is the iterative procedure:

  _Initialisation:_

Set $k = 0$, $t_0 = 1$, $alpha_0 = norm(y_0 - z) \/ norm(nabla f(y_0) - nabla f(z))$
for some $z != y_0$ with $nabla f(z) != nabla f(y_0)$, and $x_0 = y_0 in RR^p$.

_Iteration step:_
$
  n_(k+1) &= min {n in NN : f(y_k) - f(y_k - 2^(-n) alpha_k nabla f(y_k)) >= 2^(-n-1) alpha_k norm(nabla f(y_k))^2} \
  alpha_(k+1) &= 2^(-n_(k+1)) alpha_k \
  t_(k+1) &= 1/2 (1 + sqrt(1 + 4 t_k^2)) \
  x_(k+1) &= y_k - alpha_(k+1) nabla f(y_k) \
  y_(k+1) &= x_(k+1) + (t_k - 1)/t_(k+1) (x_(k+1) - x_k)
$<eq:nesterovmethodoriginal>
]<def:nesterovmethodoriginal>

Compared with @def:gd, (@eq:nesterovmethodoriginal) method introduces several new calculations into the iteration step, though it remains a first-order algorithm, since it uses only gradient information. The first thing to note is that there are now two sequences: $seqfull({x_k}, k >= 0)$, obtained from a gradient step with a backtracking rule for the step size, and $seqfull({y_k}, k >= 0)$, which perturbs the search point according to a further sequence $seqfull({t_k}, k >= 0)$. Both will be shown to approach $x_star in arg min f$.

The step-size sequence $seqfull({alpha_k}, k >= 0)$ is initialised at $norm(y_0 - z) \/ norm(nabla f(y_0) - nabla f(z))$, which by the #Lsmoothness of $f$ is guaranteed to be at least $1 \/ L$. This step is here to ensure that the step sizes satisfy @cor:convexLsmooth when the function $f$ is #Lsmooth but the smoothness coefficient itself $L$ is not known. The procedure therefore begins with a step that is plausibly too large and relies on halving by a power of $n_k$ to shrink it to the largest admissible value, rather than starting small and never attempting aggressive steps.

For problems in $scr(P)$, we assume that the smoothness coefficient $L$ is known. Hence, given @cor:convexLsmooth the backtracking step in (@eq:nesterovmethodoriginal) can be avoided, substituting instead the largest admissable step size $1\/L$. With this simplification, the method is typically written in the equivalent form below.

#definition([Nesterov's Method - General])[
  Consider a problem of class $scr(P)$. Nesterov's accelerated method is equivalent to

  _Initialisation:_

  $x_0 = y_0 in RR^p$ and $seqfull({t_k}, k>=0)$ satisfying $t_0 = 1$ and $t_(k+1)^2 - t_(k+1) <= t_k^2$.

  _Iteration step:_
  $
    x_(k+1) &= y_k - 1/L nabla f(x_k) \
    y_(k+1) &= x_(k+1) + (t_k - 1)/t_(k+1) (x_(k+1) - x_k)
  $
]<def:nesterovmodern>

#lemma([#cite(<nesterov2005smooth>, supplement: "Lemma 1")#cite(<ryu2026>, supplement: "Lemma 3.1")])[
  Consider a problem of class $scr(P)$. The following method produces the same sequences $seqfull({x_k}, k>=0), seqfull({y_k}, k>=0)$ as the iterative procedure defined in @def:nesterovmodern.

  _Initilisation:_

  _Iteration step:_
]<lem:reformulation>

This lemma provides some intuition for how NAG works. Due to the factor of $t_k$, at each iteration $z_k$ steps farther than a normal gradient step, accelerating the early progress but potentially overshooting. At the same time, the 'normal' iteration $y_k$ is a weighted average of $x_k$ and $z_k$ that places an increasing weight on $x_k$ with each iteration, and all the weight in the limit. Somehow it turns out that these two processes---${z_k}$ taking larger and larger steps but having less and less influence on ${y_k}$---balance each other perfectly to accelerate the convergence to $O(1\/k^2)$.

As of yet I have not addressed the most mysterious part of the definition of Nesterov's method, the sequence $seqfull({t_k}, k>=0)$. Indeed, Nesterov's original paper is well-known for its algebriac elegance but it did not provide any motivation for the motivation of $seqfull({t_k}, k>=0)$. Its definition appears to have been reversed eningeered from the following result from the original paper, reproduced here in the form from @ryu2026.

#lemma([#cite(<nesterov83>, supplement: "Proof of Theorem 1")#cite(<ryu2026>, supplement: "Lemma 3.2")])[
  For $x_star in argmin(f)$ and $k = 0, 1, ...$, define the Nesterov _potential_ function as
  $
    cal(E)_k (x_star) = t_(k-1)^2 lr((f(x_k) - f(x_star)), size: #150%) + L/2 norm(z_k - x_star)^2.
  $<eq:nesterovpotentialfunction>
  If $t_(k+1)^2 - t_(k+1) <= t_k^2$ for all $k = 0, 1, ...$, then
  $
    cal(E)_(k+1) <= cal(E)_k.
  $
  Furthermore, since $cal(E)_k >=0$ for all $k >= 0$, $cal(E)_k arrow.r cal(E)_infinity in RR$.$$
]<lem:nesterovpotential>

In the decades since #cite(<nesterov83>, form: "author")'s paper, a literature has grown around trying to identify the core of how the method achieved acceleration (e.g., @zhuallenorecchia2017@ahn2022@su2016differential). The aim of this liteature is to find insights that could improve acceleration of existing algorithms on other classes of problem. For example @zhuallenorecchia2017, who find that the sequence $seqfull({t_k}, k >=0)$ can be seen to arise naturally as an optimal combination of gradient descent and mirror descent.

Clearly, the equation (@eq:nesterovpotentialfunction) is highly suggestive of the potential function (@eq:gdpotential) that played a central role in the proof of gradient descent. The natural question that arises is whether we could keep tinkering with these potential functions to find better and better algorithms. The answer, however, is no, which is the topic of the next section. It does however allow the proof of the following theorem.

#theorem([Convergence in value of Nesterov's Method, #cite(<nesterov83>))])[
  Consider an optimisation problem of class $scr(P)$. The iterative procedure defined in @def:nesterovmodern satisfies, for $k = 0, 1, ...$,
  $
    f(x_k) - f_star <= (2 L norm(x_0 - x_star)^2) / (k+1)^2 = cal(O)(1\/k^2)
  $<eq:nesterovconvergence>
]<thm:nesterov>

#proof[See #cite(<gupta2019>, supplement: "Theorem 5.1") for a proof that completely mirrors that of @thm:gd ]

== Complexity and lowerbounds

The results of convergence in value seen mentioned so far in this these are both of the form $f(x_k) - f_star <= cal(O)(b_k)$ for some decreasing $b_k$. In hindsight, a natural question that arises is whether there is a limit to the speed at which a a class of algorithm can solve a particular class of problems: whether there is a fastest possible $a_k$. In the optimisation literature, this is the question of _complexity_. The complexity of a class of problems answers the question: given a iterative procedure such as gradient descent, what is the _worst-case_ performance of the algorithm across the class of all problems of a given class? Note that to answer this question it is enough to find an example function---"the worst function in the world"---that is hard to solve for the given class of algorithm @nesterov2004.

The breakthrough contribution on this topic came in #cite(<nemirovsky1983>, form: "author")'s textbook of #cite(<nemirovsky1983>, form: "year") #cite(<nemirovsky1983>). #footnote([It is a nice historical fact that the acknowledges in @nesterov83 make it clear that @def:nesterovmethodoriginal was inspired by conversations with the authors of #cite(<nemirovsky1983>).]) Given any first-order method on the class of problems $scr(P)$, #cite(<nemirovsky1983>, form: "author") found a pathological convex and #Lsmooth function for which $f(x_k) - f_star$ could be _guaranteed_ to be at least a given $epsilon_k > 0$. This means we have upperbounds and lowerbounds for the performance of algorithms. So the situation is that we can make statements of the form :

$
  cal(O)(a_k) <= f(x_k) - f_star <= cal(O)(b_k),
$

with both $a_k, b_k arrow.r 0$. It is significant when $a_k$ and $b_k$ are of the same asmyptotic order, for example $1\/k^2$ in the case of @thm:nesterov, it is very significant because it means that the worst-case performance of the algorithm is of the same asymptotic order as its theoretical optimum.

I state this result based on the simplified exposition given in #cite(<nesterov2004>, supplement: "Theorem 2.1.7").

#theorem([#cite(<nemirovsky1983>)])[
  Let $k <= (p - 1)\/2$ and $L > 0$. For any first-order algorithm generating a sequence $seqfull({x_k}, k>=0)$ that satisfies
  $
    x_k in x_0 + span{nabla f(x_0), nabla f (x_1), ..., nabla f(x_(k-1))},
  $
  there exists a convex, #Lsmooth function $f$ such that
  $
    f(x_k) - f_star >= 3/32 (L norm(x_0 - x_star)^2)/(k+1)^2
  $<eq:nemlowerbound>
]

Comparing (@eq:nemlowerbound) with (@eq:nesterovconvergence), we immediately see that we have the situation described above for Nesterov's algorithm - the upperbound sequence $b_k$ is of the same asymptotic order as the lowerbound sequence $a_k$. This result is the key finding that makes Nesterov's method so important: it was the first method found to have a worst-case guarantee that is the same order as the theoretical best case. It is also notable that the bound depends on the dimension of the ambient space only through the restriction on the number of iterations. In higher dimension we can reasonably expect to need more iterates (say, around half the number of dimension) but the worst-case bound is not for example increasing in dimension.

It is a surprising fact that the "worst function in the world" needed to prove this bound is infact just a quadratic function. In #cite(<nesterov2004>) #cite(<nesterov2004>, form: "author") gives an example of the surprisingly simple function:

$
  f_k (x) = L/4 { 1/2 [(x^((1)))^2 + sum_(i=1)^(k-1) (x^((i)) - x^((i+1)))^2 + (x^((k)))^2] - x^((1)) }
$

Although #cite(<nesterov83>, form: "author")'s method was the first to close the gap between upperbound and lowerbound, in the decades since other first-order algorithms satisfying the same condition have been discovered (for example, see @bubeck2015geometric @kim2015 @drori2014performance ). A method known as the _optimal gradient method_ has been shown havle the gap between $a_k$ and $b_k$ complexity lower bound (@eq:nemlowerbound) @drori2017. This method, stated below, is strikingly similar to #cite(<nesterov83>, form: "author")'s method and was attained through a recently introduced methodology called the _performance estimation problem_ @drori2014performance, which is a subtle recasting of the original complexity problem in a way that allows for the proof of tighter, optimised bounds.

== The new result of #cite(<ryu2026>, form: "author")

Depsite all the progress on understanding the behaviour of the quantity $f(x_k) - f_star$ seen in the previous sections, the question of point convergence was only settled in early #cite(<ryu2026>, form: "year"). #cite(<ryu2026>, form: "author")'s new result confirming the point convergence of #cite(<nesterov83>)'s method

#theorem(cite(<ryu2026>, supplement: "Theorem 3.5"))[
  Consider an optimisation problem of class $scr(P)$ and consider the iterative procedure defined by @def:nesterovmodern. The sequences $seqfull({x_k}, k>=0)$ and $seqfull({y_k}, k>=0)$ converge to the same minimiser $x_infinity in argmin(f)$:
  $
    x_k arrow.r x_infinity, y_k arrow.r x_infinity, x_infinity in argmin(f)
  $
]

#proof[
We refer to @ryu2026 for the full proof and sketch only its structure here.

The high-level strategy of the proof is as follows.

+ Rewrite NAG in the equivalent form of @lem:reformulation, which introduces the auxiliary sequence ${z_k}$.

+ Since ${x_k}$ is bounded and $f(x_k) -> f^star$ (both following from the bounded potential of @lem:nesterovpotential), Bolzano--Weierstrass yields at least one accumulation point, and continuity of $f$ places every accumulation point in $arg min f$. If there is exactly one accumulation point, the bounded sequence converges to it and we are done.

+ Otherwise, suppose ${x_k}$ has two distinct accumulation points $z_1, z_2 in arg min f$; the rest of the proof shows that they must coincide.

+ Apply @lem:nesterovpotential. The potential $cal(E)_k (z)$ depends on the minimiser $z$ only through the term $L/2 norm(z_k - z)^2$, so the difference $cal(E)_k (z_1) - cal(E)_k (z_2)$ cancels the objective-gap term $t_(k-1)^2 (f(x_k) - f^star)$ outright -- it carries no dependence on the minimiser -- and, once the remaining squared distances are expanded, the quadratic $L/2 norm(z_k)^2$ as well:
  $ norm(z_k - z_1)^2 - norm(z_k - z_2)^2 = -2 chevron.l z_k, z_1 - z_2 chevron.r + norm(z_1)^2 - norm(z_2)^2. $
  What survives is affine in $z_k$. Writing $h_k := norm(x_k - z_1)^2 - norm(x_k - z_2)^2$ for the same affine functional evaluated at $x_k$, and using the affine combination $z_(k+1) = t_k x_(k+1) - (t_k - 1) x_k$ supplied by @lem:reformulation, the three quantities collapse, with $H_k := cal(E)_k (z_1) - cal(E)_k (z_2)$, into the linear recursion
  $ h_(k+1) + (t_k - 1)(h_(k+1) - h_k) = 2/L H_(k+1). $

+ Because $t_k <= k + 1$, the series $sum_k 1\/(t_k - 1)$ diverges, and the right-hand side of the recursion converges (each potential does), so the summation lemma forces $h_k$ to a finite limit. Evaluating that limit along subsequences converging to $z_1$ and to $z_2$ gives $-norm(z_1 - z_2)^2$ and $norm(z_1 - z_2)^2$; as the limit is unique, $z_1 = z_2$. Hence ${x_k}$ converges, and ${y_k}$ converges to the same minimiser.

]

In the past decade before this new proof some progress on adjacent questions was made. The setting considered by FISTA---Fast iterative shirnkage-thresholding Algorithm---builds on the ideas of Nesterov and generalises the method to a non-smooth setting.

The setting considered by FISTA is the so called "smooth + non-smooth" problem of the form

$
  min_(x in RR^P) f(x) + g(x),
$<eq:FISTAproblem>

where $f$ is convex and #Lsmooth as usual but $g$ is non-smooth. The condition on $g$ is that it is simple enough such that the regularisation problem

$
  x in RR^p, space argmin_(y in RR^P) g(y) + norm(x - y)^2/2,
$

can be easily solved. For example, the motivating example in the literature is the $ell_1$--regularisationed linear regression setting, where we solve

$
  min_(x in RR^p) norm(A x - b)^2 + lambda norm(x)_1
$

for $A in RR^(n times p), lambda > 0$. The FISTA algorithm essential does Nesterov's accelerated method but add a proximal operator as a first step to handle $g$, as seen in the following definition.

#definition([FISTA, #cite(<beckteboulle2009>)])[
  Consider a problem of the form @eq:FISTAproblem
]

- However, in 2015 we already had a theorem - point convergence of a slightly modified version of FISTA, but not the original FISTA itself (for otherwise there would be no need of ryu's paper since a proof of point convergence for FISTA is a proof of nesterov for convex, smooth functions).

#theorem([Point convergence of FISTA, #cite(<chambolledossal2025>, supplement: "Theorem 3")])[

]



= Conclusions and perspectives

- Mention the continuous time perspective

There are several other perspectives on these proofs that the reader may find useful. One useful
perspective is that of viewing these methods as discretizations of suitable continuous dynamics; this
appears even in the classic work of Nemirovski and Yudin [18], and has been widely used recently (see,
e. g., [24, 29, 17, 30]).

- Mention implicit bias in machine learning

/* document bibliograph */
#bibliography("thesis.bib")