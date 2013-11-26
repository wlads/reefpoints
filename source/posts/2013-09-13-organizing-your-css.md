---
layout: post
title: "Organizing Your CSS"
comments: true
author: Amanda Cheung
googleplus: 108345108155845063298
github: acacheung
legacy_category: design
social: true
summary: "Using SMACSS and BEM in your stylesheets"
published: false
---

## Why is it important to organize your CSS? ##

For maintainability! If anyone else has to read your code or if you have to read your code after taking a break for two weeks, it helps to pay attention to how your CSS is organized. It saves a lot of time and headache for whoever is working on the project in the future.

## SMACSS file structure ##

[SMACSS](https://smacss.com/) by Jonathan Snook is a must-read for front-end designers and it classifies styles into five different categories:

1) Base styles, which includes the CSS reset and element defaults.
2) Layout styles, which includes the grid system and major component layout / positioning.
3) Module styles, which includes minor component styling.
4) State styles for different states of a module (e.g. collapsed state vs. expanded state of an accordion).
5) Theme styles for theming options (e.g. dark / light theme).

I like to give each of these its own stylesheet and have a directory for modules, with a stylesheet for each module (e.g a separate header, footer, button, form, aside file). Now, if I have an update for footer styles, I know what file to go to.

## SMACSS and BEM Naming Conventions ##

SMACSS also gives us naming conventions to follow for layout (class names prefixed by "l-") and state styles (class names prefixed by "is-") so when we see certain class names, we know the purpose of the styles that they tie to.

SMACSS does not give a special naming convention to modules, but depending on the situation, I use [BEM](http://bem.info/method/) to name certain module styles. I only use this when what I’m trying to style always has the same parent element throughout the website or application. BEM stands for "Block, Element, Modifier" and its class names look something like ``.footer__button--twitter``, which follows the syntax of ``.block__element--modifier``. Looks a little weird, right? It took me a minute to get used to it too. Basically, double underscore signifies a child element of the block and double dash signifies a modifier to the element within that block.

<img src='/images/wicked-good-ruby.jpg' alt='Wicked Good Ruby' style='width: 100%;'>

Here we have three buttons that belong in the footer and are unlike buttons on the rest of the page. So I would give each button a class of ``.footer__button``.  The twitter button has an icon specific to itself so it needs to be modified from ``.footer__button`` and take on additional styles from ``.footer__button—twitter``.

For more information on BEM naming conventions, check out <http://bem.info/method/definitions/>.

## Modular Principles ##

The most important concept from SMACSS is to decouple CSS from the HTML layout structure. Even though we can cast our styles using something like ``aside ul li a``, we shouldn’t because it is heavily reliant on the nesting of our HTML. If we take that list out of the aside, our styles will break. We want to be able to make edits in our HTML and not have to remember to go into our CSS to change our selectors.  We should only be going into our CSS if we need to make style changes.

Rather than ``aside ul li a``, we should give it a class so it isn’t tied to our HTML and so we can use that set of styles wherever else it should apply. Modularize! I’m always on the lookout for patterns that I can pull into reusable modules.

## Where to go from here? ##

If you aren’t sure where a certain style belongs in SMACSS, the most important thing is to be consistent. So give it your best guess and stick with that style throughout the project.

To get more granular, Harry Roberts does a great job pointing out several more ways to clean up your CSS in this blog post: <http://csswizardry.com/2012/11/code-smells-in-css/>.
