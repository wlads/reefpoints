---
layout: post
title: 'Design Patterns: The Composite Pattern'
comments: true
author: 'Doug Yun'
twitter: 'dougyun'
github: duggiefresh
social: true
summary: 'Exploring design patterns and their use cases'
published: true
tags: design patterns, ruby
---

## Coffee Coffee

If you're anything like me, you'll agree that every morning needs to start
out with a cup of coffee. And, if you're anything like me, you'll have
at least three different coffee making apparatuses. And, if you're
anything like me... you'll soon realize you may have an addiction.

Joke aside, each coffee contraption requires a specific procedure
to be completed in order to brew a cup of joe; each having multiple parts,
taking differing amounts of time, requiring various numbers of steps, etc.

Our coffee making process can be described by a basic example
of the *Composite* method pattern.

## The Best Part of Waking Up is a Composite Pattern in Your Cup

We can start by thinking of each coffee maker and coffee related task as a *subclass* of
our `CoffeeRoutine`. `CoffeeRoutine` will be known as the *component*, the base
class or interface that possesses the commonalities of simple and complex
objects. `CoffeeRoutine#time` is the common trait among all
coffee related classes.

```ruby
class CoffeeRoutine
  attr_reader :task

  def initialize(task)
    @task = task
  end

  def time
    0.0
  end
end
```

Next, we'll create a couple of *leaf* classes, which represent
indivisble portions of our pattern. Here are a couple of *leaf* classes
that come to mind: `GrindCoffee` and `BoilWater`. These *leaf* classes are
our most basic steps to making coffee.

```ruby
class GrindCoffee < CoffeeRoutine
  def initialize
    super 'Grinding some coffee!'
  end

  def time
    0.5
  end
end

class BoilWater < CoffeeRoutine
  def initialize
    super 'Boiling some water!'
  end

  def time
    4.0
  end
end

class AddCoffee < CoffeeRoutine
  def initialize
    super 'Adding in the coffee!'
  end

  def time
    1.0
  end
end
```

```
g = GrindCoffee.new

g.task    # => 'Grinding some coffee!'
g.time    # => 0.5
```

Now, we can get to the namesake of the pattern: the *composite* class. A
*composite* class is a *component* that also contain
*subcomponents*. *Composite* classes can be made up of smaller
*composite* classes or *leaf* classes.

Our various coffee making apparatuses can be thought of as *composites*.
Let's check out the `FrenchPress` class:

```ruby
class FrenchPress < CoffeeRoutine
  attr_reader :task, :steps

  def initialize(task)
    super 'Using the French press to make coffee'
    @steps = []
    add_step BoilWater.new
    add_step GrindCoffee.new
    add_step AddCoffee.new
  end

  def add_step(step)
    steps << step
  end

  def remove_step(step)
    steps.delete step
  end

  def time_required
    total_time = 0.0
    steps.each { |step| total_time += step.time }
    total_time
  end
end
```

However, we can simplify the `FrenchPress` class by pulling out the
*composite* functionality into its own class.

```ruby
class CompositeTasks < CoffeeRoutine
  attr_reader :task, :steps

  def initialize(task)
    @steps = []
  end

  def add_step(step)
    steps << step
  end

  def remove_step(step)
    steps.delete step
  end

  def time_required
    total_time = 0.0
    steps.each { |step| total_time += step.time }
    total_time
  end
end
```

Now we can create *composite* coffee makers easily... They'll look
something like this:

```ruby
class FrenchPress < CompositeTasks
  def initialize
    super 'Using the FrenchPress to make coffee!!!'
    add_step GrindCoffee.new
    add_step BoilWater.new
    add_step AddCoffee.new
    # ... Omitted actual steps to make coffee from a French press ...
    # ... Imagine PressPlunger class has been defined already ...
    add_step PressPlunger.new
  end
end

class DripMaker < CompositeTasks
  def initialize
    super 'Using the DripMaker to make coffee!!!'
    add_step GrindCoffee.new
    add_step BoilWater
    add_step AddCoffee.new
    # ... Imagine PressStartButton class has been defined already ...
    add_step PressStartButton.new
  end
end
```

Swell... now we can call the `FrenchPress` and `DripMaker` coffee makers.

```
frenchpress = FrenchPress.new

# => #<FrenchPress:0x007f88fcf46410
       @task="Using the FrenchPress to make coffee!!!",
       @steps=
         [#<GrindCoffee:0x007f88fcf46370 @step="Grinding some coffee!">,
         #<BoilWater:0x007f88fcf46320 @step="Boiling some water!">]>
         #<AddCoffee:0x007f88fcf46329 @step="Adding in the coffee!">]>
         #<PressPlunger:0x007f88fcf46098 @step="Pressing the plunger down!">]>

dripmaker = DripMaker.new

# => #<DripMaker:0x137t88fcf57109
       @task="Using the DripMaker to make coffee!!!",
       @steps=
         [#<GrindCoffee:0x007f88fcf46370 @step="Grinding some coffee!">,
         #<BoilWater:0x007f88fcf52520 @step="Boiling some water!">]>
         #<AddCoffee:0x007f88fcf46123 @step="Adding in the coffee!">]>
         #<PressStartButton:0x007f88fcf46432 @step="Pushing the start button!">]>
```

Now we can also check the time required for each coffee maker.

```
frenchpress.time_required # => 12.4
dripmaker.time_required   # => 8.5
```

## Discussion

Implementing the *Composite* pattern is pretty simple.

We create a *component* class that ties the numerous simple and
complex characteristics together. In our example, `CoffeeRoutine`
defines an elementary method `#time` and each child class implements
its own amount.

Next, we create *leaf* classes, `AddCoffee`, `BoilWater`, and `GrindCoffee`,
that share the same characteristics with one another. Remember that it's the nature
of *leaf* classes to be simple. If you happen across a *leaf* class that
could be broken up, it might potentially be a *composite* class in disguise.
Break up those actions into individual *leaf* classes and turn the original class
into a *composite*. All of our *leaf* classes had a `#time` method.

The *composite* class handles all the subtasks, essentially using the child classes
at its will. We can see that our two *composite* classes and their methods, `FrenchPress#time_required`
and `DripMaker#time_required`. manipulate the method `#time` from the *leaf* classes.
Ultimately, our coffee makers are able to treat each step,
`GrindCoffee`, `BoilWater` and `AddCoffee` uniformly.

Hope this helps you with your morning routine!
