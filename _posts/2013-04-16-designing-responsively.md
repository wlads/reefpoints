---
layout: post
title: "Designing Responsively"
comments: true
author: "Amanda Cheung"
github: acacheung
category: design
social: true
summary: "What I've learned by making a few responsive websites."
published: false
---

## Don't fight the web, work with it ##

Designs that can be implemented purely through CSS is where it's at. A leather texture here and a complex drop shadow there can fight the web instead of working with it. Images that aren't flexible for varying widths can lead to unnecessary work-arounds just to get things to look right. In the way that form should follow function, allow implementation to inform design. I try and rethink certain design elements if it needs too much extra code to make it work.

## Mobile first ##

When possible, I like to implement designs mobile first so I can create a base set of styles and from there, add more as I implement larger width sizes. Once I build out my base mobile styles, I add media queries making sure no styles within queries override each other.

So less of this:

.speaker-info
  @media (max-width: 600px)
    ...
  @media (max-width: 800px)
    ...
  @media (min-width: 800px)
    ...

Rather this:

.speaker-info
  @media (max-width: 600px)
    ...
  @media (min-width: 600px) and (max-width: 800px)
    ...
  @media (min-width: 800px)
    ...

It might not seem like a big difference, but the first one would load lines of CSS that aren't going to be rendered by the browser. Also it would matter if the order of media queries were rearranged in the first set, but not in the second set. Media queries shouldn't overlap unless the styles nested under it should all be rendered.

## CSS / SASS code smells ##

Like the media queries situation, I try to only apply styles where they are necessary, meaning as few overrides and undoing stylistic declarations as possible. For more info on this topic, check out Harry Robert's post at http://csswizardry.com/2012/11/code-smells-in-css/. I make good use of the :not() selector and nth-child recipes (http://css-tricks.com/useful-nth-child-recipies/) to help me avoid margin: 0; or padding: 0; declarations. I find that this makes future editing easier because declarations aren't competing / trumping with each other.

## Decoupling styles from HTML ##

I like using Jonathan Snook's SMACSS guidelines (http://smacss.com/), but there are other frameworks out there as well. The entire book provides many helpful tips on process, but one thing I want to point out is how SMACSS enforces the separation between HTML and CSS. If I were to rearrange the order of any HTML elements, their respective styles should not break. This is really important in responsive design because it's common for layouts to shift around. Lots of nesting makes CSS dependent on HTML structure, which is what we are trying to step away from.

## Some little tips: ##

∙ Use box-sizing: border box; to make widths look less like magic numbers.
∙ Chrome and Safari's browser widths don't go narrow enough (unless dev tools are docked to the right) to test for many mobile screens. Test across many devices or simulators.
∙ Try making design elements out of CSS (with the before and after pseudo classes as well as the content property). If that's not possible try SVG. Only if that's not possible then go to PNG/JPG/whatever. The more easily editable, the better!