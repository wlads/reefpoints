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

## Morning Coffee

If you're anything like me, you'll agree that every morning needs to start
out with a cup of coffee. And, if you're anything like me, you'll have
at least three different coffee making apparatuses. Lastly, if you're
anything like me... you'll soon realize you may have an addiction.

Joke aside, each coffee contraption requires a specific procedure
to be completed in order to brew a cup of joe; each taking different
amounts of time, various numbers of steps

I think we can best explain this by using the *Composite*
pattern.

## The Best Part of Waking Up is a Composite Pattern in Your Cup

We can start by thinking of each coffee maker and coffee related task as a *subclass* of
our `MorningRoutine`. `MorningRoutine` will be known as the *component*, the base
class or interface that possesses commonalities of basic and complex
objects. `MorningRoutine#time_required` is the common trait among all
coffee related tasks.

```ruby
class MorningRoutine
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def time_required
    0.0
  end
end
```

Next, we'll create a couple of *leaf* classes, which represent
indivisble portions of our pattern. Here are a couple of *leaf* classes
that come to mind: `GrindCoffee` and `BoilWater`.

```ruby
class GrindCoffee < MorningRoutine
  def initialize
    super('Grinding some coffee!')
  end

  def time_required
    0.5
  end
end

class BoilWater < MorningRoutine
  def initialize
    super('Boiling some water')
  end

  def time_required
    4.0
  end
end
```

Now, we can get to the namesake of the pattern: the *composite* class. A
*composite* class is a *component* that also contain
*subcomponents*. *Composite* classes can be made up of smaller
*composite* classes or *leaf* classes.

Our various coffee making apparatuses can be thought of as *composites*:

```ruby
class FrenchPress < MorningRoutine
  attr_reader :tasks

  def initialize(name)
    super('Using the French press to make coffee')
    @tasks = []
    add_sub_task(BoilWater.new)
    add_sub_task(GrindCoffee.new)
    add_sub_task(PutInCoffee.new)
  end

  def add_sub_task(task)
    tasks << task
  end

  def remove_sub_task(task)
    tasks.delete(task)
  end

  def time_required
    time = 0.0
    tasks.each { |task| time += task.time_required }
    time
  end
end
```

But, we definitely pull out the *composite* functionality into its own
class.

```ruby
class Composites < MorningRoutine
  attr_reader :tasks

  def initialize
    @tasks = []
    add_sub_task(BoilWater.new)
    add_sub_task(GrindCoffee.new)
    add_sub_task(PutInCoffee.new)
  end

  def add_sub_task(task)
    tasks << task
  end

  def remove_sub_task(task)
    tasks.delete(task)
  end

  def time_required
    time = 0.0
    tasks.each { |task| time += task.time_required }
    time
  end
end
```
