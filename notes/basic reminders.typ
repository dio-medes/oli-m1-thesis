#import "../preamble.typ": *
#show: notes

= Basic Reminders
_Collection of some relevant basic notions_

== $O(.)$ and $o(.)$
If $f, g : RR -> RR^*_+$, then
$
  f(x) = O(g(x)) text("means") exists x_0 in RR space exists C in RR >= 0 : space f(x) / g(x) <= C text("for") x > x_0
$
That is, $f(n)$ is _eventually_ bounded by $g(x) times$ a constant. One basic example is $f in O(1)$, which means $f$ is eventually bounded. If $f, g : NN arrow.r RR_+$, then eventually bounded and bounded coincide. For sequences, one relevant example is a statement of the form $f in O(1\/n)$. This means that $f(n)$ is at most $1/n times$ a constant -- by the squeeze law, this means that $f(n) arrow.r 0$ at least as fast as $1\/n$. Put another way, if $f(n)$ represents an _error_ at iteration $n$, then $f in O(1\/n)$ means that the error is _at most_ $1\/n times$ a constant.

There are a few basic rules about the classes of $O(g(n))$ functions/sequences that are important to recall:

1. $f in O(g(n))$ and $g(n) <= h(n)$ $arrow.double.r$ $f in O(h(n))$.
2. $alpha in RR$ and $f in O(g(n))$ $arrow.double.r$ $alpha f in O(g(n))$. ($alpha$ gets absorbed into the $O(.)$ 
3. $f, g, in O(h(n)) arrow.double.r f + g in O(h(n))$ ($max(C_1, C_2)$)

If $f, g : RR arrow.r RR^*_+$, then 
$
  f(x) = o(g(x)) text("means") forall epsilon > 0 space exists x_0 in RR :f(x)/g(x) < epsilon text("for") x > x_0
$
which is equivalent to saying that $f(x)\/g(x) arrow.r 0$ as $x arrow.r infinity$. That is, $f arrow.r 0$ _strictly faster_ than $g(x) arrow.r 0$.

If $f in o(g)$, then $f in O(g)$