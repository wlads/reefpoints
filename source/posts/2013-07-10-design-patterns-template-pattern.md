---
layout: post
title: 'Design Patterns: The Template Method Pattern'
comments: true
author: 'Doug Yun'
twitter: 'DougYun'
github: duggiefresh
legacy_category: ruby
social: true
summary: 'Exploring design patterns and their use cases'
published: true
---
## Introduction

As the field of software development grows, we developers are
continuously trying to catch up with the latest technologies.
Fortunately, the craft of writing maintainable code is language
agnostic, and in this series of blogposts, we'll focus on a powerful set of
timeless tools: *Design Patterns*.

I highly recommend Russ Olsen's book [Design
Patterns in Ruby](http://designpatternsinruby.com/). Our series
will draw inspiration from it and is brief in comparison. So if you
enjoy these posts (and I hope you do!), the book will be a great
investment.

We'll explore various design patterns and learn
when to apply them. Our topic for today will be the *Template Method*
pattern, the simplest design pattern.

## Our First Day in Construction

### The Right Tools

Quite simply, design patterns are just tools that help us construct software. However,
just like tools, we need to use the correct and proper one for the task. We
could use a hammer on screws, but we'd damage the wood planks and using a
power drill will be much more efficient. Before using any one of the numerous design patterns, it is
crucial to understand the problem we wish to solve.

*It is incorrect to use a particular design pattern on the wrong
type of problem*. In other words, it is in poor practice to use a
particular design pattern on a problem that does not require the
aforementioned design pattern.

### Let's Build Some Walls

Today, we've been asked by our foreman to build a couple of walls. All
the walls will share the same dimensions and will be made from the same
material (for this construction project, our foreman has given us an
"easy" set of requirements).

```ruby
# Blueprints for Wall
require 'minitest/autorun'

describe Wall do
  let(:wall) { Wall.new }

  it 'should state its dimensions' do
    wall.dimensions.must_equal 'I am 30ft. long and 20ft. wide!'
  end

  it 'should be made from brick' do
    wall.made_from.must_equal 'I am made from brick!'
  end
end
```

What a nice boss, he's handed us the blueprints!
Now it's just up to us to build out the `Wall`.

```ruby
class Wall
  def dimensions
    'I am 30ft. long and 20ft. wide!'
  end

  def made_from
    'I am made from brick!'
  end
end
```

Nice! Our tests pass, everybody is happy, and we're off to lunch!

### A Hammer or a Nailgun?

Coming back to the site, our foreman has informed us that we need more
walls. "That's a piece of cake," we reply, recalling how easy it was to
build out the `Wall`.

"Not so fast," our foreman retorts. We're given new blueprints with
different wall requirements.

```ruby
# Blueprints for a BrickWall
describe BrickWall do
  let(:brick_wall) { BrickWall.new }

  it 'should state its dimensions' do
    brick_wall.dimensions.must_equal 'I am 30ft. long and 20ft. wide!'
  end

  it 'should be made from brick' do
    brick_wall.made_from.must_equal 'I am made from brick!'
  end
end

# Blueprints for a ConcreteWall
describe ConcreteWall do
  let(:concrete_wall) { ConcreteWall.new }

  it 'should state its dimensions' do
    concrete_wall.dimensions.must_equal 'I am 30ft. long and 20ft. wide!'
  end

  it 'should be made from concrete' do
    concrete_wall.made_from.must_equal 'I am made from concrete!'
  end
end

# Blueprints for a WoodWall
describe WoodWall do
  let(:wood_wall) { WoodWall.new }

  it 'should state its dimensions' do
    wood_wall.dimensions.must_equal 'I am 10ft. long and 20ft. wide!'
  end

  it 'should be made from wood' do
    wood_wall.made_from.must_equal 'I am made from wood!'
  end
end
```

Hmm... A couple of ideas run through our heads. We could follow the initial `Wall` class and
define each method, hardcoding each string output, for the `BrickWall`, `ConcreteWall`, and `WoodWall`
classes. That seems like an okay idea, but we'd have to hard code each
instance method. What if our house requires a dozen different types of walls?

### Open That Toolbox!

Sipping on our after-lunch coffee, we realize that we've got a tool right
for the job, the *Template Method* pattern.

In the *Template Method* pattern, the creation of a *skeletal class* will
serve as the basis for various *subclasses* or *concrete classes*. Within the *skeletal class*
there are *abstract methods*, which in turn, will be overridden by the
methods of *subclasses*. Essentially, we'll define a `Wall` class (our
*skeletal class*) and its *subclasses*, `BrickWall`, `ConcreteWall`, and
`WoodWall`.

Going over the blueprints, we notice that the three different classes of
walls each contain the methods `#dimensions` and `#made_from`, which
result in slighty different strings. With this knowledge, let's
create our `Wall` class and its subclasses.

```ruby
class Wall
  def dimensions
    "I am #{length}ft. long and #{width}ft. wide!"
  end

  def made_from
    "I am made from #{material}!"
  end

  private

  def length
    30
  end
end

class BrickWall < Wall
  private

  def width
    20
  end

  def material
    'brick'
  end
end

class ConcreteWall < Wall
  private

  def width
    20
  end

  def material
    'concrete'
  end
end

class WoodWall < Wall
  private

  def length
    10
  end

  def width
    20
  end

  def material
    'wood'
  end
end
```

## Discussion

### Hook Methods

Within the `Wall` class we have defined a private method called `#length`
because we see that `BrickWall` and `ConcreteWall` share the same
length. As for the `WoodWall` class, we simply overwrite the `#length`
and give it a value of `10`. These are examples of *Hook Methods*.

*Hook Methods* serve two purposes:

1. Override the skeletal implementation and define something new
2. Or, accept the default implementation

Please note that the default implemetation, within the skeletal class, does
not necessarily need to define a method. For example, we could have had:

```ruby
class Wall

  ...

  private

  def length
    raise NotImplementedError, 'Sorry, you have to override length'
  end
end

class BrickWall < Wall
  private

  ...

  def length
    30
  end
end
```

In the example above, the `#length` method within the `Wall` class
served as a placeholder for the `#length` for the `BrickWall`, it's
*concrete class*. Essentially, *hook methods* inform all *concrete
classes* that the method may require an override. If the base
implementation is undefined the subclasses must define the *hook
methods*.

## Those Are Some Nice Walls

Our foreman is delighted with the results and we're going to call it a
day. As we can see, using the *Template Method* pattern is not difficult
at all. We first defined a base class, within which we defined necessary
*hook methods* to be overridden by our *subclasses*. Of course, this
particular design pattern does not solve every conceivable problem, but
helps keep our code clean by the use of inheritance.

Next we'll be discussing the *Strategy* method pattern. Stay tuned!
