---
layout: post
title: "Shifting Away From Static Design: I'm Not Doing It Yet"
comments: true
author: 'Steven Trevathan'
twitter: 'strevat'
github: kidfribble
social: true
summary: 'Design process needs more design thinking, and less code.'
published: false
tags: design, design process
---

I'm not ready to make the shift from static design, *yet*.

I primarily use Adobe’s Photoshop for design work (i.e. I create static designs), and the internet really doesn’t have the tools for me to replace it. The times are changing, but our modern tools that aim to replace Photoshop suck. Soon, I’m sure, something like [Webflow](http://www.webflow.com/) will come along and throw the third or fourth shovel of dirt on Photoshop’s casket.

I’m not going to compare tools though; I’ll compare two modern methodologies of design and explain how better mental partitioning can help us design for the web today using the tools we have.

## An Example

We completed a recent project with the ambition of the design stage being completely browser based, skipping the use of Photoshop altogether. The benefits of having a usable front-end in place of static mockups are great: you can use your app as it is being designed and get a sense of the failure points before they become too ingrained in the experience. User testing can begin earlier. This is awesome. From the outside, designing solely in the browser seemed perfect.

You guessed it: I was wrong. It wasn't right for us then, nor for that project. We were less focused on the user’s experience and more focused on the organization and creation of markup, styles, and script. We began (and ended) by worrying about and writing lines of html, css, and javascript. We were worried about front-end patterns, but the design patterns we were aiming to support weren’t fully identified yet. We introduced somewhat of a chicken and the egg problem, making our thinking more difficult and more sporadic than it should have been.

For us this meant spending hours and hours tweaking markup, all in the name of being able to feel and test the product as it was created. In some cases, for sure, this can be worth it. In our case we even had plenty of existing design assets to base our web interface off of, but that project had called for too many largely different iterations (and mixed opinions) on multiple designs.

I had become one person working the same quantity of hours split amongst two different focuses. I would estimate that I had partitioned my mind into 50% markup and 50% design (those figures would certainly change depending on your familiarity with markup and your particular project). With that kind of split, I would arrive at my conclusion to a design experiment at 50% the speed (or 200% the effort). Depending on your project, that might need to come quicker.

Designing in the browser does not mean your project will turnout poorly. Ultimately ours turned out fine in the end, but we did spend a lot more time getting a complete idea of what we were actually designing and building. Our clients got to use the product before they bought into the concept, which was great for them. For us that meant rebuilding the interfaces multiple times to meet the client's requirements, which was arduous and costly. For that project, it was as if we started designing a house by first laying the concrete foundation.

## My Solution

Because of the effort involved in designing in the browser, the probability of dubbing something “good enough” before it’s ready is higher. This is just like quitting your jog earlier than you planned because “you’ve had enough exercise for the day”. It’s easy to trick yourself that something is good enough when in practicality it may not be.

Good mental partitioning can avoid that. Enter: The [Pareto principle](http://en.wikipedia.org/wiki/Pareto_principle). This has been useful in my mental partitioning, and I urge you to read it about it as I’m sure it could help you in more ways than I’ll describe. My opinion is that, as a designer, my brain should be at least 80% on the user’s experience. The other 20% can be worried about implementation. In that last 20% we should be able to discover all sorts of odd things in our user flows and UI’s that we couldn’t have seen before and should solve most of our design problems. That’s where we learn how our design actually feels, and what it’s true character or essence is.

As I mentioned earlier, some people's familiarity with front-end languages or design software may differ, resulting in varying levels of worthiness of either method for that person or project. Designers are certainly more powerful when they understand and can wield the technologies used to implement their designs, but I don't however believe they're better off designing *by* implementing. The activities dilute the focus your mind should have.

For all intents and purposes this is what I’ve found works best for us *today*:

### Design (80%)
* Client & user interviews
* Sketches & paper wireframes
* Selecting typefaces, grids, and colors [[1]](#footnote_1)
* Layout 3 or 4 pages, not “pixel-perfect” (this is where static is perfect)
* Develop designs needed for user-testing & proving concepts
* Rinse & repeat, focusing on the core of the product and spiral outward, sharing as rapidly as you can

### Iterative Experience Development (20%)
* Highlight the design patterns & commonalities between your designs and structure html and css accordingly
* Get a clear sense of how your UI & navigation feels, improve the design as necessary (test, share, repeat)

Using the Pareto principle, we’ll take each step of our design process to 80%, collect feedback, iterate, test as necessary, and then move on to the next step. At the end of each step we’ll come back and spend the remaining 20% working on UI improvements and conduct any additional tests we think necessary before moving on to another piece.

Your process will very likely look different than our's, and that's OK. You'll need to formulate your process around your core talents and purpose. The truth is, of course, that design is never done and the times will always change. I believe the first step is focusing on getting to 80%, and that it's best taken by letting your designers be free of their tools.

<span class="italic"><a name="footnote_1"></a>*[1]* We use [Typecast](http://typecast.com/) for testing and discovering typography, [Gridset](https://gridsetapp.com/) for designing our grid, and sometimes [Kuler](https://kuler.adobe.com) for selecting colors but more often than not: Photoshop.</span>
