---
layout: post
title:  "A history of π approximations, Part One"
date:   2019-10-31
tags: bc math
categories: articles
---

_Note: this article uses MathJax and Javascript to render LaTeX into mathematical symbols, so this page may not display correctly with Javascript disabled._

I was reading John D. Cook's [article](https://www.johndcook.com/blog/2019/10/29/computing-pi-with-bc/) on approximating $$\pi$$ using the `bc` calculator and thought it would be fun to write a brief series of articles that fills in some of the historical approximations of $$\pi$$.
Since the article gave a `bc` command for calculating $$\pi$$ using [Machin's formula](https://en.wikipedia.org/wiki/John_Machin), I'll do something similar: for each approximation covered, I'll give a `bc` expression that computes it.

There have been a _lot_ of approximations of $$\pi$$, so I won't have time to hit them all over the course of this series, but I'll cover some of the most groundbreaking ones, which fundamentally changed how people thought about approaching the problem.
If you'd like to see a full chronology of $$\pi$$ approximations, check out [this article on Wikipedia](https://en.wikipedia.org/wiki/Chronology_of_computation_of_%CF%80).
For a more general discussion of approximating $$\pi$$, [this Wikipedia article](https://en.wikipedia.org/wiki/Approximations_of_%CF%80) gives a very good overview.

Let's jump right in!

### Approximation 1: $$\pi \approx (\frac{16}{9})^2 = \frac{256}{81}$$

This is one of the earliest known approximations of $$\pi$$, potentially beating out a Babylonian method for the earliest known approximation.

The Egyptian [Rhind Mathematical Papyrus](https://en.wikipedia.org/wiki/Rhind_Mathematical_Papyrus), dated to 1600 BC, uses the area of an octagon as an approximation of the area of a circle, with the implied approximation of $$\pi$$ being $$(\frac{16}{9})^2 = \frac{256}{81}$$.

However, [it is believed](https://www.davidhbailey.com//dhbpapers/pi-quest.pdf) that the method was in use as early ~2000 BC.
Most attempts at approximating $$\pi$$ throughout the ancient world for the next 1000 years would just default to `3`, so the Ancient Egyptians and Babylonians were really ahead of their time!

`bc` expression:

```bash
bc -lq <<< "scale=100;256/81"
3.160493827160493827160493827160493827160493827160493827160493827160\
4938271604938271604938271604938271
```

This result has an error of less than 1%, is accurate to one decimal place _and_ it set the accuracy record until 250 BC. Not too shabby!

### Approximation 2: $$\frac{223}{71} < \pi < \frac{22}{7}$$

This is a fun one: it is the earliest surviving method that is accurate to more to two decimal places, finally beating Approximation 1.
Archimedes drafted the method in his book [Measurement of a Circle](https://en.wikipedia.org/wiki/Measurement_of_a_Circle); it works by taking the area of a regular polygon inscribed on the inside of a circle and another regular polygon circumscribed around the outside of the circle, forming a lower and upper bound on the area of the circle respectively.
As Archimedes increased the number of sides on the 2 polygons, eventually landing on the 96-sided polygons he used for the final approximation, the smoothness of their sides better approximated the curve of the circle and their areas better approximated the area of the circumscribed circle.

![Regular polygons inscribing and circumscribing a circle](https://upload.wikimedia.org/wikipedia/commons/0/03/Archimedes_pi.png)

This technique for estimating $$\pi$$, now known as polygon approximation to a circle, turned out to be very important, as many later techniques were variations on the same theme, including [Viète's formula](https://en.wikipedia.org/wiki/Vi%C3%A8te%27s_formula), the work of [Ludolph van Ceulen](https://en.wikipedia.org/wiki/Ludolph_van_Ceulen) and the [Snell-Huygens method](https://ijpam.eu/contents/2003-7-2/4/4.pdf).
Future attempts at approximating $$\pi$$ that used polygon approximation to a circle generally relied on using an increasing number of sides to improve how closely the sides of the polygon resembled the curve of the circle; this ultimately culminated with [Christoph Grienberger's](https://en.wikipedia.org/wiki/Christoph_Grienberger) work in 1630, achieving 39 decimal places of accuracy.

Some Egyptologists have claimed that Ancient Egyptians during the [Old Kingdom](https://en.wikipedia.org/wiki/Old_Kingdom_of_Egypt) period, somewhere around 2686 - 2181 BC, used $$\frac{22}{7}$$ as an approximation of $$\pi$$, which would make this approximation older than Approximation 1, but the claim has been widely met with skepticism.

`bc` expression:

```bash
bc -lq <<< "scale=100;223/71"
3.140845070422535211267605633802816901408450704225352112676056338028\
1690140845070422535211267605633802

bc -lq <<< "scale=100;22/7"
3.142857142857142857142857142857142857142857142857142857142857142857\
1428571428571428571428571428571428
```

One final note about the upper bound, $$\frac{22}{7}$$: [3Blue1Brown](https://www.youtube.com/channel/UCsIg9WMfxjZZvwROleiVsQg) has [a video](https://www.youtube.com/watch?v=EK32jo7i5LQ) on a particular data visualization, where each number $$n$$ is plotted with polar coordinates such that $$(𝑟, \theta) = (n, n)$$. Early in the progression, there are these very beautiful spirals that you can see [here](https://math.stackexchange.com/questions/885879/meaning-of-rays-in-polar-plot-of-prime-numbers/885894).
These spirals emerge _precisely because_ $$\frac{22}{7}$$ _is a good but not perfect approximation of_ $$\pi$$! There are $$2\pi$$ radians per rotation, meaning that each multiple of 44 is just slightly off from lining up perfectly with the origin.
Over time, this results in a soft-turn which slowly reveals a galaxy-like spiral!

### Approximation 3: $$\pi \approx \sqrt{12}\sum^\infty_{k=0} \frac{(-3)^{-k}}{2k+1}$$

There was a long period where polygon approximation to a circle was the only gun in town and only incremental improvements to existing approaches were made, until the Indian astronomer [Madhava of Sangamagrama](https://en.wikipedia.org/wiki/Madhava_of_Sangamagrama) wrote _Mahajyānayana prakāra_, or "Methods for the great sines".
In _Methods_, Madhava explores 4 different infinite series, which are now known as the _Madhava-Leibniz series_; the fourth can be used to compute $$\frac{\pi}{4}$$.

As with Archimedes' method, the infinite series was a saltatory advancement: once it made an appearance, it became _the_ principle way to approach the $$\pi$$ approximation problem.
Interestingly, [Viète's formula](https://en.wikipedia.org/wiki/Vi%C3%A8te%27s_formula) which was mentioned before as a variation on the polygon approximation to a circle technique, is _also_ an example of an infinite series and thus belongs in this class of techniques as well.

The particular approximation we'll discuss here, $$\sqrt{12}\sum^\infty_{k=0} \frac{(-3)^{-k}}{2k+1}$$, is derived from an approximation of the circumference of a circle based on Madhava's arctangent series:

$$c = \sqrt{12 d^2} - \frac{\sqrt{12 d^2}}{3 \cdot 3} + \frac{\sqrt{12 d^2}}{3^2 \cdot 5} - \frac{\sqrt{12 d^2}}{3^3 \cdot 7}+ \quad \cdots$$

That gives us the following way to compute $$\pi$$:

$$\pi = \sqrt{12}\left( 1 - \frac{1}{3\cdot3}+\frac{1}{3^2\cdot 5} -\frac{1}{3^3\cdot 7} +\quad \cdots\right)$$

Madhava computed this series to the 21st term, getting an approximation of $$\pi$$ accurate to 10 decimal places, a huge improvement over earlier methods.

I've plotted below the convergence of Madhava's series to $$\pi$$ over 30 terms; as you can see, it converges very quickly.

![Madhava's convergence, 30 terms](/assets/madhavas_series_convergence_30terms.png)

Comparing Madhava's series with other early infinite series based approximations, you can see that it is hard to beat.
Here is Gregory's series, which will be discussed in a later post, this time to 100 terms:

![Gregory's series](/assets/gregorys_series_convergence_100terms.png)

(As a quick aside, Gregory's series was also discovered by Madhava!)

Here is a comparison of their rate of convergence as a graph:

![Gregory's vs Madhava's series](/assets/madhavas_gregory_comparison_final.png)

Because Madhava's series converges so quickly, the convergence graph isn't super helpful here, so here is a comparison of their error terms:

```
-------------------------------------------
          MADHAVA'S SERIES
-------------------------------------------
Madhava's series: 10 terms evaluated
Result: 3.141590510938080099642754
Error:  -0.000002142651713138819889153335
-------------------------------------------
Madhava's series: 100 terms evaluated
Result: 3.141592653589793238462643
Error:  -2.514224047465875468724305e-50
-------------------------------------------
Madhava's series: 1000 terms evaluated
Result: 3.141592653589793238462643
Error:  5.527147875260444560247265e-76
-------------------------------------------
Madhava's series: 10000 terms evaluated
Result: 3.141592653589793238462643
Error:  5.527147875260444560247265e-76
-------------------------------------------
Madhava's series: 100000 terms evaluated
Result: 3.141592653589793238462643
Error:  5.527147875260444560247265e-76
-------------------------------------------

-------------------------------------------
           GREGORY'S SERIES
-------------------------------------------
Gregory's series: 10 terms evaluated
Result: 3.041839618929402211135957
Error:  -0.09975303466039102732668612
-------------------------------------------
Gregory's series: 100 terms evaluated
Result: 3.131592903558552764307414
Error:  -0.009999750031240474155229145
-------------------------------------------
Gregory's series: 1000 terms evaluated
Result: 3.140592653839792925963597
Error:  -0.0009999997500003124990468804
-------------------------------------------
Gregory's series: 10000 terms evaluated
Result: 3.141492653590043238459518
Error:  -0.0000999999997500000031249999
-------------------------------------------
Gregory's series: 100000 terms evaluated
Result: 3.141582653589793488462643
Error:  -0.00000999999999975000000003125
-------------------------------------------
```

By the time you've evaluated 100,000 terms, the error is down to `5.527147875260444560247265e-76`.

`bc` expression:

```bash
bc -lq <<< "scale=100;sqrt(12) * (1 - 1/(3 * 3) + 1/(5 * 3^2) - 1/(7 * 3^3) + 1/(9 * 3^4) - \
1/(11 * 3^5) + 1/(13 * 3^6) - 1/(15 * 3^7) + 1/(17 * 3^8) - 1/(19 * 3^9) + 1/(21 * 3^10) -  \
1/(23 * 3^11) + 1/(25 * 3^12) - 1/(27 * 3^13) + 1/(29 * 3^14) - 1/(31 * 3^15) +             \
1/(33 * 3^16) - 1/(35 * 3^17) + 1/(37 * 3^18) - 1/(39 * 3^19) + 1/(41 * 3^20) -             \
1/(42 * 3^21))"
3.141592653587750080272844995033719113700901034593830150825410039077\
4718637397568223842560656065502291
```

It took me a long time to just to type that in; I can't imagine doing all of those computations by hand!

This article has a lot in it already, so I'll save the next few approximations for the coming articles. In case this piqued your interest and you'd like to play around with the convergence graph plotting code, you can find it here:

<script src="https://gist.github.com/eindiran/e110720fc16fe07ca11dae5b8c371308.js"></script>
