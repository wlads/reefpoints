---
layout: post
title: 'Design Patterns: The Template Pattern'
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
building houses. As we pour the concrete foundation and put up walls, an
incredible amount of tools will be used. For example, a hammer will allow us to pound
nails into walls, but if we use a nail gun, we'll get the same task
done before lunch.

Design patterns are tools that help us construct software. However,
just like tools, we need to use the correct one for the task. We
cooooould use a hammer on screws, but we'd be better off using a
power drill. Before using any one of the numerous design patterns, it is
crucial to understand the problem we wish to solve.

Simply, *it is incorrect to use a particular design pattern on the wrong
problem*.

In this series, we'll will explore various design patterns and discuss
when to apply them. Today, we'll focus on the *Template Pattern*.

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

  it 'should have a length of 30 feet' do
    wall.length.must_equal 30
  end

  it 'should have a height of 20 feet' do
    wall.height.must_equal 20
  end

  it 'should be made from brick' do
    wall.material.must_equal 'brick'
  end
end
{% endhighlight %}

What a nice boss, he's handed us the blueprints!
Now it's just up to us to build out the `Wall`.

{% highlight ruby %}
class Wall
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

Nice! Our tests pass, everybody is happy, and we're off to lunch!

### A Hammer or a Nailgun?

Coming back to the site, our foreman has informed us that we need more
walls. "That's a piece of cake," we reply, recalling how easy it was to
build out the `Wall`.

"Not so fast," our foreman retorts. We're given new blueprints with
different wall requirements.

{% highlight ruby %}
# Blueprints for a BrickWall
describe BrickWall
  let(:brick_wall) { BrickWall.new }

  it 'should have a length of 30 feet' do
    brick_wall.length.must_equal 30
  end

  it 'should have a height of 20 feet' do
    brick_wall.height.must_equal 20
  end

  it 'should be made from brick' do
    brick_wall.material.must_equal 'brick'
  end
end

# Blueprints for a ConcreteWall
describe ConcreteWall
  let(:concrete_wall) { ConcreteWall.new }

  it 'should have a length of 10 feet' do
    concrete_wall.length.must_equal 10
  end

  it 'should have a height of 20 feet' do
    concrete_wall.height.must_equal 20
  end

  it 'should be made from concrete' do
    concrete_wall.material.must_equal 'concrete'
  end
end

# Blueprints for a WoodWall
describe WoodWall
  let(:wood_wall) { WoodWall.new }

  it 'should have a length of 20 feet' do
    wood_wall.length.must_equal 20
  end

  it 'should have a height of 20 feet' do
    wood_wall.height.must_equal 20
  end

  it 'should be made from wood' do
    wood_wall.material.must_equal 'wood'
  end
end
{% endhighlight %}

Hmm... What could we do here?

### Open That Toolbox!

{% highlight ruby %}
require 'minitest/autorun'
{% endhighlight %}
