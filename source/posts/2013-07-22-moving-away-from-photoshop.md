---
layout: post
title: "Shifting Away From Photoshop: I'm Are Not Doing It Yet"
comments: true
author: 'Steven Trevathan'
twitter: 'strevat'
github: kidfribble
social: true
summary: 'Design process needs more design thinking, and less code.'
published: false
tags: design, design process
---

I'm not ready to make the shift from Photoshop, *yet*.

The internet doesn’t have the tools to replace Adobe’s Photoshop. Indeed, the times are a changin, but plain and simply put: our tools that aim to replace Photoshop today just suck. I’m not going to compare tools though; I’m going to talk to you about how good mental partitioning can help us design for the web today using the antiquated tools we’re stuck with.

##An Example & The Problem

A recent design project of ours began with the ambition of being completely browser based, skipping the use of Photoshop altogether. The benefits of having a usable front-end in place of static mockups are great: you can use your app as it is being designed and get a sense of the failure points before they become too ingrained in the experience. User testing can begin earlier. This is awesome. From the outside, designing solely in the browser seems perfect.

It was not. Not then, anyway. We were less focused on the user’s experience and more focused on the organization and creation of markup, styles, and script. We began (and ended) by thinking about and writing lines of html, css, and javascript. We were worried about front-end patterns, but the design patterns we were aiming to support weren’t identified yet. We introduced somewhat of a chicken and the egg problem, making our thinking more difficult and more sporadic than it should have been.

For us this meant spending hours and hours tweaking markup, all in the name of being able to feel and test the product as it was created. In some cases, for sure, this can be worth it. In our particular case I had become one person working the same quantity of hours split amongst two different focuses. I would estimate that I had partitioned my mind into 50% markup and 50% design (those figures would certainly change depending on your familiarity with markup and your particular project). With that kind of split, I would arrive at a conclusion to a design experiment at 50% the speed (or 200% the effort). Depending on your project, that might need to come quicker.

Designing in the browser does not mean your project will turnout poorly. Ultimately ours turned out fine in the end, but we did spend a lot more time getting a complete idea of what we were actually designing and building. Our clients got to use the product before they bought into the concept, which was great for them. For us that meant rebuilding the interfaces multiple times to meet the client's requirements, which was arduous and costly. For that project, it was as if we started designing a house by first laying the concrete foundation.

##My Solution

I believe that because of the effort involved, the probability of dubbing something “good enough” before it’s ready is higher. This is just like quitting your jog earlier than you planned because “you’ve had enough exercise for the day”. It’s easy to trick yourself that something is good enough when in practicality it may not be. Good mental partitioning can avoid that.

The [Pareto principle](http://en.wikipedia.org/wiki/Pareto_principle) has been useful in my mental partitioning. My opinion is that, as a designer, my brain should be at least 80% on the user’s experience. The other 20% will be worried about implementation. That last 20% is where we discover all sorts of odd things in our user flows and UI’s that should actually solve most of our design problems. That’s where we learn how our design actually feels. What it’s true character or essence is.

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