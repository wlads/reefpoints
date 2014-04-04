---
layout: post
title: "Designing Within The Browser"
comments: true
author: 'Steven Trevathan'
twitter: 'strevat'
social: true
summary: 'Make room for accidental progress.'
published: false
tags: design, design process
---

I employ a solid range of design tools and although I’m spending some of my time designing in the browser, the ideal of designing *entirely* in that context is often unrealistic and stifling.

## Save time for discovery
Sometimes an accident leads to an interesting and useful discovery. In art and design this is especially true. In a browser, unfortunately, accidents don’t pleasantly surprise you in the way *”static”* designs may. In development an accident means broken code – plain and simple. You may stumble on a solution, but you’re not going to be surprised by a random glimpse of order and possibility in the muck of your own broken html. It’s broken until it’s fixed.

Such a quality of the web is necessary, but I don’t find it very helpful for discovering new solutions to visual or experience problems. In the early stages you become very focused on minute details when you should be thinking in broad strokes. In later stages you find yourself seeing larger visual problems and with less power to change it. In many ways, I find designing in the browser akin to designing in the dark.

There are plenty of browser based design tools attempting to free designers of heavy weights such as Photoshop and allow designers to work without learning advanced html and css. This is a positive direction, but I still haven’t seen the problem solved without losing the element of discovery. Instead of happy accidents, you may experience a gross misunderstanding between your intent, the front end code of the tool you’ve chosen, and the DOM. Maybe the tools will get better, and I’m sure they will, but I’m not optimistic they’ll be architected to facilitate discovery within the next few years.

For the time being my opinion is that, in terms of process, improvements in web standards and web technology aren’t going to change anything save for ensuring work may be completed in shorter order. We create tools (or products) and advance technology in order to *increase* efficiency and *improve* human capability. The computer added efficiency for designers by - among many, many other things - being faster and more forgiving than pen and ink, but we still use these older technologies today in tandem with computers.

## The right tool at the right time
We can still integrate designing in the browser as a component of the design process. I don’t view this as an all–or–nothing deal and our process should be malleable enough to better facilitate reaching the goals of each and every project. Imagine, as an extreme example, that you were told to integrate sketching into your design process. You would absolutely not render your designs “pixel-perfect” in a sketch book. It beats the whole point of the sketch book and the whole experience would be tremendously debilitating. Instead, you’d probably do at least a little bit of preliminary sketching before opening Photoshop, and return when you need to massage another idea out of your head.

The benefit of designing in the web, or at least getting a product in the browser sooner, is that you can experience it and identify major problems before you’re past the point of no return. This is a pretty well established idea (that I believe in), but just like using the sketchbook we need to identify when it’s appropriate to pop open a text editor and start punching in markup and styles. I’ll kick this off with two cases where I think designing in the browser is appropriate: prototyping unique interactions and defining visual state changes.

### Prototyping unique interactions
We should prototype and test core product interactions when they are unorthodox. Design patterns should be used where possible, but if we are knowingly going against the grain we need to test that experience in the browser and with users (as available) before making it permanent. This is sometimes after the static design has been completed, but in many cases can be done before anything static has been created.

### Visual state changes
When following design patterns there are still standard things to be fleshed out in the browser: hovers, presses, clicks, fades, sliding interactions, and so on. Generally, if you don’t know how an interaction will truly feel and it involves a state change: design it in the browser. At DockYard, we often propose a solution first in Photoshop and then weigh our options again in the browser. 

## An example
We completed a project last year with the ambition of the design stage being completely browser based, skipping the use of Photoshop altogether. The benefits of having a usable front end in place of static mockups are great: you can use your app as it is being designed and get a sense of the failure points before they become too ingrained in the experience. User testing can begin earlier. This is awesome. From the outside, designing solely in the browser seemed perfect.

You guessed it: I was wrong. It wasn't right for us then, nor for that project. We were less focused on the user’s experience and more focused on the organization and creation of markup, styles, and script. We began (and ended) by worrying about and writing lines of html, css, and javascript. We were worried about front end patterns, but the design patterns we were aiming to support weren’t fully identified yet. We introduced somewhat of a chicken and the egg problem, making our thinking more difficult and more sporadic than it should have been.

For us this meant spending hours and hours tweaking markup, all in the name of being able to feel and test the product as it was created. In some cases, for sure, this can be worth it. In our case we even had plenty of existing design assets to base our web interface off of, but that project had called for too many largely different iterations (and mixed opinions) of the same few designs.

Designing in the browser does not mean your project will turn out poorly. Ultimately, and fortunately, that project had turned out well in the end, but we did spend a lot more time getting a complete idea of what we were actually designing and building. Our clients got to use the product before they bought into the concept, which was great for them. For us, however, it was as if we started designing a house by laying the concrete foundation before knowing what we were building.

## Weigh your options
A successful product depends on its content, design, engineering, market fit, team, tools, and infinitely more. When consulting, those elements are wildly varied from client to client, including the toolset. So we must be mindful of what is necessary, be malleable in our processes, and most important of all: make room for discovery.