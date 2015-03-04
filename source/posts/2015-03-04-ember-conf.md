---
layout: post
title: "EmberConf 2015 Day 2"
comments: true
social: true
author: Marin Abernethy
twitter: "parinMarin"
github: maabernethy
summary: "Live blog of EmberConf 2015"
published: true
tags: ember
---

# Fault Tolerant UX by Dan Gebhardt
[@dgeb](https://github.com/dgeb)

* Users should be shielded from any application issues that are encountered

## Transaction UX

* Atomic: all or nothing
  * Ex. if a user fills out a form your app should save all the data, not just some.
* Consistent: move between different states
* Isolated: allows concurrent changes
* Durable: changes are persisted

### Apps MUST NOT violate the rules of transactional UX or you are violating the users trust

## Forgiving User Experience

* Fault Tolerant UX --> Forgiving UX
* Transitional experience: to persist data that has not yet be saved, but in the process of being edited
* Undo/redo
* Offline support
* Asynchronous interface (non-blocking)
  * user can make changes as quickly as possible (changes can be queued up and synced at your apps convenience)

## Engineering Fault Tolerant UX

* Ember provides simple elgant patterns for building a consistent UX
* Similarly, ember data provides durable UX
* Ember data requires customization (extra code) to provide atomic and isolated code

## [Orbit](https://github.com/orbitjs)

### Orbit application patterns

* Client first development
* Pluggable sources
* Data synchronization
* Editing contexts
* Undo/redo

### [ember-orbit](https://github.com/orbitjs/ember-orbit)

* Provides a store with synchronous and asynchronous methods


# Aligning Ember with Web Standards by Matthew Beale
[@mixonic](https://github.com/mixonic)

## Standards

* The JS standardization process is about to change: ES5, ES6, ES2015!
* Standards Process
    * 5 stages - strawman, proposal(polyfills), draft(experimental), candidate(compliant), finished(shipping)
    * [Polyfill](https://remysharp.com/2010/10/08/what-is-a-polyfill): A polyfill is a piece of code (or plugin) that provides the technology that you expect the browser to provide natively. 
* 2 major standards groups:
    * WHATWG + W3C (html / dom related)
    * TC39 + Ecma International (promises, classes, for loops, etc)
* Aligning with standards is not a one time event. It is ongoing!

## Why Standards?

* The goal is productivity
* Standards are portable, reflect best preactices, and endure 
* Participants win

### ES5 -> ES2015

 * New API for maps
 * Promises
 * Proxies

### Babel

* Babel will turn your ES6+ code into ES5 friendly code
    * Enables new syntax (fat arrow, let) , APIs (map, set), not everything

### Aligning Ember's Object Model

*  is this feature: stable? a good pattern? implemented correctly? implemented performantly?

### ES Classes

* Three new tools: class, extend, super
* More gotchas: 
  * setUnknownProperty 
  * Transpiler output
  * New syntax
  * Changes in way that super behaves
  * Mixins

Remember: standards are a two-way street!

[Ember Community Survey](http://www.201-created.com/ember-community-survey-2015)
