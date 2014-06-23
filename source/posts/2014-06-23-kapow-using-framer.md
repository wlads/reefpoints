---
layout: post
title: "KAPOW! Writing prototypes with Framer"
comments: true
author: 'Steven Trevathan'
twitter: 'strevat'
social: true
summary: 'A look at Framer.js, a powerful prototyping tool.'
published: true
tags: design, design process, prototyping
---

I've finally used [Framer](http://framerjs.com/) on a client project and couldn't be happier with the result. I normally use [InVision](http://www.invisionapp.com/) and highly recommend it, but Framer is the obvious choice when we need the experience to feel significantly more real.

[Every tool has its pros and cons](http://www.cooper.com/journal/2013/07/designers-toolkit-proto-testing-for-prototypes), however, so it won't *always* be the best choice for you.

Let me start with Framer's big con: you must write JavaScript to knit a prototype together. The code itself is very easy to learn, but understanding how the Framer script interacts with your PSD's groups and layer organization is like flying blind. With practice you can get past this and work gets much, much faster.

The one other con is that their documentation is made more for developers than designers. So if you're not used to digging into developer docs you will likely be overwhelmed and unsure what you're looking for. Looking elsewhere won't help you either, there doesn't seem to be much community around this (yet).

Someone with less coding experience will find Framer difficult and more intimidating than it has to be. I'd recommend dealing with the learning curve by practicing on a few side projects before you put anything important on the line (not that side projects aren't important).

Where Framer really shines bright: you won't have to verbalize (or make embarrassing gestures) for how your app should feel, because you define that with enormous control. Oddly enough, the biggest con is your ally here, as writing custom JavaScript is what makes this control possible.

Framer supports clicks and taps just the same, supports many animation options, is highly configurable, and runs very, very smoothly on all (of my) devices. I've tested it on iPhone, iPad, and a Mac. Because of this control and variability of use, your prototypes will feel much more real to the user in a testing scenario. This is especially good when your interactions help communicate state and position.

If you've used Framer before, let me know how you like it. There's only so much time in the world to play with prototyping tools, but my next experiment will be with [Origami](http://facebook.github.io/origami/).

## Bonus!
While doing user testing sessions, you may want the testee to work on the actual device. To do so you can use [Anvil](http://anvilformac.com/) to create a local web address using [Pow](http://pow.cx/). This will give you an address (something like `http://yourappname.youripaddress.xip.io/`) that you may access on your device.
