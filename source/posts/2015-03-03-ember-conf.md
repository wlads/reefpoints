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
* Big thanks to Robert Jackson @rwjblue!!!! http://getrwjblueabeer.com

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

* Block parameters, Faster and lower memory, Validation for Templates
* Killed metamorphs!
* Improvements to Ember Inspector including Ember Data and promises pane, render performance tab, multiple `<iframe>`s, redesigned UI, to name a few

### Ember CLI

* Single install command for Addons, Test support, massive performance improvements, and API stubbing, server proxy, to name a few.

### Testing Ecosystem

* handles asynchrony 

### Ember Data

* Relationship Syncing, Async Relationships - built with async loading in mind
* Adapter Ecosystem

## That was last year, what's next?

* Versioned Guides -- live today! http://guides.emberjs.com
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
* When to call _super(): When overwriting a framework method before touching `this`

## Mis-alignment #3

Problem: Ember.Object.reopen, buggy, complex internals, massive allocations & shapes

Solution: Limit reopen to before first instantiation

* Meta is a good thing. Every class has a meta, every instance has a meta. Metas for instances are what kill us. Meta is "live" inheriting. If can limit reopen, can make all metas one shape.
* meta.listeners is crazier
* Solution: work with V8 to make things better
