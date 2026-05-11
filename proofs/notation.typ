#set text(size: 14pt)

= Notation / Style

_Largely following the Boyd Convex Optimisation textbook_

The natural numbers $bb(N)$ are $\{0, 1, 2, 3, ...\}$ and $bb(N)^* = bb(N) \\ {0}$.

Let $p, q in bb(N)$.

The typical ambient space is $bb(R)^p$. Functions are generally $bb(R)^p arrow.r bb(R)^q$. The function definition is specified in the 'computer' style:
$
  f: bb(R)^p arrow.r bb(R)^q space text("describes the input/output spaces") \
  text("and") space #math.op("dom") f space text("denotes the domain of definition of") f(x)
$

$C^q (RR^p, RR)$ is the set of continuous functions $RR^p arrow.r RR$ with $q$ continuous partial derivatives.

If $x in bb(R)^p$, then without further information $x = (x_k)$, i.e., $x_k, k = 1, ..., p$ are usually its elements. $k$ is the first choice but, if other indices are required then $j, n, m, i$ are used (descending order of preference). Prefer $n, k$ if limits are taken. Sequences are usually denoted with ${x_k}$ and are always $k in NN$ without further information.

A typical set in $bb(R)^p$ is $A, B$ (try to avoid C as a set). Prefer $subset.eq$ rather than $subset$ unless the strict inclusion is important.

If a special index or point is required, use first $star$ as a subscript unless inconvenient. The subscript avoids writing $x^star^2$ or $(x^star)^2$ when you could just write $x_star^2.$ For example, $x_star in arg min f$ is typical notation.

