---
layout: post
title: "EmberConf 2015 Day 1"
comments: true
social: true
author: Marin Abernethy
twitter: "parinMarin"
github: maabernethy
summary: "Live blog of EmberConf 2015"
published: true
tags: ember
---

# Opening Keynote: Tom Dale and Yehuda Katz

* To kick off the conference Tomster joined Tom Dale and Yehuda Katz on stage!
* [@mixonic](https://github.com/mixonic) [@ef4](https://github.com/ef4) [@mmun](https://github.com/mmunm) were welcomed as new members to the Ember Core Team
* Big thanks to Robert Jackson [@rwjblue](https://github.com/rwjblue)!!!! [Get rwjblue a beer!](http://getrwjblueabeer.com)

## Ember 2014 in Review

* Rapid Release worked great! 6 week release cycle to get new features into everyone's hands.

### HTMLBars

```hbs
<a href={{url}}>
```

instead of

```hbs
<a {{bindAttr href="url"}}> 
```

* Block parameters, faster and lower memory, validation for templates
* Killed metamorphs!
* Improvements to Ember Inspector including Ember Data and promises pane, render performance tab, multiple `<iframe>`s, and redesigned UI, to name a few.

### Ember CLI

* Single install command for Addons, test support, massive performance improvements, and API stubbing, and server proxy (the list goes on!).

### Testing Ecosystem

* handles asynchrony 

### Ember Data

* Relationship syncing, async relationships - built with async loading in mind.
* Adapter Ecosystem

## That was last year, what's next?

* [Versioned Guides](http://guides.emberjs.com) -- live today!
* Next Version of Ember CLI (as of last night)
* Engines
* List View
* <angle-bracket> Components (already in Canary)
* Liquid Fire
* Async and Routable Components
* Ember Data: JSON API support out of the box
* Pagination and Filtering
* Shipping Ember Data 1.0
* 6/12 release date for Ember 2.0, Ember Inspector, Ember CLI, LiquidFire, etc.


# Ember.js Performance by Stefan Penner 
[@stefanpenner](https://github.com/stefanpenner)

* Important choices to make, how to make the right choices?
* Time vs. Space
* Things that are costly in space: closures, objects, non-optimized code, compiled code, excess shape allocations
* In Ember.js, need to do less work, align with primitives

## Mis-alignment #1

Problem: Ember does too much work.

Solution: do less

* Actions up, bindings down, no two-way bindings, explicit data flow
* RIP singleton controllers, explicit lifecycle

## Mis-alignment #2

Problem: `init` and `super` are hard to learn and mis-aligned with ES2015

Solution: Embrace super

* Explicit defaults in super
* Don't set properties until super
* When to call `_super()`: When overwriting a framework method before touching `this`

## Mis-alignment #3

Problem: Ember.Object.reopen, buggy, complex internals, massive allocations & shapes

Solution: Limit reopen to before first instantiation

* Meta is a good thing. Every class has a meta, every instance has a meta. Metas for instances are what kill us. Meta is "live" inheriting. If can limit reopen, can make all metas one shape.
* meta.listeners is crazier
* Solution: work with V8 to make things better


# Designing for Ember Apps by Steve Trevathan
[@strevat](https://twitter.com/strevat)

* Mental models: Understand where the user is coming from and what kinds of interactions they deal with
    * "What I think the thing is"
    * Influenced by experiences from the past
    * Not always solid: can be updated and changed. (improvements)
* 2 types of mental models
    * Macro: what I think it is from a distance.
    * Micro: how I think each individual interaction works; the specific feature.
* Build a framework of understanding
    * Some apps are just too complicated
    * Use explicitly if they apply
    * Break mental models if it improves the experience


## Design Patterns

### #1 Gradual Engagement

* Core value given for free. Eventually you may be asked to sign up.

### #2 Skeleton UI 

* ex. Google maps: grid becomes fully rendered map.

### #3 Carry Context

* ex. rdio: music played on laptop is reflected on iPad (or other devices). 

### #4 Reuse Core Interactions

* ex. Browsing Pinterest: provides click and follow tangent.
* Micro becomes Macro; core interactions become a symbol of your app.
* "When I go home and think of your app, I think of the experience, the micro features more than the macro ones."

### #5 Offline Mode

* ex. Google Docs: “trying connect” message and can’t interact with document. Incredibly Frustrating.

## Tools of the Trade

 * A free design pattern library for Ember apps. [Sign up!!](http://toolsofthetrade.dockyard.com)


# Hijaking Hacker News with Ember.js by Godfrey Chan
[@chancancode](https://github.com/chancancode)

* Being a canadian is awesome

## [Hijacking Hacker News App](https://github.com/chancancode/hn-reader)

* Browser extension that transforms old site design to new, more usable app
* Runs in hacker news domain

### Getting the Data

* `$.get("/news').then()`: request html page, extract data, then manipulate
* Hacker News HTML Scrapper: need adapter to help talk to Ember Data store; customize adapter and serializer.

### Fixing the URLs

* Hacker news urls are not ideal for building an Ember app.
* Hacker News Urls (serialized App States) to Ember Router (Actual App States)
   * trick Ember into seeing URLs that are different from what is in the address bar
* Router location types: Ember.HistoryLocation vs. Ember.HashLocation
   * Can use same mechanism to make a custom Ember.Location: `App.HackerNewsLocation = Ember.Location.extend()`

### Preferences

* Changing preferences in one place and can see changes reflected in other
	* Use observer pattern

### The Possibilities

* What if your ideas do not line up with the framework's choices?
* If the frameworks is doing it's job, than the possibilities should be endless!
