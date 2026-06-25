#import "preamble.typ": *
#show: notes
#set page(numbering: "1")

#set math.equation(numbering: "(1)")
#let nonum(eq) = math.equation(block: true, numbering: none, eq)
#set math.equation(supplement: none)

#title("Thesis scaffold")

=== Introduction / Research Question

The minimisation of smooth, convex functions by an iterative, first-order method at an $O(1\/k)$ rate is a well-known result, with origins dating back to Cauchy @cauchy1847methode. The key device, known as _gradient descent_, has several desirable properties, including so-called _point convergence_---that the iterates themselves converge as the number of iterations increases indefinitely. For some time, it was unknown whether it was possible to do better than the $O(1\/k)$ rate with a first-order method. The answer eventually came in the affirmative from Nesterov's seminal paper @nesterov83. In the decades since, a large and diverse body of results on related problems has been established. However, whether point convergence was retained under Nesterov's acceleration scheme remained an open question until very recently, when researchers were again able to answer in the affirmative, with a proof obtained with the assistance of a large language model @ryu2026. The following traces a narrow path through the literature, with the goal of providing a tightly-focused context for this recent proof.

=== Minimisation of smooth, convex functions

- Set up the main problem of interest.
    - Minimisation of real-valued $f: RR^n arrow.r RR$, where $f$ is continuous, convex, and #Lsmooth. Briefly in the discussion of the FISTA acceleration method the assumption of #Lsmoothness will be relaxed (allowing for the sum of an #Lsmooth and non-smooth but well-behaved in other ways function), otherwise all objective functions are #Lsmooth
    - Define concepts: convex, #Lsmooth
    - Important basic results on convexity: local minima are global minima, only need to run algorithm once. Note that, even though it is not really of interest in this review, the extra structure provided by strongly convex $f$ gives unique minimiser.
- Show/explain very quickly why an iterative algorithm is needed, even when the function is convex and smooth (i.e. it is very difficult to solve $nabla f (x) = 0$ for an arbitrary $f$) - can even cite the Cauchy paper again here.
    - In general it is a set of $n$ non-linear simultaneous equations that are very difficult to solve, even for very natural problems.
    - Even when $f$ is quadratic and therefore $nabla f$ generates a set of linear simultaneous equations, the cost of inverting the matrix can be prohibitive since the cost is $O(n^3)$ @farebrother1988.
    - When $f$ has a non-smooth component, this can be even more difficult in general. See later discussion of FISTA.

=== The plain gradient descent method
- Description of of the method, gradient step, it is the solution to a particular optimisation problem, etc.
    - Heuristics on why it could be expected to work
    - Important basic results on #Lsmoothness: the quadratic upper bound
    - *Theorem* stating the value convergence rate and point convergence for convex, #Lsmooth functions.
        - Use proof via Lyapunov functions @bansal2019

=== Nesterov-based Accelerated gradient methods

- Over time there have been many acceleration methods proposed. Cite literature reviews of these methods, such as @dAspremont2021. In this thesis we are only concerned with two related acceleration methods, both of which are connected to the core break-through by Nesterov: Nesterov's algorithm itself @nesterov83, and FISTA, which allows for a slight relaxation of the #Lsmoothness assumption that makes it more applicable to certain applications @beckteboulle2009.

- Nesterov gradient desecent
    - Definition of the method from @ryu2026
    - Theorem on the value convergence rate for convex, #Lsmooth functions
        - Make sure the proof is unified in its approach with that of the plain gradient descent function, i.e. use the Lyapunov function approach
    - Perspectives on Nesterov method and the fundamental inequality $t_n^2 - t_n <= t_(n-1)^2$.

- FISTA
    - A generalisation of Nesterov gradient descent that allows for the inclusion of a non-smooth term that has a certain property
    - Builds on the ideas of Nesterov gradient descent
    - ISTA
        - Proximal operator
        - Fixed-point iterations, fixed point theorem
    

=== Complexity in convex optimisation

- Define complexity in this context.
    - Problem classes in terms of classes of functions and classes of oracles @nemirovsky1983
- Nesterov Theorem 2.1.7 @nesterov2004 that shows that Nesterov's Accelerated method achieves

=== Point convergence

- Definition of point convergence in this context, we mean that the iterates $x_k arrow.r x_infinity$ as $k arrow.r infinity$ and $x_infinity in argmin f$.

- Provide a simple explanation of why point convergence is a desirable property.x

- FISTA proof from @chambolledossal2025
    - Describe the proof and the key contributions
    - Note that this proof does _not_ prove the point convergence of FISTA itself

- Nesterov proof from @ryu2026
    - Explain the key innovation of this proof versus the FISTA proof - why did the FISTA proof not apply for Nesterov? What was the key innovation needed

=== Extensions and variations

- Performance Estimation Problem
    - Optimised gradient descent
        - The point convergence of optimised gradient descent follows from the proof found for Nesterov's accelerated gradient method.
- Continuous time
    - Description of the Nesterov ODE

=== Conclusion and open questions




#bibliography("thesis.bib")