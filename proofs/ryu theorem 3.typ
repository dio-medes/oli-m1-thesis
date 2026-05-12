#import "../preamble.typ": *
#show: notes
#set page(numbering: "1")

#set math.equation(numbering: "(1)")
#let nonum(eq) = math.equation(block: true, numbering: none, eq)
#set math.equation(supplement: none)

#title("Self-contained proof of Theorem 3.5")

_Notation and conventions as per the Notation document._

= Structure

The proof of Theorem 3.5 in @jang2026pointconvergencenesterovsaccelerated rests on four lemmas. In this document I state them in the relevant form for the proof of Theorem 3.5 in @jang2026pointconvergencenesterovsaccelerated. I also give the four lemmas simple, meaningful names for ease of reference.

1. _reformulation (@reformulation):_  rewrites ${x_k}$ and ${y_k}$ from NAG with a third sequence ${z_k}$ in a purely algebraic step that does not change the values of the original sequences.
2. _potential (@potential):_ shows that a particular 'potential function' that involves the sub-optimality gap $f - f_star$ and an 'amortised cost' related to $norm(z_k - x_star)$ is monotonic and converges to a finite limit _when_ ${t_k}$ satisfies the  Nesterov quadratic relation (@tdef).
3. _boundedness (@boundedness):_ shows that ${x_k}$ is bounded.
4. _convergence (@convergence):_ shows that a sequence where a particular amplified version of the increments converges will converge.

In the next sections I construct a complete proof in a unified notation for the above lemmas, followed by the proof of Theorem 3.5 itself. Within reason, I have also attempted to include the statement and proof of any other results used in relevant sections. Many of these are standard tools, such as the Stolz-Cesáro Theorem, but were not known to me beforehand.

== Introduction
Following @jang2026pointconvergencenesterovsaccelerated, for $f : RR^p arrow.r RR$ we consider the optimisation problem

$
  min_(x in RR^p) f(x)
$

where $f$ is continuous, $L$--smooth and convex. We write

$
  f_star = f(x_star), quad forall x_star in argmin_(x in RR^p) f.
$

#definition(title: "Nesterov Accelerated Gradient Descent")[
  
  Let $x_0 = y_0 in RR^p$. Nesterov Accelerated Gradient Descent (NAG) is defined by the iterative construction of the following seequences:
  $
    x_(k+1) &= y_k - 1/L nabla f(y_k) \
    y_(k+1) &= x_k=1 + (t_k - 1) / t_(k+1) (x_(k+1) - x_k) \
    k &= 0, 1, ...
  $<nagdef>
  where ${t_k}$ satisfies
  $
    t_0 := 1, space t_(k+1)^2 - t_(k+1) <= t_k^2.
  $<tdef>
]<nesterov>

= Reformulation

This lemma rewrites (@nagdef) in terms of an intermediate sequence ${z_k}$. 

#lemma(title: "Reformulation")[
  
  The following iterative construction of ${x_k}$ and ${y_k}$ produces the same sequences as NAG from (@nagdef).

  $
  x_(k+1) &= y_k - 1 / L nabla f(y_k),
  $<rf3>

  $
  z_(k+1) &= z_k - t_k / L nabla f(y_k),
  $<rf2>

  $
  y_(k+1) &= (1 - 1 / t_(k+1)) x_(k+1) + 1 / t_(k+1) z_(k+1),
  $<rf1>
  where $x_0 = y_0 = z_0 in RR^p$ and ${t_k}$ is as in (@tdef).

]<reformulation>

#proof[ The proof is direct by algebraic manipulations. Note that only the definition of ${y_k}$ is different to that of @nesterov, so it only remains to show (@rf1) satisfies (@nagdef).

Using (@rf3) in (@rf2) gives
  $
    z_(k+1) = z_k - t_k (y_(k+1) - x_(k+1)).
  $<rf5>
  Rearranging (@rf1) gives
  $
    t_(k+1) y_(k+1) - (t_(k+1) - 1) x_(k+1) = z_(k+1)
  $<rf6>
  which, evaluated at step $k$ yields
  $
    t_(k) y_(k) - (t_(k) - 1) x_(k) = z_(k).
  $<rf7>
  Substituting (@rf7) into (@rf5) gives
  $
    z_(k+1) &= z_k - t_k (y_(k+1) - x_(k+1)) \
    &= t_k x_(k+1) - (t_k - 1)x_k.
  $<rf9>
  Finally, using (@rf9) in (@rf1) yields the result:
  $
    y_(k+1) &= (1 - 1 / t_(k+1)) x_(k+1) + 1 / t_(k+1) (t_k x_(k+1) - (t_k - 1)x_k)) \
    &= x_(k+1) + x_(k+1) (t_k / t_(k+1) - 1 / t_(k+1)) - x_k ((t_k - 1) / t_(k+1)) \
    & = x_(k+1) + (t_k - 1) / t_(k+1) ( x_(k+1) - x_k).
  $
]


This lemma provides some intuition for how NAG works. Due to the factor of $t_k$, at each iteration $z_k$ steps farther than a normal gradient step, accelerating the early progress but potentially overshooting. At the same time, the 'normal' iteration $y_k$ is a weighted average of $x_k$ and $z_k$ that places an increasing weight on $x_k$ with each iteration, and all the weight in the limit. Somehow it turns out that these two processes---${z_k}$ taking larger and larger steps but having less and less influence on ${y_k}$---balance each other perfectly to accelerate the convergence to $O(1\/k^2)$.

= Potential

@jang2026pointconvergencenesterovsaccelerated uses a _potential function_ method to prove point convergence. Loosely, a potential function (key references: @d_Aspremont_2021, @Bansal_2019) is a function of the form defined below. Apparently, the standard way to view these functions is as 'Lyapunov functions'. I believe that perspective is more relevant for continuous time treatments.

#definition(title: "Potential Function")[
  A potential function $Phi_k (x): RR^p arrow RR_+$, usually written as $Phi_k$ since it is usually only evaluated at $x_star$, is defined as 
  $
    Phi_k = a_k (f(x_k) - f(x_star)) + b_k norm(x_k - x_star), quad k in NN^*
  $
  for $a_k, b_k >= 0$.
]

The whole idea of using these functions is to prove $Phi_(k+1) - Phi_k <= B_k$, for some sequence $seqfull({B_k}, k >=0)$ (often $B_k = 0$).

The following lemma is really the core of the whole proof, everything that comes after in the proof is standard analysis.

#lemma(title: "Potential")[

]<potential>

#proof(title: [])[

]

= Boundedness

Given @reformulation and @potential, this is a relatively simple lemma that ensures that the main sequence of iterates ${x_k}$ in NAG is bounded.

#lemma(title: "Boundedness")[

]<boundedness>

= Convergence

This lemma is technical in nature and concerns a particular convergence criteria for a real, strictly positive sequence. Before arriving at @convergence, the following standard result is needed. For completeness, I provide a statement and proof based on #link("https://www.math.ksu.edu/~nagy/snippets/stolz-cesaro.pdf", "this link").

#theorem(title: "Stolz-Cesáro")[ If $seqfull({b_k}, k in NN) subset.eq RR_+^*$ is a real, strictly positive sequence such that $sum_(k = 0)^infinity b_k = infinity$, then for any sequence $seqfull({a_k}, k in NN) subset.eq RR$ the following two inequalities hold:
$
  limsup_(k arrow.r infinity) (sum_(k=0)^infinity a_k) / (sum_(k=0)^infinity b_k) <= limsup_(k arrow.r infinity) a_k / b_k,
$<sc1>
$
  liminf_(k arrow.r infinity) (sum_(k=0)^infinity a_k) / (sum_(k=0)^infinity b_k) >= liminf_(k arrow.r infinity) a_k / b_k.
$<sc2>
In parituclar, if $seqfull({a_k \/ b_k}, k in NN)$ is a convergent sequence, then the above inequalities force
$
  lim_(k arrow.r infinity) (sum_(k=0)^infinity a_k) / (sum_(k=0)^infinity b_k) = lim_(k arrow.r infinity) a_k / b_k.
$<sctlims>
]<sct>

#proof(title: [_Due to G. Nagy_])[ If (@sc1) holds, then (@sc2) holds by taking $a_k arrow.bar - a_k$ and using $sup_(k>=n) -a_k= - inf_(k>=n) a_k$. Therefore it only remains to show (@sc2). If the RHS of (@sc1) is $+infinity$, then the result is trivially true. Assume that $limsup_(k arrow.r infinity) a_k \/ b_k = L$ with $L$ finite or $-infinity$, and let $l > L$ fixed. By definition of $limsup$,
$
  exists k_star in NN : quad a_k / b_k <= l, quad forall k > k_star.
$<scproof1>
Let $A_k$ and $B_k$ be the partial sums of ${a_k}$ and ${b_k}$. By (@scproof1), for all $k > k_star$,
$
  A_k = a_1 + a_2 &+ dots.c + a_k \
  &<= (a_1 + dots.c + a_k_star) + l space (b_(k_star+1) + b_(k_star+2) + dots.c + b_(k)) \
  & = A_k_star + l (B_k - B_k_star).
$
Since $B_k >0$, dividing by $B_k$ gives
$
  A_k / B_k <= l + (A_k_star - B_k_star) / (B_k), quad forall k > k_star.
$
Fixing $k_star$ and taking $limsup_(k arrow.r infinity)$ on both sides gives
$
  limsup_(k arrow.r infinity) A_k / B_k <= l, quad forall l > L
$
This is a lowerbound for the set ${l in RR : l > L}$ that has infimum (greatest upper bound) $L$, hence the result.
]

#lemma(title: "Convergence")[
  Let $seqfull({phi_k}, k>=0), seqfull({t_k}, k>=0) subset.eq RR_+^*$ be sequences of real and positive numbers respectively, such that $sum_(k = 0)^infinity (1\/b_k) = +infinity$. If
  $
    lim_(k arrow.r infinity) a_(k+1) + b_k (a_(k+1) - a_k) arrow.r L in RR,
  $
  then
  $
    lim_(k arrow.r infinity) a_k = L
  $
]<convergence>

#proof(title: [_From cited article_])[
  
  For all $k in NN$ let $ell_k = t_k (phi_(k+1) - phi_k)$ and suppose that $l_k arrow.r L in RR$ as $k arrow.r infinity$. Consider the positive sequence ${mu_k}$ defined recursively as
  $
    m_0 := 1 / t_0 space text("and") space m_(k+1) := (mu_k + mu_k t_k) / t_(k+1), quad forall k in NN.
  $
]

The proof of  will also use the following consequence of the Bolzano-Weierstrass theorem.

#lemma(title: "A bounded sequence is convergent if and only if it has a unique accumulation point")[
  
  Let $seqfull({x_k}, k>=0) subset.eq RR^p$ be a bounded sequence. Then $x arrow.r ell$ if and only if $ell$ is the unique accumulation point of ${x_k}$.
]<boundeduniqueacummulationpoint>

#proof[
  $[arrow.r.double]$: Since $x_k$ is convergent, there can only be one accumulation point $ell$---otherwise you could find a neighbourhood outside of $ell$ that is visited infinitely often, which would contradict $x_k arrow.r ell$. $[arrow.l.double]$: Towards a contradiction suppose that $x arrow.r.not ell$. Then, there exists $x_gamma(k)$ and $r > 0$ such that $norm(x_gamma(k) - ell) > r$ for all $k >=0$. ${x_gamma(k)}$ is a bounded sequence, hence by BW it has a convergent subsequence with an accumulation point different to $ell$.$arrow.zigzag$ Hence $x arrow.r ell$.
]

= Theorem 3.5

The high-level strategy of the proof is as follows.

1.  Rewrite NAG using @reformulation.
2.  Use @boundedness to conclude that ${x_k}$ has at least one convergent subsequence (by Bolzano-Weierstrass). If ${x_k}$ has _exactly one_ convergent subsequence, then the proof is finished by @boundeduniqueacummulationpoint.
3.  Assume there are two accumulation points; the rest of the proof will show that these must coincide.
4. Use @potential to set up something of the form required by @convergence. Verify the hypothesis of @convergence using the definition of ${t_k}$ and standard analysis.
5.  Conclude that the two accumualation points must coincide.


#theorem(title: [Theorem 3.5 of @jang2026pointconvergencenesterovsaccelerated])[

]


#bibliography("../thesis.bib")

