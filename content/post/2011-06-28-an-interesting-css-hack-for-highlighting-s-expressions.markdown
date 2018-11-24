---
author: Florent
date: 2011-06-28 21:57:13+00:00
draft: false
title: An interesting CSS hack for highlighting S-expressions
type: post
url: /blog/2011/an-interesting-css-hack-for-highlighting-s-expressions/
categories:
- Programming
tags:
- css
- lisp
---

The [Community-Scheme-Wiki](http://community.schemewiki.org/) has a pretty interesting way of highlighting lispy code

Scheme being a Lisp dialect, it makes sense to highlight the [S-expressions](http://en.wikipedia.org/wiki/S-expression), i.e. "things between parenthesis". The Community Scheme Wiki does exactly that. As you move your mouse over the code, it will highlight the s-expression you're in and the ones around in different colors, allowing you to quickly make sense of the code.

An example can be found on [this page,](http://community.schemewiki.org/?sicp-ex-2.42) which renders like this as you move your mouse:

[![basic highlighting](/blog/wp-content/uploads/2011/06/Sans-titre-1.jpg)
](/blog/wp-content/uploads/2011/06/Sans-titre-1.jpg)

[![half highlighting](/blog/wp-content/uploads/2011/06/Sans-titre-2.jpg)
](/blog/wp-content/uploads/2011/06/Sans-titre-2.jpg)

[![full highlighting](/blog/wp-content/uploads/2011/06/Sans-titre-3.jpg)
](/blog/wp-content/uploads/2011/06/Sans-titre-3.jpg)


How do they do this, you ask? Let's check the HTML:

```html
<span class="comment">;;; SAFE? tests if the queen in a file is safe from attack.</span>

<span class="paren">(<span class="keyword">define</span> <span class="paren">(safe? file board)</span>

    <span class="paren">(<span class="keyword">define</span> <span class="paren">(get-queen-by-file file board)</span>

        <span class="paren">(find-first <span class="paren">(<span class="keyword">lambda</span> <span class="paren">(queen)</span>

                <span class="paren">(= <span class="paren">(queen-file queen)</span> file)</span>)</span>

            board)</span>)</span>
```

(Tags linking to documentation were removed for clarity's sake)

Nothing particularly fishy going on here. We can only see that each S-expression is wrapped into a span of the paren class.

So what is that class? Let's dig into the CSS:

```css
/* The paren stuff */

/* Top level */

PRE.scheme > SPAN.paren:hover { background-color: #FFCFCF }

/* Paren level 1 */

PRE.scheme > SPAN.paren
> SPAN.paren:hover { background-color: #CFFFCF }

/* Paren level 2 */

PRE.scheme > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #CFCFFF }

/* Paren level 3 */
PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #CFFFFF }

/* Paren level 4 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #FFCFFF }

/* Paren level 5 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #FFFFCF }

/* Paren level 6 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren
> SPAN.paren:hover { background-color: #B4E1EA }

/* Paren level 7 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #BDEAB4 }

/* Paren level 8 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #EAD4B4 }

/* Paren level 9 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #F4D0EC }

/* Paren level 10 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #D0D9F4 }

/* Paren level 11 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren
> SPAN.paren:hover { background-color: #FFCFCF }

/* Paren level 12 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #CFFFCF }

/* Paren level 13 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #CFCFFF }

/* Paren level 14 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #CFFFFF }

/* Paren level 15 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #FFCFFF }

/* Paren level 16 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren
> SPAN.paren:hover { background-color: #FFFFCF }

/* Paren level 17 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #BDEAB4 }

/* Paren level 18 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #EAD4B4 }

/* Paren level 19 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #F4D0EC }

/* Paren level 20 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #D0D9F4 }

/* Paren level 21 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren
> SPAN.paren:hover { background-color: #FFCFCF }

/* Paren level 22 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #CFFFCF }

/* Paren level 23 */

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:hover { background-color: #CFFFCF }

PRE.scheme > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren > SPAN.paren
           > SPAN.paren > SPAN.paren > SPAN.paren
> SPAN.paren:before

/* extend here if more nestings are needed */
```

So they are actually using the fact that CSS can recognize whether a class is nested into the same class, and display it in a different manner for each level when you :hover over that span. The interesting part is that the browser also keeps the S-expressions under the current hovered one highlighted in their specific color.

Hats off!


