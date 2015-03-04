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

* provides store with synchronous and asynchronous methods

