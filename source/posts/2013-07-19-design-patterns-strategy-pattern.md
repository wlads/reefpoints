---
layout: post
title: 'Design Patterns: The Strategy Pattern'
comments: true
author: 'Doug Yun'
twitter: 'DougYun'
github: duggiefresh
legacy_category: ruby
social: true
summary: 'Exploring design patterns and their use cases'
published: false
tags: software design patterns
---

## Walls are sooooo last week...

In our last post, we discussed the *[Template
Method](http://reefpoints.dockyard.com/ruby/2012/07/10/design-patterns-template-pattern.html)*
pattern and its benefits, finding it most useful when we need to simply shape
behavior of *subclasses*. However, due to the reliance on *inheritance*,
there are a couple of limitations to this pattern:

* Subclasses are tightly bound to a superclass or baseclass
* Runtime flexibility is hindered
* Only a portion of the desired alogrithm is varied

Thankfully, there is another design pattern that resolves these
problems: the *Strategy* pattern.

## Summertime and the Livin' is Easy

### Hot dogs, hamburgers, and veggie patties

It's the middle of July, and there's no better time to throw a day
party. Our pals are bringing the tasty beverages, so we just need to prepare the food.

We'll first create a superclass `Food` that will delagate `#type` to its
subclasses: `HotDog`, `Hamburger`, and `VeggiePatty`. Notice that this
is the *[Template
Method](http://reefpoints.dockyard.com/ruby/2013/07/10/design-patterns-template-pattern.html)*
pattern in action.

```ruby
class Food
  def type
    raise NotImplementedError, 'Ask the subclass'
  end
end

class HotDog < Food
  def type
    'hot dogs'
  end
end

class Hamburger < Food
  def type
    'hamburgers'
  end
end

class VeggiePatty < Food
  def type
    'veggie patties'
  end
end
```
Now, let's get the grill ready.

```ruby
class Grill
  attr_accessor :food

  def initialize food
    @food = food
  end

  def grilling
    "Grilling the #{food.type}!"
  end
end
```
Nice. Now let's get grilling! We'll start with some hot dogs.

### 

```ruby
grill = Grill.new(HotDog.new)
grill.grilling # => "Grilling the hot dogs!"
```

Oh watch out, these dogs are almost done... time to throw on the
hamburger and veggie patties.

```ruby
grill.food = Hamburger.new
grill.grilling # => "Grilling the hamburgers!"

grill.food = VeggiePatty.new
grill.grilling # => "Grilling the veggie patties!"
```

Wasn't that easy? We were able to switch out food types without
creating a new class of `Grill`. 

## Discussion

### Strategies and Context

The *Strategy* pattern employs *strategies*, a group of objects that do
the same thing. Our grill party relies on *strategies* to tell us what
`#type` of food they were. It's important that all strategy objects have
the same responsiblity and support the same interface, which in our case
was `grill.cook`.

The `Grill` class is our *context* class, the employer of the
*strategies*, which can use the `HotDog`, `Hamburger`, and `VeggiePatty`
classes interchangeably.

Through our contrived example, we earn immediate benefits:

* *Separation of concerns*
* *Strategies* at runtime

We've achieved *separation of concerns* by designating the `#type`
method as our desired set of *strategies*. `HotDog`, `Hamburger` and
`VeggiePatty`  are unaware of our implementation of `Grill#grilling`.

### Special Patties
