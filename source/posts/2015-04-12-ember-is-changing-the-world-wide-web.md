---
layout: post
title: "Ember is Changing the World (Wide Web)"
comments: true
author: 'Brian Cardarella'
twitter: 'bcardarella'
social: true
published: true
tags: opinion, ember, javascript
---

I've been working with Ember for over two years now. Over that time I
have seen the influence and impact that Ember has had on the JavaScript
community at large. An influence that I do not believe any other
framework has had, and one that has gone mostly unrecognized by
JavaScript developers outside of the Ember community.

Now, I'm not proposing that Ember is taking credit for the features I'm
about to list. However, I do propose that in each case Ember heavily
influenced their development because the Ember Core Team was willing to
invest in these features and wait until they reached (a level of)
maturity rather than just plug in something that was "good enough".

## Promises

JavaScript is an async world, client-side applications should be written
"async-first".

## ES6(2015) Modules

The problem of how to distribute 

## ES2015 Syntax

Likewise with modules, Ember (via Ember-CLI) was the first major
framework to adopt the ES2015 JavaScript syntax as being first-class.
Rather than inventing its own language (I'm looking at you TypeScript)
Ember is embracing open standards.

## First-Class Command Line Tooling

One of the killer features to come out of Ember in the past year is
definitely Ember-CLI. It is true that other JavaScript frameworks had
command line tools prior to Ember-CLI, however to my knowledge none of
them were supported by the core team for any framework. Nor did any of
them reach a tipping point within each framework's community.

Ember-CLI was borne from Ember App Kit, an extraction from Yapp's build
system. Heavily influenced by Ruby on Rails's own command line tooling,
it can really be seen as something to "[really tie the room
together](https://www.youtube.com/watch?v=ezQLP1dj_t8)". Ember-CLI
answered the following questions for Ember developers:

* How do I start an Ember App?
* How do I test an Ember App?
* How do I share my custom Ember code with the community?
* How do I organize my Ember code?

Similar to Ruby on Rails, it allowed Ember developers to focus on
building their applications rather than bikeshedding on boilerplate by
providing the following:

* ES6(2015) Transpilation
* Minification
* Uglification
* CSRF Protection


## Broccoli

Jo Liss saw a significant problem with the JavaScript build tools. Speed
is the number one priority when it comes to a build system, Grunt and
Gulp just were not cutting it when you start to consider JavaScript
applications of significant scope. Jo's creation, Broccoli, aimed to
keep builds as fast as possible while offering extreme flexibility on
how to create your custom build pipeline. Ember-CLI adopted Broccoli
very quickly and has been pushing the technology forward.

Broccoli does meet resistance from many JavaScript developers outside of
Ember. It is understandable, the API is not as approachable as Gulp.
But, Broccoli is rarely meant to be a tool that the average developer is
integrating into their project. You can do so, but Broccoli is really
meant to play a support role to a larger build system. Recently both
React and Angular had a meeting to discuss collaboration between the two
projects. Based upon the notes it appears that Angular is going to
transition away from Gulp and adopt Broccoli. This is great news, the
more frameworks we have using Broccoli the better. (I recently unsuccessfully
advocated for the Phoenix Framework to also adopt Broccoli)

## Package Management

This one hasn't happened yet. But in the near future look for Ember to
be leading to charge on getting rid of Bower. The Ember community's
desire to have a serious first-class package manager for the client will
either produce one from the community or force NPM to do so. (it is
currently impossible to create guaranteed reproduceable deploys with
NPM, and yes I'm aware of shrinkwrap)
