---
layout: post
title: "Querying PostgreSQL datatypes in ActiveRecord with postgres_ext"
comments: true
author: Dan McClain
twitter: "_danmcclain"
github: danmcclain
legacy_category: ruby
social: true
summary: "Returning records based on array elements and network subnets"
published: true
---

I created the [postgres\_ext](https://github.com/dockyard/postgres_ext) gem to add ActiveRecord support for 
PostgreSQL datatypes in Rails 3.2+. So far, I have added support for
the CIDR, INET, MACADDR, UUID, and array datatypes. [Please open an issue on GitHub if you'd like other datatypes supported that aren't currently](https://github.com/dockyard/postgres_ext/issues).
Since we can now add these columns via Rails migrations, and have
INET/CIDR and array columns converted to Ruby `IPAddr` and `Array`
objects, resepectively.

Rails 4.0 has also added support for CIDR, INET, MACADDR and array
datatypes.

It would be great if we could take advantage of
PostgreSQL's query support for these datatypes. Wait, we can already do
that!

## Querying against arrays using `ANY` and `ALL`

In PostgreSQL, you can query for records where any or all elements match
a given predicate.

```sql
SELECT *
FROM users
WHERE 'johnny' = ANY(nicknames)
-- Finds any record that has 'johnny' stored in the nicknames array

SELECT *
FROM user_scores
WHERE 1000 > ALL(scores)
-- Finds any record that has over 1000 stored in every element in the
-- scores array
```

We can actually use arel to generate these queries.

```ruby
user_arel = User.arel_table

any_nicknames_function = Arel::Nodes::NamedFunction.new('ANY', [user_arel[:nicknames]])
predicate = Arel::Nodes::Equality('test', any_nicknames_function)

sql_statement = user_arel.project('*').where(predicate).to_sql
#=> SELECT * FROM \"users\" WHERE 'test' = ANY(\"users\".\"nicknames\")

users_with_nickname = User.find_by_sql(sql_statement)
```

In the above example, we have to create an `Equality` node manually
since the left hand side of the predicate is the value, instead of the
column. If you need `<` in your predicate, you would create a `LessThan`
node instead of an equality node.

This example applies to both Rails 3.2+ with postgres\_ext and Rails 4.0
with native array support.

## Array overlap

In PostgreSQL, you can check if two arrays have one or more elements in
common by using the overlap operator, `&&`.

```sql
'{1,2,3}' && '{4,5,6}'
-- f
'{1,2,3}' && '{3,4}'
-- t
```

In postgres\_ext, I added a new Arel predicate node for the 
overlap operator.  For the time being, it is named `ArrayOverlap`
and can be called from a `Arel::Attribute` as `#array_overlap`. It
is likely that this will be renamed to `Overlap` and `#overlap`,
respectively, in the next release of postgres\_ext.

```ruby
user_arel = User.arel_table

User.where(user_arel[:tags].array_overlap(['one','two'])).to_sql
# => SELECT \"users\".* FROM \"users\" WHERE \"users\".\"tags\" && '{one,two}'
```

One case that we have used an array column in tandem with the overlap
operator was adding tags to a user. We had three tags that could be
placed on a user, so we stored this data an array column. We then had a
search form which had a multiselect field for that tags column. The
multiselect would give us an array of possible values that we wanted to
find records that had any of those selected values. So instead of
crafting a statement with multiple `ANY` queries `OR`ed together, we
used overlap instead, resulting in only one predicate.

## INET/CIDR subnet inclusion

In PostgreSQL, you can see if a particular INET address is contained in
a specific subnet with the contained within operator, `<<`.

```sql
inet '192.168.1.6' << inet '10.0.0.0/24'
-- f

inet '192.168.1.6' << inet '192.168.1.0/24'
-- t
```

In postgres\_ext, I added a new Arel predicate node for the 
contained within operator. It can be called from a
`Arel::Attribute` with `#contained_within`. I also added a visitor for
IPAddr objects so that they are correctly converted to quoted strings
when called within a Arel predicate.

```ruby
user_arel = User.arel_table

User.where(user_arel[:ip_address].contained_within('10.0.0.0/8').to_sql
#=> SELECT \"users\".* FROM \"users\" WHERE \"users\".\"ip_address\" << '10.0.0.0/8'
```

## We're not done yet

We have only scratched the surface of the datatype specific functions
and operators in PostgreSQL. There are many more to be implemented, and
the plan is to support them all. This post highlights what has been
implemented so far, and also what you can do with Arel already. I plan
to put together some pull requests for Arel to add in some of the
PostgreSQL operators. If there is an operator missing in postgres\_ext
that you want/need, please [open an issue on
Github](https://github.com/dockyard/postgres_ext/issues?state=open)!
