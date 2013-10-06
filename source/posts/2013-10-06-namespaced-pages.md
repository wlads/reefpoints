---
layout: post
title: 'Namespaced Pages'
comments: true
author: 'Brian Cardarella'
twitter: 'bcardarella'
github: bcardarella
social: true
summary: 'New functionality for the gem'
published: true
tags: ruby, ruby on rails
---

## Simple Namespacing ##

We've been using our [Pages](https://github.com/dockyard/pages) gem in
nearly all of our projects for over a year now. Its been great but could
only support pages on the root. I just released `0.2.0` of the gem that
now supports namespacing:

```ruby
namespace :work do
  pages :client_1, :client_2
end
```

This will give you the routes of `/work/client_1` and `/work/client_2`.
Your views will go into `app/views/work/pages`. For more details see the
[README](https://github.com/dockyard/pages#namespacing)
