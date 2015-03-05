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


# Growing Ember One Tomster at a Time by Jamie White
[@jgwhite](https://github.com/jgwhite)

How did a tech community come to be so vibrant? How can we continue?

## 1. The Tomster

* Representation of productivity and friendliness
* Tomster wore different hats
  * Custom tomsters
* Good defaults
  * Having a friendly mascot makes things easier.
  * “Ambition” and “friendliness” is hard to juxtapose
* Composing concepts

## 2. Language

* Tomster is a tool. Productivity and friendliness implicitly part of conversation
  * Words stick; the right words enable conversations
  * “hack” is not a good vocabulary word - negative connotation 

## 3. User Interface

* Programming language and documentation with good user interface

## 4. Hackability

* Parts have to be accesible - has to feel hackable.
  * Tomster was not overly done.

## 5. Roles

* Many specialisms in Ember Community: documenteer, student, mentor, critic, explorer, and many more!


Community building is a design and engineering challenge


# Interaction Design with Ember 2.0 and Polymer by Bryan Langslet
[@blangslet](https://github.com/blangslet)

* The web browser is the largest app runtime in the world, and will continue to grow
* Every device has to be connected to the web
* Web frameworks and toolkits are getting closer to native performance everyday 

"How can I - one person with a laptop - leverage my time as powerfully as I possibly can, every minute I work?"

## Ember-Flow

* A paradigm shift for web interaction design
* The goal: to blur the lines between native and web applications

### Web Components

* Extends the browser itself
  * Polymer components extend a base component
* Encapsulation
* Declarative
* True reusability/portability

## Ember vs. Polymer Use Cases:

* Ember: developer productivity, conventions
* Ember: community
* Ember: World-class routing and state management
* Polymer: constantly pushing the web forward

### Web Animations API

* Has the best of both CSS and javascript animations
* Web animations run outside of the main thread and can be accelerated on the GPU

### [Treasure Hunt Demo Application](https://github.com/blangslet/treasure-hunt)

* "Demonstrates an experimental integration between ember.js routing and Polymer's core-animated-pages component to create beautiful inter-state animated transitions"


# Building Applications for Custom Environments with Ember CLI by Brittany Storoz
[@brittanystoroz](https://github.com/brittanystoroz)

### Ember CLI

* Everyones favorite command line tool
* Build organized ember apps quickly
* Fills huge void in toolset for JS devs

### Ember CLI Addons

* Extend ember-cli beyond core fucntionality
* Follow standard npm conventions
* Easy to create & install:

`ember addon name-of-your-addon`

`ember install:addon name-of-your-addon`

## Firefox OS

* Requirements that Ember CLI could not provide
    1. Generate and validate a manifest file (same concept as package.json)
    2. UI components that mimic OS interface
    3. Publish to Firefox marketplace
* Ember CLI Addon was born to fill those requirements.

### 1st Requirement: Generating The Manifest

* Creating Blueprints
  * rules for generating common code and file structures:

`ember generate blueprint name-of-blueprint`

### 2nd Requirement: FirefoxOS UI ([Gaia](https://github.com/gaia-components/gaia-tabs))

* Building components
`bower install gaia-components/gaia-stubs`
* 2 responsibilities:
  * including dependencies and creating the addon
  * making both available to the consuming application

## Components Review

* Dependencies:
  * bower install within addon
  * bower install withing consuming logic
* Component logic
  * create component
  * export components to consuming aplication
  * define component template
* Validation & Publishing
  * creating commands for control over when these things happen
  * `includedCommands` hook: returns object of commands which are found inside `lb/commands`
  * `ember help` lists out information about available add-on commands. And lots more useful info.


# Building Real-time Applications with Ember by Steve Kinney
[@stevekinney](https://github.com/stevekinney)

* Integrating browser functionality and third party code into our applications. In this case, WebSockets.
* What is a WebSocket Used for? 
  * Collaboration, analytics dashboards, prompting user to upgrade application
* Can I actually use WebSockets? 
  * For the most part, yes (some earlier version of IE not supported)
* Socket.io -> library for Node
* Faye  -> simple pub/sub messaging

### Approach #1: Use Standalone Controller

* Somewhat limited because it only works between controllers

### Approach #2: Dependency Injection with Services

* `ember generate service websocket`
* Declare where you want to inject it inside the Initializer
* Inside controller: `websocket: Ember.inject.service()`

### Approach #3 Using Socket.io

  * Socket.io is both a server and client side library

[What is your favorite thing about JavaScript?](bit.ly/js-poll)


# Minitalks!

## 1. Measuring Performance with User Timing API by Bill Heaton
[@pixelhandler](https://github.com/pixelhandler)

* Measuring the differences in template rendering speeds between Ember.js v1.8.1 w/Handlebars v1.3 and Ember.js v1.10.0 w/HTMLBars
* Check out his findings on [blog!](http://pixelhandler.com/posts/measuring-performance-with-user-timing-api-in-an-ember-application)

## 2. `ember-islands` by Mitch Lloyd 
[@mitchlloyd](https://github.com/mitchlloyd)

* [`ember-islands`](https://github.com/mitchlloyd/ember-islands)
* Render Ember components UJS-style to achieve "Islands of Richness". You can arbitrarily render Ember components in the body of the page and they will all be connected to the same Ember app.

## 3. Ember Testing with Chemistry Dog by Liz Bailey 
[@lizzerdrix](https://github.com/lizzerdrix)

* Migration from Rails to Ember
* Ember does not provide as much documentation on testing
* Would love to help make Ember more approachable to beginners

## 4. Running C++ in ember-cli with Emscripten by Michael Nutt
[@mnutt](https://github.com/mnutt)

 * [`ember-cli-emscripten`](https://github.com/movableink/ember-cli-emscripten)
 * Allows you to add C or C++ to your ember app, then require the exposed functions and classes.
 * Fibonacci sequence demo!

## 5. Ember Observer by Kate Gengler
[@kategengler](https://github.com/kategengler)

* [Ember Observer](https://github.com/emberobserver/client)
* Gives addons a score out of 10
* pulls hourly from npm and Github

## 6. CSS is Hard by Erik Bryn
[@ebryn](https://github.com/ebryn)

* [`ember-component-css`](https://github.com/ebryn/ember-component-css)
* namespaces our component styles automatically!


# Physical Design by Edward Faulkner
[@ef4](https://github.com/ef4)

* Computers are so abstract. Possibilities are endless, only hindered by your imagination.
* Constrained by physics
* Googles material design spec
  * does not break rules of physics
  * animations and motion appeal to us because they fit into our idea of how it should physically work.
* [Liquid Fire](https://github.com/ef4/liquid-fire) live demo!
  *  `npm install —save-dev liquid-fire` for Ember 1.11+
* [Ember Paper](http://miguelcobain.github.io/ember-paper)


# Closing Keynote: Chris Eppstein
[@chriseppstein](https://github.com/chriseppstein)

## Announcing: Eyeglass

* Distribute SASS extensions as NPM modules for [LIBSASS](https://github.com/sass/libsass)
* Will be able to integrate with a number of different build systems, including Ember CLI
* Major performance improvements
* The best parts of SASS and Compass, working with the best tools JS has to offer

## A Selection of Chris' Inspirational Messages

* "Don't be a Sasshole"
* "People come to a community for the tech, but stay for the love!"
* "Sass didn't lose when I started ignoring the haters"
* "If you use a framework you love, you'll never work a day in your life"
* "Secret to a vibrant community: be excellent to eachother"
