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

#set document(title: [Context for the Recent Proof of the Point Convergence of Nesterov's Accelerated Gradient Method#footnote("I am very grateful to Professor Edouard Pauwels for his guidance during this project, and all errors and omissions in this work are, of course, my own.")
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

The optimisation of convex and smooth functions by an iterative procedure dates back to at least the time of Cauchy #cite(<cauchy1847methode>). The classical device---known as _gradient descent_---is known to converge in the sense that $f(x_k) - f_star <= cal(O)(1\/k)$, and has several desirable properties, including so-called _point convergence_: that the iterates themselves converge as the number of iterations increases indefinitely. A break-through in the study of optimisation algorithms occurred when it was established that the fastest theoretical rate for a first-order algorithm was $cal(O)(1\/k^2)$. However, initially it was unknown whether such an algorithm attaining this maximum rate existed.

The answer eventually came in the affirmative from #cite(<nesterov83>, form: "author")'s seminal paper @nesterov83, in which his _accelerated_ gradient method was originally proposed. With a trivial amount of additional computation, Nesterov's method was able to accelerate gradient descent to the faster $O(1\/k^2)$ rate. In the decades since, a large and diverse body of results on related problems has been established as optimisation has taken on renewed relevance in applications, with Artificial Intelligence being the dominant contemporary example. However, whether the point convergence property was retained under Nesterov's acceleration scheme remained an open question until very recently, when researchers were again able to answer in the affirmative @ryu2026. Perhaps fittingly, the key innovation that provided the solution to this longstanding open question was obtained with the assistance of a large language model.

The goal of this work is to trace a narrow path through the literature, providing a tightly-focused context for recent proof (Theorem 3.5 in @ryu2026) in terms of the preceding literature. The material starts simple, assuming a familiarity with typical analysis material but not necessarily iterative schemes for optimisation.

== Notation and conventions

Throughout, $p in NN$ denotes the dimension of the ambient space, and a vector is written $x = (x^((1)), ..., x^((p))) in RR^p$. Following @boyd2004, a function is written $f : RR^p arrow.r RR$, with domain $dom(f) subset.eq RR^p$ where the inclusion may be strict; in this thesis, however, $f$ is typically defined on all of $RR^p$. The symbol $norm(.)$ always denotes the Euclidean norm $norm(.)_2$, and $chevron.l x, y chevron.r$ the corresponding inner product on $RR^p$. The closed ball of radius $r$ centred at $x$ is $overline(B)(x, r) = {y in RR^p : norm(y - x) <= r}$. Finally, big-$cal(O)$ notation is used in the typical way: for real sequences ${a_k}$ and ${b_k}$, the statement $a_k = cal(O)(b_k)$ means that $abs(a_k) <= C abs(b_k)$ for some constant $C > 0$ and all $k$ sufficiently large.

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
    forall x, y in RR^p : norm(nabla f(x) - nabla f(y), size: #150%) <= L norm(x - y).
  $
  In writing $L(f)$ is typically shortened to $L$ where no confusion is likely.
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

The distinction between classes of algorithms in this thesis will be drawn according to the information to which $mu in cal(M)$ has access to solve $P$. This thesis will consider only the class of 'first-order' algorithms on convex and smooth functions (where $L$ is known), so I use $scr(P)$ to refer to minimisation of smooth and convex functions as in the preceding discussion and largely omit use of $mu$ and $cal(M)$.

#definition([First-order algorithm #cite(<nesterov2018lectures>, supplement: "Section 1.1.2")])[
  A first-order algorithm is an iterative procedure  that produces a sequence $seqfull({x_k}, k >=0) subset.eq RR^p$ using only the information contained in
  $
    seqfull({x_k, f(x_k), nabla f(x_k)}, k >= 0).
  $
]

Put simply, in a first-order algorithm the next iterate is a function only of the previous iterates along with the function values and gradients at those points. With the preceding definitions, I am now in a position to formally restate the problem described in the previous section. As in (@basiceq), I consider the (unconstrained) optimisation problem

$
 minimise_(x in RR^p) f(x),
$<minfx>

where $f : RR^p arrow.r RR$, called the _objective_, is continuous, convex, and #Lsmooth. I am interested in the certain properties of first-order algorithms to solve (@minfx). The first and most natural, minmal property of an algorithm is convergence _in value_, meaning that the sequence $seqfull({x_k},k>=0)$ produced by $mu$ satisfies

$
  f(x_k) arrow.long.r_(k arrow.r infinity) f_star = min_(x in RR^p) f(x).
$<def:convergenceinvalue>

It is assumed throughout this thesis that there exists at least one $x_star in argmin(f)$. Theoretically, the algorithms of interest are those with the best _worst-case_ guarantee, meaning that $f(x_k) - f_star$ is smaller than some threshold for a given $k$ _whatever the problem_ $P in scr(P)$. It turns out that the algorithm described in @chapter:nesterov is in this sense the _fastest possible_ first-order algorithm: it has the best _worst-case_ guarantee (up to a multiplicative constant) of convergence in $scr(P)$.

The second property of interest in this thesis is convergence _in iterates_, or _point convergence_, meaning that

$
  x_k arrow.long.r_(k arrow.r infinity) x_infinity in argmin_(x in RR^p) f(x).
$<def:pointconvergence>

Point convergence is an important property to establish for an optimisation algorithm, for both mathematical and practical reasons. Mathematically, it is the natural question to ask once convergence in value (@def:convergenceinvalue) has been established because it reflects an understanding of the geometry of the sequence the algorithm produces. Practically, the property also matters because the minimiser itself often carries significant meaning, rather than optimal function value itself. In @beckteboulle2009, for instance, it represents a deblurred image, and a failure of point convergence would mean the iterates never settle: the recovered image could differ vastly depending on when the algorithm is stopped. Distinct minimisers can correspond to entirely different reconstructions even at identical objective value, complicating practical use of the procedure.

On the face of it, one might expect that (@def:pointconvergence) should follow easily from (@def:convergenceinvalue), but this is not at all the case. For example, the iterates may oscillate between two minimisers while $f(x_k)$ approaches the minimum value $f_star$. However, the implication does follow under the very restrictive assumption that $argmin(f)$ is a singleton (e.g. when $f$ is _strongly_ convex), as shown in the following simple lemma.

#lemma[
  Let $f$ be as above and assume that $argmin(f) = {x_star}$. Let $seqfull({x_k}, k>=0) subset.eq RR^p$. If $f(x_k) arrow.r f(x_star)$ as $k arrow.r infinity$, then $x_k arrow.r x_star$.
]<lemma:singletonargmin>

#proof[
  First, I claim that $seqfull({x_k}, k>=0)$ is bounded. Towards a contradiction, suppose that $seqfull({x_k}, x>=0)$ is unbounded. Then $norm(x_k - x_star) arrow.r infinity$ along a subsequence. Now define $u_k := (x_k - x_star) \/ norm(x_k - x_star)$, so $seqfull({u_k}, k>=0)$ is contained in the closed unit ball, hence compact, and by the Bolzano-Weierstrass Theorem, $u_k arrow.r u_infinity$ with $norm(u_infinity) = 1$ along another subsequence. Fix $t>0$ and define another sequence $lambda_k := t \/ norm(x_k - x_star)$, with $lambda_k arrow.r 0$. Then, using (@eq:convexfunction),

  $
    f(x_star + t u _k) &= f lr(((1 - lambda_k) x_star + lambda_k x_k), size: #150%) \
    & <= (1 - lambda_k) f(x_star) + lambda_k f(x_k) \
    & = f_star + lambda_k (f(x_k) - f_star)
  $<eq:introlemma>

  As $k arrow.r infinity$, $u_k arrow.r u_infinity$, $lambda_k arrow.r 0$, and $f(x_k) - f_star arrow.r 0$ by assumption. From (@eq:introlemma), this gives $f(x_star + t u_infinity) <= f_star$, giving a contradiction $arrow.zigzag$. Since $seqfull({x_k}, k>=0)$ is bounded, it has at least one accumulation point $overline(x)$. Since $f$ is continuous, $f(overline(x)) = f_star$, and therefore $overline(x) = x_star$.

]

In general we do not restrict to situations covered by @lemma:singletonargmin, and therefore point convergence requires a  separate proof---often by a completely separate strategy---to convergence in value. The fundamental contribution of #cite(<ryu2026>, form: "prose") is such a proof for Nesterov's accelerated gradient method.
 
== The need for an iterative scheme

Before moving on to describe Nesterov's method and our main result, it is worth pausing for a moment to recall why we have a need for iterative algorithms to solve (@minfx). When a convex function $f$ is differentiable, we have the classical necessary and sufficient optimality condition $nabla f(x) = 0$ #cite(<boyd2004>, supplement: "Equation 4.22"). In this case, solving (@minfx) amounts to solving this system of $p$ equations. In many problems, even simple and smooth problems, this system is too difficult or even impossible to solve #cite(<boyd2004>, supplement: "Section 1.1.2"). 

Moreover, there are cases when the model is theoretically solvable, but the size or other characteristics of the problem can make a solution prohibitively expensive to compute or meaningless in practice #cite(<beckteboulle2009>, supplement: "Section 1.1"). This necessitates _approximate_ solutions through iterative methods, which can be costly to operate. Hence, we look for efficient, fast algorithms with attractive properties that can provide solutions with sufficient accuracy under constraints on the resources that they are allowed to consume.

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
    & x_(k+1) = x_k - alpha_k nabla f (x_k) quad text("for") k >= 0
  $<eq:gd>
  where $seqfull({alpha_k}, k >= 0)$ is a suitable non-negative sequence called the 'learning rate'.
]<def:gd>

The deep connection to (@eq:gradientproblem) is evident when it is observed that (@eq:gd) is the solution to the following convex optimisation problem

$
  x_(k+1) = argmin_(x in RR^p) {f(x_(k)) + chevron.l x - x_k, nabla f (x_k) chevron.r + 1 / (2 alpha_k) norm(x - x_k)^2}.
$

The protocol by which a suitable step size $alpha_k$ is determined clearly plays a large role in determining the behaviour of the method. However, it is clear that so long as the learning rate is chosen such that $f(x_(k+1)) = f(x_k - a_k nabla f(x_k)) <= f(x_k)$, the sequence $seqfull({f(x_k)}, k>=0)$ has the potential to decrease to $f_star$. In both theory and practice, there are many possible choices for the sequence $seqfull({alpha_k}, k>=0)$, including:

- Fixed step sizes: $alpha_k = alpha > 0$ with choice dependent on $P$;
- Line search: $alpha_k = argmin_(alpha >= 0) f(x_k - alpha nabla f (x_k))$;
- Decreasing step sizes: $alpha_k >= 0$ and $alpha_k arrow.r 0$.

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

That is, for problems in $scr(P)$ a 'gradient step' of size at most $1\/L$ _guarantees_ a decrease in the objective that is proportional to $norm(nabla f (x))^2$. I am now in a position to state the classical convergence results on the gradient descent method for a fixed step size.

#theorem[Consider an optimisation problem $P in scr(P)$. The gradient descent method with a constant learning rate $alpha_k = 1 \/ L$ satisfies

  _Convergence in value:_
  $
    f(x_k) - f(x_star) <= (L norm(x_0 - x_star)^2) / (2k) = cal(O)(1\/k)
  $<eq:conv-in-value>
  _Point convergence:_
  $
    x_k arrow.r x_infinity in argmin (f) text("as") k arrow.r infinity
  $<eq:conv-in-interates>
]<thm:gd>

I reproduce a short proof that explicitly shows the use of a _potential function_ based on a recent effort to collect a unified approach to proofs of gradient methods #cite(<gupta2019>)#cite(<dAspremont2021>). The potential function perspective is useful for my purposes because the same device turns out to be critical for the main result of #cite(<ryu2026>, form: "author"). See @nesterov2018lectures@bubeck2015 for more classical expositions, upon which I also draw for the proof of point convergence.

The main idea in @gupta2019 is to define a _potential_ function of the form

$
  cal(E)_k = A_k lr(( f(x_k) - f(x_star)), size: #150%) + B_k norm(x_k - x_star)^2,
$

with $A_k, B_k >=0$ and show $cal(E)_(k+1) - cal(E)_k <= C_k$ for some real sequence $seqfull({C_k}, k>=0)$. Then, using a telescoping sum from $k = 0, ..., K-1$ and the fact that both terms of $cal(E)_k$ are non-negative gives

$
  sum_(k=0)^(K-1) cal(E)_(k+1) - cal(E)_k <= sum_(k=0)^(K-1) C_k arrow.double.r f(x_K) - f(x_star) <= (cal(E)_0 + sum_(k = 0)^(K-1) C_k) / A_K
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

I claim that $cal(E)_k$ is weakly decreasing in $k$. To see this, consider the _potential difference_

$
  cal(E)_(k+1) - cal(E)_k = (k + 1) &lr( ( f(x_(k+1)) - f(x_k) ), size:  #150%) + lr((f(x_k) - f(x_star)), size: #150%) \
  & + L / 2 lr((norm(x_(k+1) - x_star)^2 - norm(x_k - x_star)^2), size: #150%).
$

Next, use (@eq:gradientstepsmoothguarantee), (@eq:convexfunction), (@eq:pythagorasproperty) on each of the terms respectively to find an upper bound

$
  cal(E)_(k+1) - cal(E)_k <= &(k + 1) (- 1 / (2L) norm(nabla f(x_k))^2) \
  &+ space chevron.l nabla f(x_k), x_k - x_star chevron.r \
  &+ space L/2 ( 2 / L chevron.l nabla f(x_k), x_star - x_k chevron.r + 1 / (L^2) norm(nabla f(x_k))^2).
$

After a cancellation of terms this can be written as

$
  cal(E)_(k+1) - cal(E)_k <= - (k/(2L)) norm(nabla f(x_k))^2 <= 0.
$

So it suffices to take $C_k = 0$ for $k >= 0$. Using the fact that $cal(E)_0 = L \/ 2 norm(x_0 - x_star)^2)$ in (@eq:potentialbound) gives the result.


_(point convergence)_

I claim that $norm(x_k - x_star)$ is decreasing. By interchanging the role of $x$ and $y$ in (@eq:quadraticub) and summing the resulting two equations, we can conclude

$
  1 / L norm(nabla f(x) - nabla f (y))^2 <= chevron.l nabla f(x) - nabla f(y), x - y chevron.r,
$<eq:twice-eval-and-add>

for all $x, y in RR^p$. We know $nabla f(x_star) = 0$ for any $x_star in argmin(f)$, hence

$
  1/L norm(nabla f(x_k))^2 <= chevron.l nabla f (x_k), x_k - x_star chevron.r.
$

From this we can conclude $norm(x_k - x_star)$ is weakly decreasing, since

$
  norm(x_(k+1) - x_star)^2 &= norm(x_k - x_star)^2 + 1/L^2 norm(nabla(f(x_k)))^2 - 2 / L chevron.l x_k - x_star, nabla f(x_k) chevron.r \
  &<= norm(x_k - x_star)^2 - 1 / L^2 norm(nabla f(x_k))^2 <= norm(x_k - x_star)^2.
$

What remains is a standard Fejér monotonicity argument (e.g. see @fejermonotonicity). Let $r := norm(x_0 - x_star)$. The sequence $a_k = norm(x_k - x_star)$ is non-negative, so it converges to some $l in [0, r]$; it is not yet clear that $l = 0$. In particular, $x_k in overline(B)(x_star, r)$ for all $k$, so $(x_k)$ is a bounded sequence in $RR^p$ and, by the Bolzano--Weierstrass theorem, has at least one convergent subsequence. Denote it by $x_phi(k) arrow.r x_infinity$, with $phi(k) >= k$.

By the continuity of $f$, we have $f(x_phi(k)) arrow.r f(x_infinity)$. But $seqfull({f(x_phi(k))}, k>=0)_k$ is a subsequence of the convergent sequence $seqfull({f(x_k)}, k>=0)$, and so $f(x_infinity) = f(x_star)$; that is, $x_infinity in argmin(f)$. Since $x_infinity$ is itself a minimiser, the same argument applied to $x_s$ in place of $x_star$ shows that $norm(x_k - x_infinity)$ converges. Passing to the subsequence $x_phi(k) arrow.r x_infinity$ forces this limit to be $0$, hence $x_k arrow.r x_infinity in argmin(f)$.
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

Compared with @def:gd, (@eq:nesterovmethodoriginal) method introduces several new calculations into the iteration step, though it remains a first-order algorithm, since it uses only gradient information. The first thing to note is that there are now two sequences: $seqfull({x_k}, k >= 0)$, obtained from a gradient step with a backtracking rule for the step size, and $seqfull({y_k}, k >= 0)$, which perturbs the search point according to a further sequence $seqfull({t_k}, k >= 0)$. Both will be shown to approach $x_star in argmin(f)$.

The step-size sequence $seqfull({alpha_k}, k >= 0)$ is initialised at $norm(y_0 - z) \/ norm(nabla f(y_0) - nabla f(z))$, which by the #Lsmoothness of $f$ is guaranteed to be at least $1 \/ L$. This step is here to ensure that the step sizes satisfy @cor:convexLsmooth when the function $f$ is #Lsmooth but the smoothness coefficient itself $L$ is not known. The procedure therefore begins with a step that is plausibly too large and relies on halving by a power of $n_k$ to shrink it to the largest admissible value, rather than starting small and never attempting aggressive steps.

For problems in $scr(P)$, I assume that the smoothness coefficient $L$ is known. Hence, given @cor:convexLsmooth the backtracking step in (@eq:nesterovmethodoriginal) can be avoided, substituting instead the largest admissable step size $1\/L$. With this simplification, the method is typically written in the equivalent form below.

#definition([Nesterov's Method - General])[
  Consider a problem of class $scr(P)$. Nesterov's accelerated method is equivalent to

  _Initialisation:_

  $x_0 = y_0 in RR^p$ and $seqfull({t_k}, k>=0)$ satisfying $t_0 = 1$ and $t_(k+1)^2 - t_(k+1) <= t_k^2$.

  _Iteration step:_

  For $k = 0, 1, ...$,

  $
    x_(k+1) &= y_k - 1/L nabla f(y_k), \
    y_(k+1) &= x_(k+1) + (t_k - 1)/t_(k+1) (x_(k+1) - x_k).
  $
]<def:nesterovmodern>

#lemma([#cite(<nesterov2005smooth>, supplement: "Lemma 1")#cite(<ryu2026>, supplement: "Lemma 3.1")])[
  Consider a problem of class $scr(P)$. The following method produces the same sequences $seqfull({x_k}, k>=0), seqfull({y_k}, k>=0)$ as the iterative procedure defined in @def:nesterovmodern.

  _Initialisation:_

  $x_0 = y_0 = z_0 in RR^p$ and $seqfull({t_k}, k>=0)$ satisfying $t_0 = 1$ and $t_(k+1)^2 - t_(k+1) <= t_k^2$.

  _Iteration step:_
  For $k = 0, 1, ...$,

  $
    x_(k+1) &= y_k - 1/L nabla f(y_k), \
    z_(k+1) &= z_k - t_k / L nabla f(y_k), \
    y_(k+1) &= (1 - 1 / t_(k+1)) x_(k+1) + 1 / t_(k+1) z_(k+1).
  $


]<lem:reformulation>

This reformulation lends some intuition for how #cite(<nesterov83>, form: "author")'s method works. Both updates move in the same direction $-nabla f(y_k)$, but the factor $t_k$ makes the step taken by ${z_k}$ equal to $t_k$ times the ordinary gradient step taken by ${x_k}$, a multiple that grows without bound since $t_k arrow.r infinity$. The auxiliary sequence ${z_k}$ thus takes increasingly aggressive steps, accelerating early progress but at the risk of overshooting a minimiser. Counterbalancing this, the extrapolated point $y_(k+1)$ at which the gradient is evaluated is a convex combination of $x_(k+1)$ and $z_(k+1)$, carrying weights $1 - 1\/t_(k+1)$ and $1\/t_(k+1)$ respectively. As $t_(k+1) arrow.r infinity$, almost all of this weight falls on $x_(k+1)$. It is this precise balance between these two effects---${z_k}$ taking increasingly aggressive steps while exerting ever less influence on ${y_k}$---from which Nesterov's method yields the accelerated $cal(O)(1\/k^2)$ rate.

I have not yet addressed the most mysterious ingredient of Nesterov's method: the choice of sequence ${t_k}$ and the inequality it must satisfy. Nesterov's original paper is well known for its algebraic elegance, yet it famously offered little motivation for this particular choice of sequence. The definition appears instead to have been reverse-engineered from the following result, reproduced here in the form given by @ryu2026.

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

In the decades since #cite(<nesterov83>, form: "author")'s paper, a literature has grown around trying to identify the core of how the method achieved acceleration (e.g., @zhuallenorecchia2017@ahn2022@su2016differential). The aim of this literature is to find insights that could improve acceleration of existing algorithms on other classes of problem. For example @zhuallenorecchia2017, who find that the sequence $seqfull({t_k}, k >=0)$ can be seen to arise naturally as an optimal combination of gradient descent and mirror descent.

The potential function (@eq:nesterovpotentialfunction) clearly resembles the potential function (@eq:gdpotential) that played a central role in the proof of gradient descent. This raises a natural question: by continuing to refine such potential functions, could we obtain ever-faster algorithms? The answer is no, as the next section explains. Nonetheless, this potential does allow us to prove the convergence of Nesterov's method.

#theorem([Convergence in value of Nesterov's Method, #cite(<nesterov83>))])[
  Consider an optimisation problem of class $scr(P)$. The iterative procedure defined in @def:nesterovmodern satisfies, for $k = 0, 1, ...$,
  $
    f(x_k) - f_star <= (2 L norm(x_0 - x_star)^2) / (k+1)^2 = cal(O)(1\/k^2)
  $<eq:nesterovconvergence>
]<thm:nesterov>

#proof[See #cite(<gupta2019>, supplement: "Theorem 5.1") for a proof that completely mirrors that of @thm:gd ]

== Complexity and lower bounds

The results on convergence in value obtained so far are all of the form $f(x_k) - f_star <= cal(O)(b_k)$ for some sequence $b_k arrow.r 0$. This invites a more fundamental question: is there a limit to how fast _any_ first-order method can solve problems in $scr(P)$---a best possible rate beyond which no algorithm, however clever, can improve? In the optimisation literature, this is the question of _complexity_, and answering it requires only a single example---"the worst function in the world"---on which every first-order method is provably slow @nesterov2004.

The breakthrough came in #cite(<nemirovsky1983>, form: "author")'s #cite(<nemirovsky1983>, form: "year") textbook #cite(<nemirovsky1983>).#footnote[It is a nice historical fact that the acknowledgements in @nesterov83 make clear that @def:nesterovmethodoriginal was inspired by conversations with the authors of #cite(<nemirovsky1983>).] Given any first-order method, #cite(<nemirovsky1983>, form: "author") construct a convex, #Lsmooth function on which $f(x_k) - f_star$ is _guaranteed_ to remain at least some $a_k > 0$. This is a _lower_ bound, complementing the _upper_ bounds derived earlier: a fixed method satisfies $f(x_k) - f_star <= cal(O)(b_k)$ across the whole class, whereas for any method there is some problem in the class on which $f(x_k) - f_star$ stays at least of order $a_k$. When $a_k$ and $b_k$ are of the same asymptotic order---for instance $1\/k^2$, as confirmed below---the best achievable worst-case rate is pinned down exactly, and any method attaining it is _worst-case optimal_.

The following statement of the lower bound follows the simplified exposition of #cite(<nesterov2004>, supplement: "Theorem 2.1.7").

#theorem([#cite(<nemirovsky1983>)])[
  Let $k <= (p - 1)\/2$ and $L > 0$. For any first-order algorithm generating a sequence $seqfull({x_k}, k>=0)$ that satisfies
  $
    x_k in x_0 + span{nabla f(x_0), nabla f (x_1), ..., nabla f(x_(k-1))},
  $
  there exists a convex, #Lsmooth function $f$ such that
  $
    f(x_k) - f_star >= 3/32 (L norm(x_0 - x_star)^2)/(k+1)^2.
  $<eq:nemlowerbound>
]

Comparing (@eq:nemlowerbound) with #cite(<nesterov83>, form: "author")'s upper bound (@eq:nesterovconvergence), both are of order $1\/k^2$. This is the result that makes Nesterov's method so important: it was the earliest first-order method whose worst-case guarantee matches the complexity lower bound for the class $scr(P)$. The bound is also, in a sense, dimension-free, since its right-hand side does not involve $p$; the dimension enters only through the range $k <= (p-1)\/2$ over which the bound is guaranteed to hold, so a higher-dimensional does not unduly require more iterations.

It is a striking fact that "the worst function in the world" is just a quadratic function. #cite(<nesterov2004>, form: "prose") gives the explicit example
$
  f_k (x) = L/4 { 1/2 [(x^((1)))^2 + sum_(i=1)^(k-1) (x^((i)) - x^((i+1)))^2 + (x^((k)))^2] - x^((1)) }.
$

#cite(<nesterov83>, form: "author")'s method was the first to close the gap between the upper and lower bounds, but not the last: several other first-order methods are now known to do the same (see e.g. @bubeck2015geometric @kim2015 @drori2014performance). The _optimised gradient method_ (OGM) goes further still, halving the constant in #cite(<nesterov83>, form: "author")'s guarantee (@eq:nesterovconvergence) to exactly attain the tight complexity lower bound established by @drori2017. Although very similar to Nesterov's method, OGM was obtained through the _performance estimation problem_ @drori2014performance, a framework that recasts worst-case analysis as an optimisation problem and so yields these sharper methods and bounds.


== The new result of #cite(<ryu2026>, form: "author")

Despite all the progress on understanding the behaviour of the quantity $f(x_k) - f_star$ seen in the previous sections, the question of point convergence was only settled in early #cite(<ryu2026>, form: "year"). #cite(<ryu2026>, form: "author")'s new result confirming the point convergence of #cite(<nesterov83>)'s method

#theorem(cite(<ryu2026>, supplement: "Theorem 3.5"))[
  Consider an optimisation problem of class $scr(P)$ and consider the iterative procedure defined by @def:nesterovmodern where $t_(k+1)^2 - t_(k+1) = t_k^2$. The sequences $seqfull({x_k}, k>=0)$ and $seqfull({y_k}, k>=0)$ converge to the same minimiser $x_infinity in argmin(f)$:
  $
    x_k arrow.r x_infinity, space y_k arrow.r x_infinity, space x_infinity in argmin(f)
  $
]<thm:mainresult>

#proof[
I refer to @ryu2026 for the full proof and sketch only its structure here, noting the key innovation.

+ Rewrite @def:nesterovmodern in the equivalent form of @lem:reformulation, which introduces the auxiliary sequence $seqfull({z_k}, k>=0)$. A simple analysis shows that the sequences $seqfull({x_k}, k>=0)$, $seqfull({y_k}, k>= 0)$, and $seqfull({z_k}, k>=0)$ are all bounded.

+ Since $seqfull({x_k}, k>=0)$ is bounded and $f(x_k) -> f^star$ (both following from the bounded potential of @lem:nesterovpotential), the Bolzano--Weierstrass Theorem yields at least one accumulation point, and continuity of $f$ means every accumulation point is in $argmin(f)$. Hence the proof is complete if there is exactly one accumulation point.

+ Otherwise, suppose ${x_k}$ has two distinct accumulation points $x_star, tilde(x)_star in argmin(f)$; the rest of the proof shows that they must coincide.

+ Here is the key innovation. Apply @lem:nesterovpotential to the two distinct accumulation points $x_star, tilde(x)_star$. The potential $cal(E)_k (x_star)$ depends on the minimiser $x_star$ only through the term $L/2 norm(z_k - x_star)^2$, so the difference $cal(E)_k (x_star) - cal(E)_k (tilde(x)_star)$ cancels the objective-gap term $t_(k-1)^2 (f(x_k) - f^star)$ and, once the remaining squared distances are expanded, the quadratic $L/2 norm(z_k)^2$ is cancelled as well:
  $
  norm(z_k - x_star)^2 - norm(z_k - tilde(x)_star)^2 = -2 chevron.l z_k, x_star - tilde(x)_star chevron.r + norm(x_star)^2 - norm(tilde(x)_star)^2.
  $

  What survives is affine in $z_k$. Writing $h_k := norm(x_k - x_star)^2 - norm(x_k - tilde(x)_star)^2$ for the same affine functional evaluated at $x_k$, and using the affine combination $z_(k+1) = t_k x_(k+1) - (t_k - 1) x_k$ supplied by @lem:reformulation, the three quantities collapse, with $H_k := cal(E)_k (x_star) - cal(E)_k (tilde(x)_star)$, into the linear recursion

  $
  h_(k+1) + (t_k - 1)(h_(k+1) - h_k) = 2/L H_(k+1).
  $
  This step is critical and avoids the roadblock that other proofs have relied on in needing to control the behaviour of a term of the form $norm(x_(k+1) - x_(k))^2$ under @def:nesterovmodern (see @chambolledossal2025).

+ Because $t_k <= k + 1$, the series $sum_k 1\/(t_k - 1)$ diverges, and the right-hand side of the recursion converges. This forces $h_k$ to converge to a finite limit. Evaluating that limit along subsequences converging to $x_star$ and to $tilde(x_star)$ gives $-norm(x_star - tilde(x)_star)^2$ and $norm(x_star - tilde(x)_star)^2$; as the limit is unique, $x_star = tilde(x)_star$. Hence ${x_k}$ converges, and ${y_k}$ converges to the same minimiser.
]

During the decade preceding this proof, the literature witnessed progress on several adjacent questions and some partial results were obtained. The most relevant of these is the point convergence of FISTA---the Fast Iterative Shrinkage-Thresholding Algorithm---which extends #cite(<nesterov83>, form: "author")'s acceleration to the non-smooth setting @beckteboulle2009@chambolledossal2025. FISTA addresses the so-called "smooth + non-smooth" composite problem

$
  min_(x in RR^p) f(x) + g(x),
$<eq:FISTAproblem>

where $f$ is convex and #Lsmooth as usual, and $g$ is convex but non-smooth. The main requirement of $g$ is that it be simple enough for its _proximal map_,

$
  argmin_(y in RR^p) {g(y) + 1/2 norm(x - y)^2},
$<eq:proximalmap>

to be evaluated easily for each $x in RR^p$. The canonical example is $ell_1$-regularised (LASSO) regression,

$
  min_(x in RR^p) norm(A x - b)^2 + lambda norm(x)_1,
$

with $A in RR^(n times p)$ and $lambda > 0$; here $norm(A x - b)^2$ is the smooth part and $lambda norm(x)_1$ the non-smooth part, whose proximal map is the well-known soft-thresholding operator. FISTA is, in essence, #cite(<nesterov83>, form: "author")'s accelerated method in which each gradient step is followed by the proximal map of $g$, as the following definition makes precise.

#definition([FISTA, #cite(<beckteboulle2009>)])[
  Consider a problem of the form (@eq:FISTAproblem). The FISTA algorithm is the iterative procedure defined as follows:
  
  _Initialisation:_

  $y_1 = x_0 in RR^p$, $t_1 = 1$.

  _Iterative step:_
  For $k = 1, 2, ...$,

  $
    x_k &= argmin_(x in RR^p) {g(x) + L / 2 norm(x - (y_k - 1 / L nabla f(y_k)))^2} \
    t_(k+1) &= 1/2 (1 + sqrt(1 + 4 t_k^2)) \
    y_(k+1) &= x_k + (t_k - 1)/t_(k+1) (x_k - x_(k-1))
  $
]<def:FISTA>

#cite(<beckteboulle2009>, form: "author") proved that FISTA attains the same $cal(O)(1\/k^2)$ rate as Nesterov's method, matching even its constant---acceleration therefore survives intact, provided the non-smooth term is sufficiently well-behaved. Point convergence, however, proved more delicate. Already in #cite(<chambolledossal2025>, form: "year"), #cite(<chambolledossal2025>, form: "author") established it for a slightly _modified_ version of FISTA, but not for the original algorithm. The original could not have been settled then: since Nesterov's method is exactly FISTA with $g = 0$, a proof of point convergence for the original FISTA would already prove it for Nesterov's method on convex, smooth functions, leaving no role for #cite(<ryu2026>, form: "author")'s later result.


#theorem([Point convergence of modified FISTA, #cite(<chambolledossal2025>, supplement: "Theorem 3")])[
  Let $a>2$ and consider the FISTA procedure in @def:FISTA with the modification
  $
    t_k = (k + (a - 1)) / a.
  $<eq:newt>
  Then the sequence $seqfull({x_k}, k>=0)$ converges to some $x_star in argmin(f + g)$.
]

As #cite(<nesterov83>, form: "author")'s original method is just a special case of @eq:FISTAproblem with $g = 0$ such that the first update in the iterative step of @def:FISTA collapses to the identity function, this is a close partial result because (@eq:newt) does satisfy the inequality $t_(k+1)^2 - t_(k+1) <= t_k^2$ strictly. However, it does not exactly correspond to @def:nesterovmodern, where this is satisfied with equality. The contribution of #cite(<ryu2026>, form: "author") is that they were able to cover this 'critical' case. Very quickly following #cite(<ryu2026>), @bot2025 was able to prove with the same technique that this result does indeed extend to FISTA.

= Conclusion and perspectives

In this thesis I have traced a path from the seminal work of #cite(<nesterov83>, form: "author") towards the current state of knowledge on first-order methods for convex optimisation. I have discussed _complexity_ as it relates to optimisation, and the key result that makes #cite(<nesterov83>, form: "author")'s method so theoretically and historically valuable: the first proof that a method attains the $cal(O)(1\/k^2)$ rate. One topic omitted here is the continuous-time analogue, now a central tool for making progress on these questions; the approach already appears in even earlier work on momentum-based gradient methods. By continuous time I refer to the translation of a question about an iterative algorithm into an analogous differential equation, whose solution is often easier to analyse than the discrete procedure. For example, the differential equation corresponding to Nesterov's algorithm, first introduced in @su2016differential, is

$ 
dot.double(X)(t) + 3/t dot(X)(t) + nabla f(X(t)) = 0, quad quad "for" t >= 0, 
$

under suitable initial conditions. Although not shown here, in @ryu2026 this continuous-time case was solved first and then discretised to prove @thm:mainresult.

Since the proof presented in @ryu2026 was discovered with the assistance from a large language model, it is worth briefly reflecting on the role of artificial intelligence in mathematics. The use of large language models in mathematical research is rapidly gaining popularity. Large language models have recently been used to solve other non-trivial problems in pure mathematics (e.g. @openai2026planar, @knuth2026cycles), and they are finding favour among a growing number of researchers, including some very prominent ones  @davies2021advancing @klowden2026. Future research in all fields of mathematics will need to reckon with the role that it will play in the generation of ideas and proofs.

/* document bibliograph */
#pagebreak()
#bibliography("thesis.bib")