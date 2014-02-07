---
layout: post
title: "Announcing PostgresExt-PostGIS"
comments: true
author: Dan McClain
twitter: "_danmcclain"
googleplus: 102648938707671188640
github: danmcclain
social: true
summary: "PostgresExt-PostGIS adds PostGIS support to ActiveRecord"
published: true
tags: ruby, ruby on rails, postgresql, postgis, postgres_ext, postgres_ext-postgis
---

Today I released the first version of postgres\_ext-postgis, which
extends ActiveRecord to support PostGIS data types and some querying.
This is definitely a beta release, but ready to the point where people
can play around with it.

## Migrations

With postgres\_ext-postgis, you can easily add geometry columns:

```ruby
create_table :districts do |t|
  t.geometry :district_boundries
end
```

If you'd like to include your projection or geometry type, just include
them as options to your column:

```ruby
create_table :districts do |t|
  t.geometry :district_boundries, spatial_type: :multipolygon, srid: 4326
end
```

## Type Casting

Your geometry columns will be typecasted into
[RGeo](http://dazuma.github.io/rgeo/) objects. You can set your
attributes with RGeo objects or EWKT/EWKB strings. EWKT/EWKB strings
will be converted to RGeo objects:

```ruby
user.location = 'SRID=4623;POINT(1 1)'
```

## Querying

For now, the only added querying method for ActiveRecord is `contains`:

```ruby
District.where.contains(district_boundries: user.location)
```

The above query will utilize PostGIS's `ST_CONTAINS` to see if the
`district_boundries` column contains the `user.location`. I plan to add
a convience method to convert EWKT strings to RGeo object, something
like `PostgreExt.geom('SRID=4623;POINT(1 1)')`, to make generating
queries from, say, a mobile user's current location a bit easier.

As I get feedback and use postgres\_ext-postgis, more features will get
added. Stay tuned!
