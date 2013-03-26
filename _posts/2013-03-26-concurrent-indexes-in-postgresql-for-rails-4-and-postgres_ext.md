---
layout: post
title: "Concurrent Indexes in PostgreSQL for Rails 4 and Postgres_ext"
comments: true
author: Dan McClain
twitter: "_danmcclain"
github: danmcclain
category: ruby
social: true
summary: "Prevent new indexes from locking up your tables"
published: false
---

PostgreSQL allows you to [create your indexes
concurrently](http://www.postgresguide.com/performance/indexes.html#create-index-concurrently)
so that you lock your table up as the index builds. This allows you to
avoid taking a performance hit when adding a new index to a large table.
Yesterday, I submitted a [pull request to
Rails](https://github.com/rails/rails/pull/9923) that as merged in this
morning that allows you to add concurrent indexes through the
`add_index` method in your migrations. To create an index concurrently,
you add the `algorithm: :concurrently` option to the `add_index` call


```ruby
add_index :table, :column, algorithm: :concurrently
```

A side effect of this commit is that it also enables the `algorithm`
option for MySQL too, so MySQL users can create indexes using `DEFAULT`,
`INPLACE` or `COPY` algorithm when creating indexes.

## Postgres\_ext gains concurrent index support as well

This morning I added support for concurrent indexes to
[postgres\_ext](https://github.com/dockyard/postgres_ext) as well, using
the same syntax as the Rails 4 example above. The 0.3.0 version of
postgres\_ext was released, which contains this, and a [slew of other
improvements as
well](https://github.com/dockyard/postgres_ext/blob/master/CHANGELOG.md#030).
One thing to note, the `index_type` option for `add_index` has been
renamed to `using` to match Rails 4.

If you have any features you want to see in postgres\_ext or have any
issues, [open an issue](https://github.com/dockyard/postgres_ext/issue)!
