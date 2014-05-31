---
layout: post
title: "Avoid Rails When Generating JSON responses with PostgreSQL"
comments: true
author: Dan McClain
twitter: "_danmcclain"
googleplus: 102648938707671188640
github: danmcclain
social: true
summary: "Let's use PostgreSQL instead of Ruby to generate JSON responses"
published: true
tags: ruby, ruby on rails, postgresql, postgres_ext
---

What if I told you that you could generate the following JSON response
in PostgreSQL?

```json
{
  "tags":[
    {"id":1,"name":"Tag #0","note_id":1},
    {"id":1001,"name":"Tag #1000","note_id":1},
    {"id":2001,"name":"Tag #2000","note_id":1},
    ...
  ],
  "notes":[
    {
      "id":1,
      "title":"Note #0",
      "content":"Lorem ipsum...",
      "tag_ids":[9001,8001,7001,6001,5001,4001,3001,2001,1001,1]
    },
    {
      "id":2,
      "title":"Note #1",
      "content":"Lorem ipsum...",
      "tag_ids":[9002,8002,7002,6002,5002,4002,3002,2002,1002,2]
    }
  ]
}
```

What if I told you that it is over 10X faster than plain [ActiveModel::Serializers](https://github.com/rails-api/active_model_serializers/)
for small data sets, and 160X faster for larger data sets?

Typically when you have an API serving up JSON responses, your web
framework serializes your data after retrieving it with its ORM. We'll
talk about Rails specifically in this article, but this will generally
apply to most frameworks. So the typical Rails request will roughly
follow this flow (I am purposely brushing over some parts of the request
response cycle):

  1. Rails receives the JSON request from the browser/client
  2. Rails will apply some business logic and craft a query via
     ActiveRecord
  3. ActiveRecord serializes its query and sends the query to PostgreSQL
  4. PostgreSQL will compile the result set and serializes the records
     in its protocol format
  5. ActiveRecord deserializes the records into a set of rows object
  6. ActiveRecord will convert the set of rows into a set of model
     object instances
  7. Rails will convert the set of models objects into a JSON string
  8. Rails will send the JSON string down to the browser

Most of the time in this response cycle is spent in steps 6 and 7. Rails
has to deserialize one format, then store that deserialized content in
memory just to serialize it in a different format. Since [PostgreSQL
supports JSON responses](http://www.postgresql.org/docs/current/static/datatype-json.html),
we can use its [JSON functions](http://www.postgresql.org/docs/current/static/functions-json.html) to
serialized our result set. That JSON response will still be serialized
in PostgreSQL's protocol format, but ActiveRecord can deserialize it as
a single string object, instead of a set of objects which it then
converts and reserializes. We end up having this response cycle instead:

  1. Rails receives the JSON request from the browser/client
  2. Rails will apply some business logic and craft a query via
     ActiveRecord
  3. ActiveRecord serializes its query and sends the query to PostgreSQL
  4. PostgreSQL will compile the result set, serializes it as JSON then 
     serializes the JSON in its protocol format
  5. ActiveRecord deserializes the protocal format into a single JSON
     string
  6. Rails will send the JSON string down to the browser

We are only removing 2 steps, but it is the bulk of the time spent
generating the response. We are also limiting the number of ruby objects
created, so this reduces memory usage and time spent garbage collecting
short lived Ruby objects used only for JSONification.

# What Do We Gain by Generating Massive Queries for PostgreSQL

It takes a lot of work to tell PostgreSQL to generate a specific
JSON object; what exactly does that buy us?
By doing all this in PostgreSQL, we avoid using CPU cycles
and memory on our web server. I've done some very naive and basic
testing with a new, unoptimized Rails project, and a database of 1000
notes, each have 10 unique tags, totalling 10000 tags. When retrieving
all 11000 records with Rails and [ActiveModel::Serializers](https://github.com/rails-api/active_model_serializers), it took
roughly 9 seconds to generate the request. Most of the time was spent
in the View generating the JSON object in memory, with 657 milliseconds
in ActiveRecord, which (I think until someone tells me otherwise)
includes creating all the model instances.

When we apply the PostgreSQL technique outlined later in this article to the
same result set, the response only takes 72 milliseconds for the first
request. If we rerun this same request, PostgreSQL caching kicks in and
the response time is 54 milliseconds. That is a **~160X** throughput
increase when we use PostgreSQL to generate JSON payloads.

The above numbers are a bit skewed by the size of this test payload.
11000 objects would be completely crazy to present to an end user. If we
pare back our result set 10 notes and 100 tags, the first and second
response times for Ruby side JSONification  are 187 and 118 milliseconds.
When using PostgreSQL to generate our JSON payload, the response times
are 92 and 12 milliseconds. That is a **2X/10X** increase. By utilizing
PostgreSQL, we can increase our applications' response times and
throughput.

# Announce PostgresExt-Serializers

To utilize PostgreSQL, we have to generate a fairly complex query
manually. That is, until you include the [PostgresExt-Serializers](https://github.com/dockyard/postgres_ext-serializers)
gem into the project. PostgresExt-Serializers (PES) monkey
patches ActiveModel::Serializers (AMS),
and anywhere an ActiveRecord::Relation is serialized by AMS, PES will
take over and push the work to PostgreSQL. I wanted to use the awesome
work of AMS's DSL for generating JSON schemas without having to duplicate
that work. I am finding some pain points in terms of extracting the
information I need to generate the SQL query from AMS, but right now the
code for PES is very immature, hence the 0.0.1 release.

# Nitty-Gritty Details About How it All Works: Massive PostgreSQL Queries

Let's say we have an Ember application that we are generating the JSON
request for. The Ember app wants the list of notes, along with the tags
associated with the notes, and we will side load the tags. Side loading
allows you to specify the ids of the tags on the note, and then include
a list of tags, which will be used to instantiate the tags on the note.
The benefit of side loading is that it allows you to save bandwidth by
use tag ids and an array of de-duplicated tags, instead of embedding the
duplicate tags objects under the notes, where you would have to duplicate
the tag objects. We only want notes with `id < 40`, which is arbitrary
in this example, but, as we will see, has implications on the query we
need to execute.

Here is the whole query we need to generate the JSON required, which is
also the example JSON at the beginning of this article:

```sql
-- Note Ids
WITH notes_ids AS (
  SELECT id
  FROM "notes"
  WHERE "notes"."id" < 40
),
-- Tag Ids grouped by note id
tag_ids_by_notes AS (
  SELECT "tags"."note_id", array_agg("tags"."id") AS tag_ids
  FROM "tags"
  GROUP BY "tags"."note_id"
  HAVING "tags"."note_id" IN (
    SELECT "notes_ids"."id"
    FROM "notes_ids"
  )
),
-- Tag records
tags_attributes_filter AS (
  SELECT "tags"."id", "tags"."name", "tags"."note_id"
  FROM "tags"
  WHERE "tags"."note_id" IN (
    SELECT "notes_ids"."id"
    FROM "notes_ids"
  )
),
-- Tag records as a JSON array
tags_as_json_array AS (
  SELECT array_to_json(array_agg(row_to_json(tags_attributes_filter)))
AS tags, 1 AS match
  FROM "tags_attributes_filter"
),
-- Note records
notes_attributes_filter AS (
  SELECT "notes"."id", "notes"."content", "notes"."name",
coalesce("tag_ids_by_notes"."tag_ids", '{}'::int[]) AS tag_ids
  FROM "notes"
  LEFT OUTER JOIN "tag_ids_by_notes"
  ON "notes"."id" = "tag_ids_by_notes"."note_id"
  WHERE "notes"."id" < 40
),
-- Note records as a JSON array
notes_as_json_array AS (
  SELECT array_to_json(array_agg(row_to_json(notes_attributes_filter)))
AS notes, 1 AS match
  FROM "notes_attributes_filter"
),
-- Notes and tags together as one JSON object
jsons AS (
  SELECT "tags_as_json_array"."tags", "notes_as_json_array"."notes"
  FROM "tags_as_json_array"
  INNER JOIN "notes_as_json_array"
  ON "tags_as_json_array"."match" = "notes_as_json_array"."match"
)
SELECT row_to_json(jsons) FROM "jsons";
```

Let's break it down. You'll notice that I am making use of [Common Table
Expressions (CTEs)](http://www.postgresql.org/docs/9.3/static/queries-with.html). CTEs allow you to use temporary table definitions
in queries instead of embedding the subqueries directly in your query.

## Gathering our Note Ids

The first important step is getting the note ids of our final result
set, which we do with:

```sql
WITH notes_ids AS (
  SELECT id
  FROM "notes"
  WHERE "notes"."id" < 40
),
```
We are creating a CTE that represents the ids for our notes, we'll be
using this extensively to generate our tag related records.

## Getting Tag Ids Grouped by Note Ids

From our `note_ids`, we can assemble a list of tag ids grouped by notes.
This will be used to create the `tag_ids` attribute on the notes later
on.

```sql
tag_ids_by_notes AS (
  SELECT "tags"."note_id", array_agg("tags"."id") AS tag_ids
  FROM "tags"
  GROUP BY "tags"."note_id"
  HAVING "tags"."note_id" IN (
    SELECT "notes_ids"."id"
    FROM "notes_ids"
  )
),
```

Our projection is the `note_id`, plus an [`array_agg`](http://www.postgresql.org/docs/9.3/static/functions-aggregate.html) of the id of the
tags in our grouping. `array_agg` aggregates the group into an array.
This projection will return the following:

```text
note_id | tag_ids
=================
      1 | [1,2]
      2 | [1,3]
```

In this example, the tags `belong_to` a note, so we are retrieving this
data from the `tags` table. If this was a many-to-many relation, this
query would execute against the join table (i.e. `notes_tags`).

We group our tags by the `note_id`, and we use the `HAVING` clause to
only group tags which have a `note_id` contained in the `note_ids` CTE
that we created at the beginning.

## Generating Our Note Records

Most of the time, we don't want to expose all of our record data to
Ember, since whatever we send to the client will be accessible by the
user, whether we intend it to be or not. We filter down the attributes
sent to Ember by limiting the columns in our projection.

```sql
notes_attributes_filter AS (
  SELECT "notes"."id", "notes"."content", "notes"."name",
coalesce("tag_ids_by_notes"."tag_ids", '{}'::int[]) AS tag_ids
  FROM "notes"
  LEFT OUTER JOIN "tag_ids_by_notes"
  ON "notes"."id" = "tag_ids_by_notes"."note_id"
  WHERE "notes"."id" < 40
),
```

Also note that in the projection, we are using [`coalesce`](http://www.postgresql.org/docs/9.3/static/functions-conditional.html#FUNCTIONS-COALESCE-NVL-IFNULL)
to ensure that we return an empty array if a specific note has no `tag_ids`.
We are using a [`LEFT OUTER JOIN`](http://www.postgresql.org/docs/9.3/static/queries-table-expressions.html#QUERIES-JOIN) to combine our previously generated
tag id groupings with our notes. We use an `OUTER JOIN` instead of an
[`INNER JOIN`](http://www.postgresql.org/docs/9.3/static/queries-table-expressions.html#QUERIES-JOIN) so that all our notes are returned, even if no tags are
associated with it. An `INNER JOIN` would only return notes that have
tags associated with it. We also use the same `WHERE` predicate in this
query as we did in the `note_ids` CTE, to ensure our query only returns
the desired records.

## Turning Our Note Records into a Single JSON Array

So now that we have our notes records filtered down, we need to create a
JSON array of these records to use in our final query. At this point, we
will use two of PostgreSQL's [JSON functions](http://www.postgresql.org/docs/current/static/functions-json.html) and the `array_agg`
function that we used earlier. `row_to_json` takes a PostgreSQL row and
converts it to a JSON object, where the columns of the row converted
into JSON properties.

```text
foo | bar
=========
  1 |   2
```

Will be converted to

```text
     json
================
{ foo: 1, bar: 2 }
```

So at this point, our result set is a series of rows with a single
column of JSON representing the original PostgreSQL row from our
`notes_attribute_filter` CTE. We then use `array_agg` to turn the
rows of JSON objects into a single row with a single PostgreSQL
Array of JSON objects.

```text
     json
================
{ foo: 1, bar: 2 }
{ foo: 1, bar: 2 }
{ foo: 1, bar: 2 }
```

will be converted to

```text
                    Array
=======================================================
{{ foo: 1, bar: 2 },{ foo: 1, bar: 2 },{ foo: 1, bar: 2 }}
```

Lastly, we use `array_to_json` to convert the PostgreSQL array of JSON to a JSON array.

After  combining these pieces, we get the following query:

```sql
notes_as_json_array AS (
  SELECT array_to_json(array_agg(row_to_json(notes_attributes_filter)))
AS notes, 1 AS match
  FROM "notes_attributes_filter"
),
```

which yields

```text
    notes    | match
====================
[{},{},{},{}]|     1
```

We are using the `notes_attributes_filter` as our source for all the
JSON functions, and adding a column `match` with a value of `1`, which
we will need later.

## Aggregating Our Tag Records

We apply the attribute filtering and the aggregation techniques to our
`tags` table to generate our JSON array of tags. Note that when we
filter the tags attributes, we only include tags that have a `note_id`
of a note we are returning.

```sql
tags_attributes_filter AS (
  SELECT "tags"."id", "tags"."name", "tags"."note_id"
  FROM "tags"
  WHERE "tags"."note_id" IN (
    SELECT "notes_ids"."id"
    FROM "notes_ids"
  )
),

tags_as_json_array AS (
  SELECT array_to_json(array_agg(row_to_json(tags_attributes_filter)))
AS tags, 1 AS match
  FROM "tags_attributes_filter"
),
```

which yields

```text
    tags     | match
====================
[{},{},{},{}]|     1
```

## Combining Our Notes and Tags

So at this point, we have 2 CTEs that represent our notes and tags. We
need to combine these two tables into a single row, so that we can convert
that row to a JSON object with a `notes` and `tags` property. This is
the reason we added a `match` column onto both CTEs; we join those two
table into our final table, which we then call `row_to_json` on to get
our final JSON object, which mirrors the example at the beginning of
this article.

```sql
jsons AS (
  SELECT "tags_as_json_array"."tags", "notes_as_json_array"."notes"
  FROM "tags_as_json_array"
  INNER JOIN "notes_as_json_array"
  ON "tags_as_json_array"."match" = "notes_as_json_array"."match"
)
SELECT row_to_json(jsons) FROM "jsons";
```

So there you have it, you could generate this giant query by hand every
time you need to create an API endpoint, or you could use ActiveModel::Serializers
and utilize the PostgresExt-Seriliazers optimizations to avoid Ruby and
Rails when generating API responses.
