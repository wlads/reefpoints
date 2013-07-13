---
layout: post
title: 'Introducing destroyed_at'
comments: true
author: 'Michael Dupuis'
twitter: 'michaeldupuisjr'
github: michaeldupuisjr
legacy_category: ruby
social: true
summary: 'An ActiveRecord mixin for safe destroys'
published: true
tags: ruby on rails, gems
---

[See the project on GitHub](https://github.com/dockyard/destroyed_at)

We've found that more and more clients are requesting "undestroy"
functionality in their apps. We recently extracted this common pattern into a gem
we're calling [DestroyedAt](https://github.com/dockyard/destroyed_at), an ActiveRecord mixin that makes un-destroying records
simple. 

By
setting the datetime of the `#destroyed_at` field of your record, you can
mark records as destroyed, without actually deleting them. By default, the
model in which you `include DestroyedAt` is scoped to only include
records that have not been destroyed. So something like
`User.all` will only return `User`s with `#destroyed_at` values of `nil`;
and `User.unscoped.all` will return all `User` records.

When you want to bring a
record back, simply call `#undestroy` on the instance and its
`#destroyed_at` will be set to `nil`.

We've baked a bunch of other functionality in as well, including
undestroy callbacks. For the full rundown, head over to [DestroyedAt's
GitHub page](https://github.com/dockyard/destroyed_at) .
