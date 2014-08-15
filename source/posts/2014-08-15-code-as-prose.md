---
layout: post
title: "Code as prose"
comments: true
author: "Michael Dupuis"
twitter: michaeldupuisjr
github: michaeldupuisjr
social: true
published: true
tags: opinion, engineering
---

[WordPress](http://wordpress.org) has a line in the footer of their site
that reads: "Code Is Poetry." It is a grand proclamation that thumbs
its nose at the notion that developers are just a bunch of grunts
building whatever comes down the pipeline from the higher-ups in
marketing. It connotes that developers are artists,
intellectuals, and creative-types.

"Code Is Poetry" goes hand in hand with the prevailing notion that Ruby is a
"beautiful" language. It's not uncommon to hear a Ruby developer confide that he
is a former Java developer, as though he's standing in an AA
eating. Then he'll opine over Ruby's "concise" or "expressive" syntax.
Because Ruby allows us to develop applications with fewer lines of code,
the prevailing wisdom is that less code is better. 

Senior developers often write great applications with fewer lines of code. They can refactor a class and distill a screen full of methods down to a handful; they can think abstractly and implement advanced design patterns; they just write code that creates less technnical debt and is more performant. This zen-like state of application development is something that all
developers should strive for, but it is not something we should be
exercising on most projects.

Senior developers should be building codebases with the baseline in
mind, not the upper rung. That is to say, if you're writing code that
the most junior, *competent* developer on your team will be tripped up
by, you're doing it wrong.

Lets extrapolate on this them that "Code is Poetry." Imagine that
instead of a developer, you're an writer. You're co-writing a new book
with "Bill"

Less code is better in the following situations:
* if you're going to be the only developer in the codebase
* if you know that the next developer to touch your code is of equal or
  greater skill as you
