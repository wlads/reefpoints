---
layout: post
title: "Guarding with arrays"
comments: true
author: 'Brian Cardarella'
github: bcardarella
twitter: bcardarella
social: true
summary: A common pattern we use
published: true
tags: ruby, ruby on rails
---

This week I ran I applied a pattern I've been using for years to two
separate pull requests from our devs. (I like to review almost all of the
code that DockYard devs write)

In both cases I was able to help them refactor their code to use an
iterator as code guard instead of conditional statements. Let's take a
look at each example:

```ruby
users = User.where(type: 'employee')

if users.any?
  users.each do |user|
    # ...
  end
end
```

In this first example the `each` loop is avoided if the `users`
collection is empty. However, with arrays the iterator only acts on each
member of the collection so we don't need the avoid if the collection is
empty. We can refactor the above code into something like this:

```ruby
User.where(type: 'employee').each do |user)
   # ...
end
```

Much cleaner!

The next example may not be as straight forward but as we'll see with
Ruby we can clean this up nicely.

```ruby
if params[:ids]
  params[:ids].each do |id|
    # ...
  end
end
```

Here we have a situation where `params[:ids]` could contain a collection
of data. Or it could be `nil`. Because of this we cannot just assume we
can always iterate over that value. In Ruby we can create a new `Array`:

```ruby
Array([1,2,3])
# => [1,2,3]

Array(nil)
# => []
```

Notice in the second example that when we passed `nil` it created an
**empty array**. Knowing this we can refactor our code:

```ruby
Array(params[:ids]).each do |id|
  # ...
end
```

If you find yourself putting guards around enumerators odds are you can
refactor in a similar manner as I've shown above.

BTW, I've been using this pattern for years but I don't know if there is
an actual name for this. If you do please share!
