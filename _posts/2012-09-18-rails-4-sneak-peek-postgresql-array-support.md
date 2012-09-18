---
layout: post
title: "Rails 4.0 Sneak Peek: PostgreSQL array support"
comments: true
author: Dan McClain
twitter: "_danmcclain"
github: danmcclain
category: ruby
social: true
summary: "Storing arrays natively in PostgreSQL is now supported by Rails"
published: false
---

I'm happy to announce that [Rails 4.0 now has support for PostgreSQL
arrays](https://github.com/rails/rails/pull/7547). You can create an
array column easily at the time of migration by adding `:array => true`.
Creating an array column will respect the other options you add to the
column (`length`, `default`, etc). 

{% highlight ruby %}
create_table :table_with_arrays do |t|
  t.integer :int_array, :array => true
  # integer[]
  t.integer :int_array, :array => true, :length => 2
  # smallint[]
  t.string :string_array, :array => true, :length => 30
  # char varying(30)[]
end 
{% endhighlight %}

It should be noted when setting the default value for an array column,
you should use PostgreSQL's array notation for that value
(`{value,another value}`). If you want the default value to be an empty
array you would have `:default => '{}'`.

{% highlight ruby %}
create_table :table_with_arrays do |t|
  t.integer :int_array, :array => true, :default => '{}'
  # integer[], default == []
  t.integer :int_array, :array => true, :length => 2, :default => '{1}'
  # smallint[], default == [1]
end 
{% endhighlight %}

## An example of a model with an array value

Let's say that we have a user model, which has a formal first and last
name, and also a number of nicknames (I rarely ever go by Daniel). The
following code would create the table we need to store this.

{% highlight ruby %}
create_table :users do |t|
  t.string :first_name
  t.string :last_name
  t.string :nicknames, :array => true
end
{% endhighlight %}

And we have a simple model for this table:

{% highlight ruby %}
class User < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :nicknames
end
{% endhighlight %}

Where we don't have a default value, if we instantiate a User object
with the following

{% highlight ruby %}
john = User.create(:first_name => 'John', :last_name => 'Doe')
{% endhighlight %}

If we call `john.nicknames`, `nil` would be returned, and is stored as
`NULL` in PostgresSQL. We can set the nicknames attribute at the time of
creation with

{% highlight ruby %}
john = User.create(:first_name => 'John', :last_name => 'Doe',
  :nicknames => ['Jack', 'Johnny'])
{% endhighlight %}

If we then retrieved this record from the database, the `nicknames`
value would be casted to an array, instead of returning the string of
`{Jack,Johnny}`.  Rails 4.0 has a pure ruby array value parser, but if
you would like to speed up the parsing process, the previously mentioned
[pg_array_parser](https://github.com/dockyard/pg_array_parser)
gem will be used if it is available. PgArrayParser has
a C extension, and a Java implementation for JRuby (although the gem
currently broken in JRuby, this is something I am fixing now).

One important thing to note when interacting with array (or other
mutable values) on a model.  ActiveRecord does not currently track
"destructive", or in place changes. These include array `push`ing and
`pop`ing, `advance`-ing DateTime objects. If you want to use a
"destructive" update, you must call `<attribute>_will_change!` to let
ActiveRecord know you changed that value. With our User model, if we
wanted to append a nickname, you can do the following:

{% highlight ruby %}
john = User.first

john.nicknames += ['Jackie boy']
# or
john.nicknames = john.nicknames.push('Jackie boy')
# Any time an attribute is set via `=`, ActiveRecord tracks the change
john.save

john.reload
john.nicknames
#=> ['Jack', 'Johnny', 'Jackie Boy']

john.nicknames.pop
john.nicknames_will_change!
# '#pop' changes the value in place, so we have to tell ActiveRecord it changed
john.save
{% endhighlight %}

One last note about arrays in PostgreSQL: there are no element count
constraints, and any array can be multidimensional. With the
multidimensional arrays, they must be "square" (aka, elements in an
array have to be either values, or arrays, not mixed).

{% highlight ruby %}
[ [1,2,3], [2,3], []]
# Valid array value in PostgreSQL
[ 1,2,[3,4]]
# Invalid array, we are mixing values and arrays at a single level
{% endhighlight %}

In my next article, I will talk about querying PostgreSQL arrays in both
postgres\_ext and Rails 4.0. Go forth and use arrays in Rails 4.0!
