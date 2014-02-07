---
layout: post
title: 'Using Database Templates in Rails'
comments: true
author: 'Romina Vargas'
github: rsocci
social: true
summary: Discover a helpful Postgres config option
published: false
tags: ruby on rails, postgresql
---

Using Postgres as your application's database? If so, there is a handy
configuration option that you may not be aware about. The `pg` gem provides a `template` option that
allows for copying already existing data into an application as
long as you have matching schema. 

To add this functionality, simply add the `template` option inside `config/database.yml`:

```yaml
development:
  adapter: postgresql
  encoding: unicode
  database: myapp_development
  template: my_template
```

Let's go through a quick example. Suppose we have an existing database, `food`, and it contains an abundant amount of data with the
following schema:

```
foods: name (string), category_id (integer)
categories: category (string)
```

To use the `food` database for our application, we are going to
create a template by specifying our database with the following command: 

```bash
createdb -T food my_food_template
```

We must now set up our Rails application and make sure that our schema matches
that of our new template. Our Rails models will mimick `food`. Having done
that, we can now modify our `config/database.yml`.

```yaml
database: myapp_development
template: my_food_template
```

Run migrations and violà! Our database has been populated and is ready to be used.

```bash
> psql myapp_development

> select * from foods;
  id |  name  | category_id
  --------------------------
  1   apple       1
  2   banana      1
  3   spinach     2
  4   ice cream   3

> select * from categories;
  id |  category
  --------------
  1   fruit
  2   vegetable
  3   other
```
