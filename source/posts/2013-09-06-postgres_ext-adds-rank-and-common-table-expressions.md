---
layout: post
title: "Postgres_ext adds rank and common table expressions"
comments: true
author: Dan McClain
twitter: "_danmcclain"
github: danmcclain
social: true
summary: "In postgres_ext 2.1, complex queries get much easier"
published: true
tags: ruby on rails, gems, postgres_ext, postgresql
---

This week, I released [postgres\_ext](https://github.com/dockyard/postgres_ext) 2.1.0, which includes
ActiveRecord::Relation methods to simplify queries that require the use
of [Common Table
Expressions](http://www.postgresql.org/docs/current/static/queries-with.html)
(CTEs) and the [`rank()` windowing
function](http://www.postgresql.org/docs/9.2/static/functions-window.html).

## Common Table Expressions

In a sentence, CTEs allow you to define a temporary table to be used in
a larger query. Let's look at an example:

```SQL
WITH scores_for_game AS (
SELECT *
FROM scores
WHERE game_id = 1
)
SELECT *
FROM scores_for_game
```

In the above, somewhat arbitrary, example, we create a temporary table
of `scores_for_game` which we then select from. CTEs allow you to
organize your more complex queries, and can be really helpful in certain
cases.

We can make the same SQL call in ActiveRecord with postgres\_ext.

```ruby
Score.from_cte('scores_for_game', Score.where(game_id: 1))
```

We can also query against the CTE expression by chaining off the
resulting ActiveRecord::Relation

```ruby
Score.from_cte('scores_for_game',
  Score.where(game_id: 1)).where(user_id: 1)
```

would generate the following:

```SQL
WITH scores_for_game AS (
SELECT *
FROM scores
WHERE game_id = 1
)
SELECT *
FROM scores_for_game
WHERE scores_for_game.user_id = 1
```

You can also include CTEs in your normal queries to join against by
using `with`

```ruby
Score.with(my_games: Game.where(id: 1)).joins('JOIN my_games ON scores.game_id = my_games.id')
```

will generate the following SQL:

```SQL
WITH my_games AS (
SELECT games.*
FROM games
WHERE games.id = 1
)
SELECT *
FROM scores
JOIN my_games
ON scores.games_id = my_games.id
```

## Rank

PostgreSQL provides a `rank` windowing function, which will take into
account ties when ranking results. You would add rank to your
projection, like the following example:

```SQL
SELECT scores.*, rank() OVER (ORDER BY scores.points DESC)
FROM scores
```

The results set will return ordered by the rank, which is determined the
order passed into the `rank`'s `OVER`. In the above example, the scores
would be ranked by their scores descending, so highest score first. If
there was a tie at first place between two scores, they would both
ranked 1, and the next result would be ranked `3`. We can achieve the
same in ActiveRecord with postgres\_ext:

```ruby
Score.ranked(points: :desc)
# or
Score.ranked('points desc')
```

Rank will rank independently of any sort order applied to the query, so
you could have your scores ranked by points, but then ordered by their
creation time.

```ruby
Score.ranked(points: :desc).order(:created_at)
```

will generate the following query:

```sql
SELECT scores.*, rank() OVER (ORDER BY scores.points DESC)
FROM scores
ORDER BY scores.created_at ASC
```

Also, if you apply a sort order to your relation, and want to sort by
it, you do not have to tell ranked what order you'd like to use, as it
will reuse the order. 

```ruby
Score.ranked.order(points: :desc)
```

One thing to watch out for if you use `ranked` without an explicit
order and want to call [`first`](http://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-first)
off your relation, if the results of the
relation have yet to be retrieved, the first will use your table's
primary key for an `ORDER BY` statement on the query. This has already
bitten us before we discovered the behavior of `first`. To avoid this
behavior in `first`, use
[`take`](http://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html#method-i-take)
which does not use any implied order.

We've been using CTEs and rank on one of our client projects, and it's
already cleaned up the `from_sql` queries we were previously
using. Let us know if you hit any snags, or have any suggestions on how
else we can make complex SQL queries easier to call from ActiveRecord!
We only implement the `rank` windowing function right now, but plan to
add the others shortly.
