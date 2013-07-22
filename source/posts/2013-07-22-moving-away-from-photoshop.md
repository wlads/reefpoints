---
layout: post
title: 'Shifting Away From Photoshop: We Are Not Doing It'
comments: true
author: 'Steven Trevathan'
twitter: 'strevat'
github: kidfribble
social: true
summary: 'Design process needs more design thinking, and less code.'
published: false
tags: design, design process
---

We’re not ready to make the shift from Photoshop, *yet*.

The internet doesn’t have the tools to replace Adobe’s Photoshop. Indeed, the times are a changin, but plain and simply put: our tools that aim to replace Photoshop today just suck. I’m not going to compare tools though; I’m going to talk to you about how good mental partitioning can help us design for the web today using the antiquated tools we’re stuck with.

##An Example & The Problem

A recent design project of ours began with the ambition of being completely browser based, skipping the use of Photoshop altogether. The benefits of having a usable front-end in place of static mockups were great: you could use your app as it was being designed and get a sense of the failure points before they’d become too ingrained in the experience. User testing could begin earlier. This is awesome. The method seemed perfect.

It was utterly, pathetically, disappointingly not. Not then, anyway, and here’s why: we were less focused on the user’s experience and more focused on the organization and creation of markup, styles, and script. We began (and ended) by thinking about and writing lines of html, css, and javascript. We were worried about front-end patterns, but the design patterns we were aiming to support weren’t identified yet. We introduced somewhat of a chicken and the egg problem, making our thinking more difficult and more sporadic than it should have been.

If you choose to do this, you’ll spend hours and hours tweaking your markup, all in the name of being able to feel and test your product as it’s created. You’ve become one person working the same number of hours, but now with a split focus. Depending on how you work, you may  partition your mind into 50% markup and 50% design. If we’re jumping back and forth between design and code, we’ll tire much faster and when it comes to quitting time we’ve done half the design thinking we normally would do. I don’t mean to imply that your product will be terrible, you’ll just spend a lot more time getting a complete idea of what you’re actually designing and building.

Because of the effort involved, the probability of dubbing something “good enough” before it’s ready is higher. This is just like quitting your jog earlier than you planned because “you’ve had enough exercise for the day”. It’s easy to trick yourself that something is good enough when in practicality it may not be. Better partitioning of your mental effort can avoid that.

##My Solution

We need to be better about partitioning our minds into design and implementation thinking. The [Pareto principle](http://en.wikipedia.org/wiki/Pareto_principle) has been useful in my mental partitioning. As a designer, my opinion is that my brain should be at least 80% on the user’s experience. The other 20% will be worried about implementation. That last 20% is where we discover all sorts of odd things in our user flows and UI’s and should actually solve most of our design problems. That’s where we learn how our design actually feels. What it’s true character or essence is.

For all intents and purposes this is what we’ve found works best for us *today*, starting with the basics and moving toward the pie:

###Design (80%)
* Client & user interviews
* Sketches & paper wireframes
* Selecting typefaces, grids, and colors [[1]](#footnote_1)
* Layout 3 or 4 pages, not “pixel-perfect”
* Rinse & repeat, focusing on the core of the product and spiral outward, sharing as rapidly as you can
* Develop designs needed for user-testing & proving concepts

###Design During Development (20%)
* Highlight the design patterns & commonalities between your designs and structure html and css accordingly
* Get a sense of how your UI & navigation feels, improve and iterate as necessary

Using the Pareto principle, we’ll take each step of our design process to 80%, collect feedback, iterate, test as necessary, and then move on to the next. We’ll come back later and spend the remaining 20% working on UI improvements and conduct any additional tests we think necessary.

Your process will very likely look different than our's, and that's OK. You'll need to formulate your process around your core talents and purpose. The truth is, of course, that design is never done and the times will always change. We believe the first step is focusing on getting to 80%.

<span class="italic"><a name="footnote_1"></a>*[1]* We use [Typecast](http://typecast.com/) for testing and discovering typography, [Gridset](https://gridsetapp.com/) for designing our grid, and sometimes [Kuler](https://kuler.adobe.com) for selecting colors but more often than not: Photoshop.</span>