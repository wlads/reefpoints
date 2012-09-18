---
layout: post
title: "Querying PostgreSQL datatypes in ActiveRecord with postgres_ext"
comments: true
author: Dan McClain
twitter: "_danmcclain"
github: danmcclain
category: ruby
social: true
summary: "Returning records based on array elements and network subnets"
published: false
---

I created the postgres\_ext gem to add ActiveRecord support for 
PostgreSQL datatypes in Rails 3.2+. So far, I have added support for
the CIDR, INET, MACADDR, UUID, and array datatypes. Please open an issue
on
GitHub if you'd like other datatypes supported that aren't currently.
Since we can now add these columns via Rails migrations, and have
INET/CIDR and array columns converted to Ruby `IPAddr` and `Array`
objects, resepectively. It would be great if we could take advantage of
PostgreSQL's query support for these datatypes. Wait, we can already do
that!

## Querying against arrays using `ANY` and `ALL`
