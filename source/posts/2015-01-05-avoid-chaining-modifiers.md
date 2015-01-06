---
layout: post
title: 'BEM Tips: Avoid Chaining Modifiers'
twitter: 'acacheung'
github: 'acacheung'
author: 'Amanda Cheung'
tags: css
social: true
comments: true
published: true
---

At DockYard, we use the BEM methodology for naming our CSS classes. BEM
stands for Block, Element, Modifier and is a front-end development
technique that suggests a class naming convention for your HTML elements. If
you aren&rsquo;t already familiar with BEM, it would be helpful to take a look at
[Harry Robert&rsquo;s MindBEMding blog post](http://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/)
and the [BEM website](https://bem.info/) first.

When I started looking into using BEM, I thought it would definitely work well
for large web applications. The more rules we could put in place
regarding naming conventions, the better. What I didn&rsquo;t understand
was what to do when an element could be considered an element of a block *or* a
modifier. If I had a button that was in the footer and it was styled differently
than other buttons in the website, should it be named `.footer__button`
or `.button--footer`? Arguments could be made for both sides, so is one better
than the other?

After trying out both ways, `.footer__button` proved more scalable because
this rule could be consistently applied in more situations. Could there
be more types of buttons in the footer?
If there are also social buttons in the footer, our choices now become
`.footer__button--social` or `.button--footer--social`. In the second one, is social modifying
footer and footer modifying button? Or is social modifying button as
well? To avoid confusion, I would call it `.footer__button--social`
and not chain my modifiers. This doesn&rsquo;t mean we
shouldn&rsquo;t use multiple modifiers in a class name at all.
`.person--female__hand--right` is still fair game. It&rsquo;s clear that female
is modifying person and right is modifying hand.

## TL;DR
If I had an element that could potentially be either an element of a
block or modifying an element, the latter is better because
chaining modifiers can be confusing.
