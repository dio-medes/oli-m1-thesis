#import "../preamble.typ": *
#show: notes

#set page(flipped: true)

#table(
  columns: (1fr, 2fr, 4fr),
  table.header(
    [*Name*], [*Contribution*], [*Discussion*],
  ),
  // row
  [Nesterov 1983], [Introduced NAG], [understand the motivation behind the $t$ specification - it is the root of a particular quadratic],
  // row
  [Ryu, E. K. 2025],
  [It was known since Nesterov's paper in 1983 that $(x_k)$ from NAG converged in value:
  $
    f(x_k) - inf f <= O(1\/k^2)
  $
  but it was not known whether $x_k arrow.r x_infinity in arg min f$. This paper shows that the answer is yes.
  Why does point convergence matter? I doubt it matters in practice.
  ],
  [
    Just to be concrete about what was unknown prior to this paper, Nesterov proved that with NAG $(x_k)$ $f(x_k) - inf f arrow.r 0$ at n $O(1\/n^2)$ rate. But a statement about the function converging in value does _not_ imply that the iterates converge in value.
  ],
  // row
  [Someone from Ryu], [proved the theorem with the bound 3/32], [],
  // FISTA
  [someone], [FISTA], [it does something differently and already had point convergence]
)