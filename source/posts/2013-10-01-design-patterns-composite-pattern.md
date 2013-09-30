---
layout: post
title: 'Design Patterns: The Composite Pattern'
comments: true
author: 'Doug Yun'
twitter: 'dougyun'
github: duggiefresh
social: true
summary: 'Exploring design patterns and their use cases'
published: false
tags: software design patterns, ruby
---

## Coffee Coffee

If you're anything like me, you'll agree that every morning needs to start
out with a cup of coffee. And, if you're anything like me, you'll have
at least three different coffee making apparatuses. And, if you're
anything like me... you'll soon realize you may have an addiction.

Joke aside, each coffee contraption requires a specific procedure
to be completed in order to brew a cup of joe; each having multiple parts,
taking differing amounts of time, requiring various numbers of steps, etc.

This coffee making process can described pretty well with the *Composite* method
pattern.

## The Best Part of Waking Up is a Composite Pattern in Your Cup

We can start by thinking of each coffee maker and coffee related task as a *subclass* of
our `CoffeeRoutine`. `CoffeeRoutine` will be known as the *component*, the base
class or interface that possesses the commonalities of basic and complex
objects. `CoffeeRoutine#time_required` is the common trait among all
coffee related tasks.

```ruby
class CoffeeRoutine
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def time
    0.0
  end
end
```

Next, we'll create a couple of *leaf* classes, which represent
indivisble portions of our pattern. Here are a couple of *leaf* classes
that come to mind: `GrindCoffee` and `BoilWater`.

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

Now, we can get to the namesake of the pattern: the *composite* class. A
*composite* class is a *component* that also contain
*subcomponents*. *Composite* classes can be made up of smaller
*composite* classes or *leaf* classes.

Our various coffee making apparatuses can be thought of as *composites*.
Let's check out the `FrenchPress` class:

```ruby
class FrenchPress < CoffeeRoutine
  attr_reader :tasks

  def initialize(name)
    super 'Using the French press to make coffee'
    @tasks = []
    add_sub_task BoilWater.new
    add_sub_task GrindCoffee.new
    add_sub_task AddCoffee.new
  end

  def add_sub_task(task)
    tasks << task
  end

  def remove_sub_task(task)
    tasks.delete task
  end

  def time_required
    total_time = 0.0
    tasks.each { |task| total_time += task.time }
    total_time
  end
end
```

However, we can simplify the `FrenchPress` class by pulling out the
*composite* functionality into its own class.

```ruby
class CompositeTasks < CoffeeRoutine
  attr_reader :tasks

  def initialize(name)
    @tasks = []
  end

  def add_sub_task(task)
    tasks << task
  end

  def remove_sub_task(task)
    tasks.delete(task)
  end

  def time_required
    total_time = 0.0
    tasks.each { |task| total_time += task.time }
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
    add_sub_task GrindCoffee.new
    add_sub_task BoilWater.new
    add_sub_task AddCoffee.new
    # ... Omitted actual steps to make coffee from a French press ...
    # ... Imagine PressPlunger class has been defined already ...
    add_sub_task PressPlunger.new
  end
end

class DripMaker < CompositeTasks
  def initialize
    super 'Using the DripMaker to make coffee!!!'
    add_sub_task GrindCoffee.new
    add_sub_task BoilWater
    add_sub_task AddCoffee.new
    # ... Imagine PressStartButton class has been defined already ...
    add_sub_task PressStartButton.new
  end
end
```

Swell... now we can call the `FrenchPress` and `DripMaker` coffee makers.

```
frenchpress = FrenchPress.new

# => #<FrenchPress:0x007f88fcf46410
       @name="Using the FrenchPress to make coffee!!!",
       @tasks=
         [#<GrindCoffee:0x007f88fcf46370 @name="Grinding some coffee!">,
         #<BoilWater:0x007f88fcf46320 @name="Boiling some water!">]>
         #<AddCoffee:0x007f88fcf46329 @name="Adding in the coffee!">]>
         #<PressPlunger:0x007f88fcf46098 @name="Pressing the plunger down!">]>

dripmaker = DripMaker.new

# => #<DripMaker:0x137t88fcf57109
       @name="Using the DripMaker to make coffee!!!",
       @tasks=
         [#<GrindCoffee:0x007f88fcf46370 @name="Grinding some coffee!">,
         #<BoilWater:0x007f88fcf52520 @name="Boiling some water!">]>
         #<AddCoffee:0x007f88fcf46123 @name="Adding in the coffee!">]>
         #<PressStartButton:0x007f88fcf46432 @name="Pushing the start button!">]>
```

Now we can also check the time required for each coffee maker.

```
frenchpress.time_required # => 12.4
dripmaker.time_required # => 8.5
```

## Discussion

The *Composite* pattern is pretty simple.

We create a *component* class that ties the numerous simple and
complex characteristics together. This can be seen as
`CoffeeRoutine#time_required`.

Next, we create *leaf* classes
that share the same characteristics with one another. Remember that it's the nature
of *leaf* classes to be simple. If you happen across a *leaf* class that
could be broken up, it could potentially be a *composite* class in disguise.
Break up those actions into individual *leaf* classes and turn the original class
into a *composite*. All the *leaf* classes had a `#time` method.

The *composite* class handles all the subtasks, essentially using the child classes
at its will. This can be seen in our two *composite* classes and their methods,
`FrenchPress#time_required` and `DripMaker#time_required`.
