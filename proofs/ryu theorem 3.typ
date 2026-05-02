#set text(size: 14pt)

= Notation / Style

_Largely following the Boyd Convex Optimisation textbook_

The natural numbers $bb(N)$ are $\{0, 1, 2, 3, ...\}$ and $bb(N)^* = bb(N) \\ {0}$.

Let $p, q in bb(N)$.

The typical ambient space is $bb(R)^p$. Functions are generally $bb(R)^p arrow.r bb(R)^q$. The function definition is specified in the 'computer' style:
$
  f: bb(R)^p arrow.r bb(R)^q space text("describes the input/output spaces") \
  text("and") space #math.op("dom") f text("or") cal(D) space text("denote the domain of definition of") f(x)
$

If $x in bb(R)^p$, then without further information $x = (x_k)$, i.e., $x_k, k = 1, ..., p$ are usually it's elements. $k$ is the first choice but, if other indices are required then $j, n, m, i$ are used (descending order of preference). Prefer $n, k$ if limits are taken.

A typical set in $bb(R)^p$ is $A, B$ (rather than C). Prefer $subset.eq$ rather than $subset$ unless the strict inclusion is important.