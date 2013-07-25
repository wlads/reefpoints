---
layout: post
title: 'Design Patterns: The Strategy Pattern'
comments: true
author: 'Doug Yun'
twitter: 'DougYun'
github: duggiefresh
social: true
summary: 'Exploring design patterns and their use cases'
published: true
tags: software design patterns, ruby
---

## Walls are sooooo last week...

In our last post, we discussed the *[Template
Method](http://reefpoints.dockyard.com/ruby/2013/07/10/design-patterns-template-pattern.html)*
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

Wasn't that easy? We were able to switch out items without
creating a new class of `Grill`. 

## Discussion

### Strategies and Context

The *Strategy* pattern employs *strategies*, objects of which
possess identical behavior. Our grill party relies on *strategies* to
tell us what `#type` of food they were. It's important that all strategy objects
have the same responsiblity and support the same interface, which in our case
was `grill.grilling`.

The `Grill` class is our *context* class, the operator of the
*strategies*, which uses the `HotDog#type`, `Hamburger#type`, and
`VeggiePatty#type` interchangeably.

Through our contrived example, we see the immediate benefits of this
design pattern:

* *Separation of concerns*
* *Strategies* at runtime

We've achieved *separation of concerns* by designating the `#type`
method as our desired set of *strategies*. `HotDog`, `Hamburger` and
`VeggiePatty`  are unaware of our implementation of `Grill#grilling`.

As for runtime flexibility, we're able to switch out the items up on the
grill.

### Special Patties: Lambdas

As we're grilling our hamburger and veggies patties, a last minute guest
arrives, and she has brought some bacon, jalapeños, and onions.
Let's make some custom patties, but avoid creating more subclasses of
`Food`. What could we do here?

A quick and awesome solution would be to use *lambdas*!

Since we expect our *strategies* to return `Strings` for food `#type`,
we can create a *lambda* which will behave just like the other strategy
objects and return a `String`.

```ruby
CUSTOMPATTY = lambda { |type| "#{type}" }
```

Next, let's get back to our `Grill` class and alter the class a little
bit.

```ruby
class Grill
  attr_accessor :food

  def initialize food
    @food = food
  end

  def grilling
    "Grilling the #{print_food}!"
  end

  private

  def print_food
    food_is_string? ? food : food.type
  end

  def food_is_string?
    food.is_a? String
  end
end
```

Since we know the *strategies* are `Strings`, we've created two
`private` methods, `#print_food` and `#food_is_string`.
`#food_is_string` will check if `Grill` has received a
`String` or not, and `#print_food` will handle *lambdas* or *classes* of
food.

Now let's try grilling some hot dogs and custom patties!

```ruby
jalapeños = CUSTOMPATTY.call 'spicy jalapeños patties'
bacon = CUSTOMPATTY.call 'greasy, yummy bacon patties'

grill = Grill.new jalapeños
grill.grilling # => "Grilling the spicy jalapeños patties!"

grill.food = bacon
grill.grilling # => "Grilling the greasy, yummy bacon patties!"

grill.food = HotDog.new
grill.grilling # => "Grilling the hot dogs!"
```

### Mmm-mmmm... That is a tasty burger.

The *Strategy* pattern is a delagation-based design pattern, and shares
some similarities with the *Template Method* pattern. However, instead
of depending so heavily on inheiritance between a superclass and
subclasses to use our target algorithm, we take our algorithm and
consider it as a separate object. As long as we remember the
relationship between the *strategies* and the *context*, we earn real
advantages over the *Template Method*, as seen in our custom patty
example.

I hope you had fun at our day party, and we'll next explore the
*Observer* pattern.
