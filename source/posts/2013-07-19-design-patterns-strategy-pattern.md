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
Method](http://reefpoints.dockyard.com/ruby/2013/07/10/design-patterns-template-pattern.html)*
pattern and its benefits, finding it most useful when we need to simply shape
behavior of *subclasses*. However, due to the reliance on *inheritance*,
there are a couple of limitations to this pattern:

* subclasses are tightly bound to a superclass or baseclass
* runtime flexibility is hindered
* varies only a portion of the desired alogrithm 

Thankfully, there is another design pattern that resolves these
problems: the *Strategy* pattern.

## Summertime and the Livin' is Easy

### Hot dogs, hamburgers, and veggie patties

It's the middle of July, and there's no better time to throw a day
party. Our pals are bringing the tasty beverages, so we just need to prepare the food.

We'll first create a superclass `Food` that will delagate `#type` to its subclasses: `HotDog`, `Hamburger`, and `VeggiePatty`. Recall that this is the *[Template Method](http://reefpoints.dockyard.com/ruby/2013/07/10/design-patterns-template-pattern.html)* pattern.

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

hotdogs = HotDog.new.type       # => 'hot dogs'
hamburgers = Hamburger.new.type # => 'hamburgers'
veggies_patties = VeggiePatty.new.type  # => 'veggie patties'
```
Now, let's start the grill!

```ruby
class Grill
  attr_accessor :food

  def fired_up?
    true
  end

  def grill
    "Grilling the #{food}!"
  end
end

grill = Grill.new
grill.fired_up? # => true
```
Nice. The grill is hot and ready. Time to throw the food on.

```ruby
grill.food = hotdogs
grill.cook # => "Grilling the hot dogs!"
grill.food = hamburgers 
grill.cook # => "Grilling the hamburgers!"
grill.food = veggie_patties
grill.cook # => "Grilling the veggie patties!"
```
### Foods Ready!
