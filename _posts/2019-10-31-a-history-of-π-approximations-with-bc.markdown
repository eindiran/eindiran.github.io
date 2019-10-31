---
layout: post
title:  "A history of π approximations with bc"
date:   2019-10-31
tags: bc math
categories: articles
---

_Note: this article uses MathJax and Javascript to render LaTeX into mathematical symbols, so this page may not display everything correctly with Javascript disabled._

I was reading John D. Cook's [article](https://www.johndcook.com/blog/2019/10/29/computing-pi-with-bc/) on approximating $$\pi$$ using the `bc` calculator and thought it would be fun to fill in some of the historical approximations of $$\pi$$, giving th `bc` expression for doing each approximation.

### Approximation 1: $$\pi \approx \frac{256}{81}$$

The Egyptian [Rhind Mathematical Papyrus](https://en.wikipedia.org/wiki/Rhind_Mathematical_Papyrus), dated to 1600 BC, uses the area of an octagon as an approximation of the area of a circle, with the implied approximation of $$\pi$$ being $$(\frac{8}{9})^2 = \frac{256}{81}$$.

`bc` expression:

```bash
bc -lq <<< "scale=100;256/81"
3.160493827160493827160493827160493827160493827160493827160493827160\
4938271604938271604938271604938271
```

This is an error of less than 1%, and accurate to one decimal place. Not too shabby!

### Approximation 2: $$\frac{223}{71} < \pi < \frac{22}{7}$$

This is a fun one: it is one of the earliest surviving methods that is accurate to more to two decimal places.
Archimedes drafted this approximation in his book [Measurement of a Circle](https://en.wikipedia.org/wiki/Measurement_of_a_Circle), by taking the area of a 96-sided regular polygon inscribed on the inside of a circle and a 96-sided regular polygon circumscribed around the outside of the circle, forming a lower and upper bound on the area of the circle itself respectively.
This technique for estimating $$\pi$$ is extremely important, as many later techniques are variations on this theme: most obviously [Viète's formula](https://en.wikipedia.org/wiki/Vi%C3%A8te%27s_formula).

Certain Egyptologists have claimed that ancient Egyptians during the [Old Kingdom](https://en.wikipedia.org/wiki/Old_Kingdom_of_Egypt) period, somewhere around 2686 - 2181 BC, used $$\frac{22}{7}$$ as an approximation of $$\pi$$, which would make this approximation older than approximation 1, but the claim has been widely met with skepticism.

`bc` expression:

```bash
bc -lq <<< "scale=100;223/71"
3.140845070422535211267605633802816901408450704225352112676056338028\
1690140845070422535211267605633802

bc -lq <<< "scale=100;22/7"
3.142857142857142857142857142857142857142857142857142857142857142857\
1428571428571428571428571428571428
```

### Approximation 3: $$\pi \approx \frac{377}{120}$$

This approximation was used in the 2nd century AD by Ptolemy and is the first approximation to be accurate to 3 decimal places.

`bc` expression:

```bash
bc -lq <<< "scale=100;377/120"
3.141666666666666666666666666666666666666666666666666666666666666666\
6666666666666666666666666666666666
```

We're now overshooting $$\pi$$ by a much smaller margin.

### Approximation 4: $$\pi \approx \sqrt{12}\sum^\infty_{k=0} \frac{(-3)^{-k}}{2k+1}$$

There was a long period where not many improvements were made on existing approximations of $$\pi$$, until the Indian astronomer [Madhava of Sangamagrama](https://en.wikipedia.org/wiki/Madhava_of_Sangamagrama#The_value_of_%CF%80_(pi)) wrote _Mahajyānayana prakāra_, or "Methods for the great sines".
In _Methods_, Madhava explores 4 different infinite series, which are now known as the Madhava-Leibniz series; the fourth can be used to compute $$\frac{\pi}{4}$$.

However, the approximation here, $$\sqrt{12}\sum^\infty_{k=0} \frac{(-3)^{-k}}{2k+1}$$, is derived from an approximation for the circumfrence of a circle based on Madhava's arctangent series:

$$c = \sqrt{12 d^2} - \frac{\sqrt{12 d^2}}{3 \cdot 3} + \frac{\sqrt{12 d^2}}{3^2 \cdot 5} - \frac{\sqrt{12 d^2}}{3^3 \cdot 7}+ \quad \cdots$$

That gives us the following way to compute $$\pi$$:

$$\pi = \sqrt{12}\left( 1 - \frac{1}{3\cdot3}+\frac{1}{3^2\cdot 5} -\frac{1}{3^3\cdot 7} +\quad \cdots\right)$$

Madhava computed this series to the 21st term, getting an approximation of $$\pi$$ accurate to 11 decimal places, a huge improvement over earlier methods.

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

It took me a long time to type that in; I can't imagine doing all of those computations by hand!

### Approximation 5: $$\lim_{n \rightarrow \infty} \prod_{i=1}^n \frac{a_i}{2} = \frac2\pi$$

Viète's formula

French mathematician François Viète published a treatise on mathematics entitled _Variorum de rebus mathematicis responsorum, liber VIII_ in 1593 which contained a series that converges to $$\pi$$:

$$\frac2\pi = \frac{\sqrt 2}2 \cdot \frac{\sqrt{2+\sqrt 2}}2 \cdot \frac{\sqrt{2+\sqrt{2+\sqrt 2}}}2 \cdots$$

Viète was able to use this formula to calculate $$\pi$$ to an accuracy of 9 digits.

$$\pi=\displaystyle\lim_{k\to\infty}2^k\sqrt{2-a_k},\, a_1=0,\, a_k=\sqrt{2+a_{k-1}}$$

`bc` expression:

```bash
bc -lq <<< "scale=100;2^10*sqrt(2 - sqrt(2 + sqrt(2 + sqrt(2 + sqrt(2 + sqrt(2 + sqrt(2 + sqrt(2 + sqrt(2 + sqrt(2))))))))))"
3.141591421511199973997971763740833955747562650086180797675232600350\
2178065320807236677421696406302720
```

### Approximation 5: $$\pi = 16 \arctan \frac{1}{5} - 4 \arctan \frac{1}{239}$$

This is the approximation used by John D. Cook in his article, originally from [John Machin](https://en.wikipedia.org/wiki/John_machin).
$$\pi = 16 \arctan \frac{1}{5} - 4 \arctan \frac{1}{239}$$
The derviation of this formula is given [here](https://en.wikipedia.org/wiki/Machin-like_formula#Derivation), for the $$\frac{\pi}{4}$$ case.

`bc` expression:

```bash
bc -lq <<< "scale=100;16*a(1/5) - 4*a(1/239)"
3.141592653589793238462643383279502884197169399375105820974944592307\
8164062862089986280348253421170680
```

One final aside: if you want a good laugh, read the Wikipedia article for the [Indiana Pi Bill of 1897](https://en.wikipedia.org/wiki/Indiana_Pi_Bill), a piece of legislation that would have "legislated the value of Pi" to be `3.2`.
