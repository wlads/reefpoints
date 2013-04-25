---
layout: post
title: 'Design Patterns: The Template Method Pattern'
comments: true
author: 'Doug Yun'
twitter: 'dougyun'
github: duggieawesome
category: ruby, design_patterns
social: true
summary: 'Exploring design patterns and their applications.'
published: false
---

## Our First Day in Construction

### The Right Tools

In his seminal book, [Code Complete](http://www.cc2e.com/Default.aspx),
Steve McConnell introduces the analogy between creating software and
building houses, and in this blog entry, we'll be running with that
comparison.

Quite simply, design patterns are just tools that help us construct software. However,
just like tools, we need to use the correct and proper one for the task. We
cooooould use a hammer on screws, but we'd be better off using a
power drill. Before using any one of the numerous design patterns, it is
crucial to understand the problem we wish to solve.

However, unlike tools, *it is incorrect to use a particular design pattern on the wrong
type of problem*. In other words, it is poor practice to use a
particular design pattern on a problem that does not require
aforementioned design pattern.

In other words, it is in poor practice to use a design pattern
if the specific problem, in which the particular design pattern is
supposed to solve, arises.

In this series, we'll explore various design patterns and discuss
when to apply them. Our topic for today will be the *Template Method* pattern.

### Let's Build Some Walls

Today, we've been asked by our foreman to build a couple of walls. All
the walls will share the same dimensions and will be made from the same
material (for this construction project, our foreman has given us an
"easy" set of requirements).

{% highlight ruby %}
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
{% endhighlight %}

What a nice boss, he's handed us the blueprints!
Now it's just up to us to build out the `Wall`.

{% highlight ruby %}
class Wall
  def dimensions
    'I am 30ft. long and 20ft. wide!'
  end

  def made_from
    'I am made from brick!'
  end
end
{% endhighlight %}

Nice! Our tests pass, everybody is happy, and we're off to lunch!

### A Hammer or a Nailgun?

Coming back to the site, our foreman has informed us that we need more
walls. "That's a piece of cake," we reply, recalling how easy it was to
build out the `Wall`.

"Not so fast," our foreman retorts. We're given new blueprints with
different wall requirements.

{% highlight ruby %}
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
    concrete_wall.dimensions.must_equal 'I am 20ft. long and 20ft. wide!'
  end

  it 'should be made from brick' do
    concrete_wall.made_from.must_equal 'I am made from concrete!'
  end
end

# Blueprints for a WoodWall
describe WoodWall do
  let(:wood_wall) { WoodWall.new }

  it 'should state its dimensions' do
    wood_wall.dimensions.must_equal 'I am 10ft. long and 20ft. wide!'
  end

  it 'should be made from brick' do
    wood_wall.made_from.must_equal 'I am made from wood!'
  end
end
{% endhighlight %}

Hmm... A couple of ideas run through our heads. We could follow the initial `Wall` class and
define each method, hardcoding each string output, for the `BrickWall`, `ConcreteWall`, and `WoodWall`
classes. That seems like an okay idea, but we'd have to hard code each
instance method. What if our house requires a dozen different types of walls?

### Open That Toolbox!

Sipping on our after-lunch coffee, we realize that we've got a tool right
for the job, the *Template Method* pattern.

In the *Template Method* pattern, the creation of a *skeletal class* will
serve as the basis for various *subclasses*. Within the *skeletal class*
there are *abstract methods*, which in turn, will be overridden by the
methods of *subclasses*. Essentially, we'll define a `Wall` class (our
*skeletal class*) and its *subclasses*, `BrickWall`, `ConcreteWall`, and
`WoodWall`.

Going over the blueprints, we notice that the three different classes of
walls each contain the methods `dimensions` and `made_from`, which
result in slighty different strings. With this knowledge, let's
create our `Wall` class and its subclasses.

{% highlight ruby %}
class Wall
  def dimensions
    "I am #{length}ft. long and #{width}ft. wide!"
  end

  def made_from
    "I am made from #{material}!"
  end
end

class BrickWall < Wall
  private

  def length
    30
  end

  def width
    20
  end

  def material
    'brick'
  end
end

class ConcreteWall < Wall
  private

  def length
    30
  end

  def width
    20
  end

  def material
    'brick'
  end
end

class WoodWall < Wall
  private

  def length
    30
  end

  def width
    20
  end

  def material
    'brick'
  end
end
{% endhighlight %}
