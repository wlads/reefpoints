---
layout: post
title: "What is holding up the uniqueness validator?"
comments: true
author: 'Brian Cardarella'
github: bcardarella
twitter: bcardarella
social: true
summary: One of the more requested features of ember-validations
published: true
tags: ember
---

[ember-validations](https://github.com/dockyard/ember-validations) has
nearly all of the [validator
rules](https://github.com/dockyard/ember-validations#validators) one needs.
One glarring omission is the `Uniqueness` validator.

### Not as straight forward as one would think

Before we never talk about the complication with implementing the remote
validator, we should talk about if `uniqueness` should be both a remote 
**and** local validator.

Imagine you are working with
[ember-data](https://github.com/emberjs/data), you attempt to create a
new record with an email `test@example.com`. If you already have a
record with that value for email in ember-data's store should
`uniqueness` first defer here before we hit remote? This ends up being a
strange thing because what if you have not persisted that first record
yet. Do we only run uniqueness checks against local records that have
been persisted? And how exactly would this fit in if you are mixing your
validations into the controller instead of the model?

If the `email` example isn't working for you, imagine you are adding a
bunch of line items to a parent record. None of these line items have
been persisted yet. And you don't want to allow your users to add
another until the current one they are working on is "valid". Validating
uniqueness locally is all of a sudden very valuable. But also very
complex to implement properly.

### No standard yet

If the local validator is too complex an animal to tackle perhaps the
remote validator implementation will be easier. It is, in part at least.
We can rely on `Ember.run.debounce` to ensure the the remote validator
doesn't fire too frequenly when many changes are happening to the value
of property. (i.e. entering text into a field)

But where do we send this request for uniqueness? This is where I am
currently hung up. I really don't want to implement a backend api
expectation into ember-validations. I was hoping that something like
[json-api][http:/jsonapi.org) would define this for me then I could rely upon that as a
starting expected endpoint. But I don't think this is anywhere on their
radar.

This being said, there is a possible solution. One of my co-workers [Lin
Reid](https://twitter.com/linstula) has put together a PR for
introducing remote uniqueness to ember-validations. It is lacking tests
(hint hint, Lin!) but I think [this is moving in the right
direction](https://github.com/dockyard/ember-validations/pull/117).

To summarize, uniqueness is not forgotten. It is just a pain in the ass
to do properly. Personally I would prefer not to implement an API have
people buy into it now and have to change it (or be locked into it) a
few months from now.
