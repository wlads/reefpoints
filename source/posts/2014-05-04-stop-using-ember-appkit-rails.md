---
layout: post
title: "Stop using Ember Appkit Rails"
comments: true
author: 'Brian Cardarella'
github: bcardarella
twitter: bcardarella
social: true
summary: Just stop
published: true
tags: ember, ruby, ruby on rails
---

A few months ago I released a gem called [Ember Appkit
Rails](https://github.com/dockyard/ember-appkit-rails). Let me start by
apologizing for its existance. For those that began projects around
eak-rails it started with good intentions and felt right at first but we
have abandoned the gem at DockYard.

eak-rails was/is a merging of [Ember App
Kit](https://github.com/stefanpenner/ember-app-kit) and Rails. It does
some heavy monkey patching to Rails' Asset Pipeline to give as much
project hieracrchical power to your Ember code as your Rails code
enjoys.

We used eak-rails in smaller projects, and intro to Ember courses. In
small doses eak-rails felt right. However, when the surface area of an
application increased eak-rails did not scale well. Having your Ember
and Rails files mixed into the same directories created more problems
than it solved.

So, this week I will be focusing on how we are building Ember apps
backed with Rails at DockYard. Part of that will be in-line with what
fellow DockYarder [Dan McClain presented at Boston Ember last
month](https://www.youtube.com/watch?v=ceFNLdswFxs&t=1h8m20s).

So for eak-rails users, we have not abandoned you. Anybody refusing to
migrate we'll continue any **critical** bug fixes but no new features.
We actually sunset the gem about 2 months ago.

ember-cli is the future.
