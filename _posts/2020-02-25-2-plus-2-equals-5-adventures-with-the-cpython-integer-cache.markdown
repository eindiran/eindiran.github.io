---
layout: post
title:  "2 + 2 = 5: Adventures with the CPython integer cache"
date:   2020-02-25
tags: python
categories: articles
---

An interesting quirk of CPython (one which has caused debugging woes for many a Python-newcomer) is that the CPython interpretter preallocates the integers `-5` through `256` inclusive in a special area of memory, often called the "integer cache" or the "small integer cache". What this means is that every time you assign a variable to an integer in that range, the variable is a reference to that integer's location in the cache. We can verify this by using [`getrefcount`](https://docs.python.org/3/library/sys.html#sys.getrefcount)^[0]^ from the `sys` package:

```python3
>>> import sys
>>> sys.getrefcount(256) # Get the baseline count for 256
23
>>> x = 256              # Increment the count by 1
>>> sys.getrefcount(256)
24
>>> y = 256              # Increment it by 2
>>> z = 256
>>> sys.getrefcount(256)
26
>>> sys.getrefcount(257) # Now get the baseline for an integer not in the cache
3
>>> a = 257
>>> sys.getrefcount(257) # The count didn't go up!
3
>>> b = 257
>>> sys.getrefcount(257)
3
```
Each time we assign a variable to an integer in range, the reference count for the integer goes up. But when we're assigning a variable to an integer outside the range, it has no effect on the reference count of the integer since each variable points to a distinct location in memory.

Stated in the simplest terms, when you set `x = 1` and `y = 1`, both `x` and `y` point to the same place in memory. We can see that that is true, using `id` and `is`, since `id` shows memory address and `is` shows object equality:

```python3
x = 256
y = 256
x == y          # True
x is y          # True
id(x) == id(y)  # True


a = 257
b = 257
a == b          # True
a is b          # False!
id(a) == id(b)  # False!
```

The integer cache is used by the CPython interpretters for both Python 2 and 3 (though I suppose we are now not supposed to acknowledge that 2 even exists), but today we'll just be using the CPython 3.6 interpretter. Take a look at [the official docs](https://docs.python.org/3/c-api/long.html#c.PyLong_FromLong) for the Python C API: it points out that the integer cache is just implemented as an array of integer objects, so in principle it is possible to change the value of each integer in the array. From the docs:

> The current implementation keeps an array of integer objects for all integers between -5 and 256, when you create an int in that range you actually just get back a reference to the existing object. So it should be possible to change the value of 1. I suspect the behaviour of Python in this case is undefined. :-)

This made me curious: what does happen when you change the value of the integers stored in the integer cache? What kinds of abberant and unexpected behavior will we see? What if we changed _all_ of them?

### Part One: Figuring out the plan of attack

If we want to figure out the answers to the above questions, we should start by running some experiments. I generally like just throwing things at the wall and seeing what sticks, so let's just blindly dive in.

#### Experiment 1 -- The size of values in the integer cache

My first experiment was to use `id` to examine the address of each `int` in the integer cache:

```python3
>>> id(1)
10914496
>>> id(2)
10914528
>>> id(2) - id(1)
32
>>> id(3) - id(2)
32
>>> id(4) - id(3)
32
```

You'll notice that they are each offset by 32 bits, which we should expect since they are each a [`long`](https://en.wikipedia.org/wiki/Integer_(computer_science)).

#### Experiment 2 -- Abusing `ctypes`

CPython is implemented in C under-the-hood, and provides the package `ctypes` to interact with a lot of interpretter internals from within the interpretter. Let's abuse some `ctypes` tools to see what we can do. The bits from `ctypes` that we need:

* [`POINTER` ](https://docs.python.org/3/library/ctypes.html#ctypes.POINTER) - a [factory function](https://en.wikipedia.org/wiki/Factory_(object-oriented_programming)#Terminology) that takes a type and creates a pointer of that type. For example, `POINTER(c_ulong)` creates a `ctypes` unsigned long pointer.
* [`addressof`](https://docs.python.org/3/library/ctypes.html#ctypes.addressof) - a function that returns the address of a `ctypes` object. It behaves in the same way that `id` does, but only works for `ctypes` objects.
* [`cast`](https://docs.python.org/3/library/ctypes.html#ctypes.cast) - a function that takes a memory address and a [`ctypes` pointer type]((https://docs.python.org/3/library/ctypes.html#pointers)) and returns a pointer of the specified type to the address. Abusing this function is one of the easiest ways to get CPython to segfault.

Our next step will be to use `cast` to print the value of a memory location as the `ctypes` `c_long` type, which is a 32-bit integer.

```python3
>>> from ctypes import *
>>> print(cast(id(1), POINTER(c_long))[0])
1621
>>> print(cast(id(2), POINTER(c_long))[0])
525
```

Okay. That is definitely not what we expected to see (well, at least it wasn't what I expected to see - maybe your mental model of the CPython interpretter is much better than mine). Let's back up for a second, and take a look at what's going on here with the `cast` call here. I constructed this example, which demonstrates that in principle using `cast` like we did above should work:

```python3
>>> from ctypes import *
>>> x = (c_ulong * 5)() # Create an array of unsigned longs
>>> x[0] = 18
>>> x[1] = 19
>>> x[2] = 33
>>> x
<__main__.c_ulong_Array_5 object at 0x7fd97b051c80>
>>> cast(x, POINTER(c_ulong))[0]
18
>>> cast(x, POINTER(c_ulong))[1]
19
>>> cast(x, POINTER(c_ulong))[2]
33
```

#### Experiment 3 -- Looking for an offset

So in principle we are doing the right thing with `cast`; perhaps the issue is that we have the wrong offset. To figure out what the right offset might be, I took a look at each value between `0` and `32`, and tried to use that value as the offset:

```python3
>>> start = 0
>>> end = 32
>>> for h in range(start, end + 1):
...     print("{}: {}".format(h, cast(id(1) + h, POINTER(c_long))[0]))
... 
0: 850
1: -9223372036854775805
2: -3350678122763649024
3: -7146790396171911168
4: 44140444052881408
5: 172423609581568
6: 673529724928
7: 2630975488
8: 10277248
9: 72057594037968081
10: 281474976710812
11: 1099511627776
12: 4294967296
13: 16777216
14: 65536
15: 256
16: 1
17: 72057594037927936
18: 281474976710656
19: 1099511627776
20: 4294967296
21: 16777216
22: 65536
23: 256
24: 1
25: 8142508126285856768
26: 31806672368304128
27: 124244813938688
28: 485331304448
29: 1895825408
30: 7405568
31: 28928
32: 113
```

So there are two `1` values in there, at offset `16` and offset `24`. Let's take a look at `2` and `3` and hopefully a pattern will emerge:

```python3
>>> for h in range(start, end + 1):
...     print("{}: {}".format(h, cast(id(2) + h, POINTER(c_long))[0]))
... 
0: 115
1: -9223372036854775808
2: -3350678122763649024
3: -7146790396171911168
4: 44140444052881408
5: 172423609581568
6: 673529724928
7: 2630975488
8: 10277248
9: 72057594037968081
10: 281474976710812
11: 1099511627776
12: 4294967296
13: 16777216
14: 65536
15: 256
16: 1
17: 144115188075855872
18: 562949953421312
19: 2199023255552
20: 8589934592
21: 33554432
22: 131072
23: 512
24: 2
25: 3746994889972252672
26: 14636698788954112
27: 57174604644352
28: 223338299392
29: 872415232
30: 3407872
31: 13312
32: 52
>>> for h in range(start, end + 1):
...     print("{}: {}".format(h, cast(id(3) + h, POINTER(c_long))[0]))
... 
0: 54
1: -9223372036854775808
2: -3350678122763649024
3: -7146790396171911168
4: 44140444052881408
5: 172423609581568
6: 673529724928
7: 2630975488
8: 10277248
9: 72057594037968081
10: 281474976710812
11: 1099511627776
12: 4294967296
13: 16777216
14: 65536
15: 256
16: 1
17: 216172782113783808
18: 844424930131968
19: 3298534883328
20: 12884901888
21: 50331648
22: 196608
23: 768
24: 3
25: 4611686018427387904
26: 18014398509481984
27: 70368744177664
28: 274877906944
29: 1073741824
30: 4194304
31: 16384
32: 64
```

So it looks like our offset might be `24`/`0x18`. Let's test that for each value:

```python3
>>> for x in range(-5, 256 + 1):
...     y = cast(id(x) + 0x18, POINTER(c_long))[0]
...     print("x: {0} --> {1}".format(x, y))
...     assert abs(x) == y
... 
x: -5 --> 5
x: -4 --> 4
x: -3 --> 3
x: -2 --> 2
x: -1 --> 1
x: 0 --> 0
x: 1 --> 1
x: 2 --> 2
x: 3 --> 3
x: 4 --> 4
x: 5 --> 5
...
x: 254 --> 254
x: 255 --> 255
x: 256 --> 256
```

#### Experiment 4 -- Changing a value in the integer cache

Aha! It looks like we've found the correct offset. Now let's just try dumbly assigning a value to a random integer in that range:

```python3
>>> cast(id(13) + 0x18, POINTER(c_long))[0] = 1
>>> 13 + 1
2
```

Awesome, now we're getting somewhere. Let's see if we can finally make [Big Brother's math](https://en.wikipedia.org/wiki/2_%2B_2_%3D_5) correct:

```python3
>>> cast(id(5) + 0x18, POINTER(c_long))[0] = 4
>>> 2 + 2 == 5
True
```

There are still a lot of our original questions left unanswered which we'll try to tackle in an upcoming post. More on the Python integer cache to come.
