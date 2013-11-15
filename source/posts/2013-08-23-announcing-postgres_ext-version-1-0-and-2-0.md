---
layout: post
title: "Announcing Postgres_ext version 1.0 and 2.0"
comments: true
author: Dan McClain
twitter: "_danmcclain"
github: danmcclain
social: true
summary: "Today, I released not 1 but 2 versions of PostgresExt"
published: true
tags: ruby on rails, gems, postgres_ext, postgresql
---

Two versions of PostgresExt have been released today.

## 1.0.0 (and the 1-0-stable branch)

The [1.0.0](https://github.com/dockyard/postgres_ext/tree/v1.0.0)
 version is the first production release of PostgresExt. It
supports Rails 3.2.x, adding in both data type and advanced querying
support for ActiveRecord and Arel.

## 2.0.0 

I have also released version [2.0.0](https://github.com/dockyard/postgres_ext/tree/v2.0.0),
which supports ActiveRecord and Arel 4.0.x. Most of the 1.0.0 code
is gone from 2.0.0, since Rails 4.0.0 supports all the data types
that PostgresExt added to Rails 3.2.x.

## The Future

I'm focusing on Rails 4.0.0 for all future features of PostgresExt. I
will gladly pull in additional features for 1.0.0, but Rails 3.2.x is no
longer the primary focus of PostgresExt. Maintenance on 1.0.0 will be
minimal, since [Rails 3.2.x will no longer be receiving releases for bug
fixes](http://weblog.rubyonrails.org/2013/2/24/maintenance-policy-for-ruby-on-rails/),
but pull requests for bug fixes would be graciously accepted.
