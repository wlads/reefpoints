---
layout: post
title: "Putting things next to things with Susy"
comments: true
author: Angelo Simeoni
github: cssboy
twitter: cssboy
social: true
summary: "The little grid framework that can"
published: false
tags: design
---

I've often lamented that one of the most challenging things to do on the front end is to put things next to other things. Things on top of things? Easy. Things by themselves? Piece of cake. This thing next to that thing? Things just got complicated.

Should you roll your own layout, coming up with and refining conventions, browser testing to make sure everything still works? Do you rely on a front-end framework and all of the cluttered, confusing markup that comes going from that route? 

What about something different? This is where Susy saves the day.

## The little framework that can

Susy is a grid framework for Compass. With Susy, you simply define your grid settings and start laying things out. If you want to come back and adjust your grid later, that's totally fine. Susy will recalculate all your layouts.

```css
$total-columns: 12
$column-width: 4em
$gutter-width: 1em
$grid-padding: $gutter-width
```

Two main mixins do the bulk of the lifting. These are 'container' and 'span-columns'. Container is used to define the container of the grid. Span-columns is applied to elements within a container context. The syntax is easy.

```css
.page
  +container
  article
    +span-columns(8, 12)
  aside
    +span-columns(4 omega, 12)
```

This makes '.page' the grid container. The article takes up eight of twelve columns, the aside the final (omega) four of twelve columns.

Susy really shines at figuring stuff out on its own. Say I wanted to have two columns of different widths with different padding for each column, both nested within the article above?

```css
article
  +span-columns(8, 12)
  .one
    +span-columns(3, 7, 1em)
  .two
    +span-columns(4 omega, 7, .5em)
```

Where did the seven columns come from? Susy doesn't care. They are within the context of the article. Susy will figure out the math and make seven columns. The third option is the column padding. Susy will do the math there too. Thanks, Susy!

## Susy, breakpoints and you

Susy is made to build responsive grids. The default layout is called 'magic'. It's a fixed width layout that fluidly scales if the viewport is smaller than the width of the grid. You can also opt for a fully fluid layout, or a static layout for pixel precision.

Any of these layouts can be further modified with the +at-breakpoint mixin. This mixin makes accessing media queries within the context of our grid simple and straightforward.

```css
.one, .two
  +at-breakpoint(30em)
    +span-columns(7, 7, .5em)
```

## The one true grid

Everything Susy does is within context of a grid. You can  define multiple grids, and nest these grids inside one another. You can define abritrary values within any context. Many useful features, such as push, pull, and bleed are there to make life even easier.

With all of this power comes some responsiblity. As with any tool, Susy just does what you ask it to do. It cannot explain  why your layout isn't working. If you try to put too many things inside a grid, your layout will break. I'd recommend taking Susy for a spin. It's really easy to [get started](http://susy.oddbird.net/guides/getting-started/).
