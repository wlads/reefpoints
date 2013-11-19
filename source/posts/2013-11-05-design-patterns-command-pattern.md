---
layout: post
title: 'Design Patterns: The Command Pattern'
comments: true
author: 'Doug Yun'
twitter: 'dougyun'
github: duggiefresh
social: true
summary: 'Exploring design patterns and their use cases'
published: true
tags: design patterns, ruby
---

## Let's get ready for some football!

One of my favorite sports is American football; it's strategic, physical,
and wild! As a fan - and once high school player - of the sport, I've gained some
valuable lessons from my experiences. For example, I've learned that "persistence
is key", "giving up is for losers", and that "water sucks, Gatorade is better."

While those are fine gems of wisdom, today we'll be
covering one of the most overlooked teachings in football: the power
of **Command** pattern.

The **Command** design pattern intends to separate and decouple an object of invocation
from the object that receives the message of invocation. We will
encapsulate all pertinent information of a method and execute the method
at a later time. Essentially, the **Command** pattern gives us the ability
to queue a series of operations for a later time. Let's dig in.

## Put me in, Coach!

Let's start by creating a `BostonNarwin` class from which our
football players will inherit from.

```ruby
# football.rb

class BostonNarwin
  attr_reader :action

  def initialize(action)
    @action = action
  end

  def name
    self.class
  end
end
```

Next, we'll need some key players; let's create `Quarterback` and `Receiver` classes.
For fun, we're going to add a `TeamOwner` class too.
All three of these classes are going to possess a method called `#execute`.

Each of these classes can be considered as instances of separate
**commands**.

```ruby
# football.rb

class Quarterback < BostonNarwin
  attr_reader :path, :play

  def initialize(path, play)
    super 'Hut! Hut! Red 19! Red 19! Hike!'
    @path = path
    @play = play
  end

  def execute
    file = File.open path, 'w'
    file.write "#{name}: #{play}\n"
    file.close
  end
end

class Receiver < BostonNarwin
  attr_reader :path, :play

  def initialize(path, play)
    super 'Run, run, run!!!'
    @path = path
    @play = play
  end

  def execute
    file = File.open path, 'a'
    file.write "#{name}: #{play}\n"
    file.close
  end
end

class TeamOwner < BostonNarwin
  attr_reader :path, :target

  def initialize(path, target)
    super "We are moving the team from #{prettify path} to #{prettify target}!"
    @path = path
    @target = target
  end

  def execute
    FileUtils.mv path, target
    file = File.open target, 'a'
    file.write "#{name}: We moved from #{prettify path} to #{prettify target}!"
    file.close
  end

  def prettify(pathname)
    (pathname.chomp File.extname(pathname)).capitalize
  end
end
```

Next, let's create a class that keeps track of the `Quarterback`, `Receiver`, and
`TeamOwner` commands. We can use the
[**Composite** pattern](http://reefpoints.dockyard.com/2013/10/01/design-patterns-composite-pattern.html)
to create this new class.

```ruby
# football.rb

class CompositeCommand < BostonNarwin
  attr_accessor :commands

  def initialize
    @commands = []
  end

  def add_command(*args)
    args.each { |arg| commands << arg }
  end

  def execute
    commands.each { |command| command.execute }
  end
end
```

Now, we can kickoff some football commands!

```
load 'football.rb'

quarterback = Quarterback.new('boston.txt', 'I'm going to throw a perfect pass!')
# => #<Quarterback:0x007ff6f5c5c148
     @action="Hut! Hut! Red 19! Red 19! Hike!",
     @path="boston.txt",
     @play="I'm going to throw a perfect pass!">

receiver = Receiver.new('boston.txt', 'I'm going to catch the ball!')
# => #<Receiver:0x007ff6f5c949f8
     @action="Run, run, run!!!",
     @path="boston.txt",
     @play="I'm going to catch the ball!">

team_owner = TeamOwner.new('boston.txt', 'somerville.txt')
# => #<TeamOwner:0x007ff6f5ccd028
     @action="We are moving the team from Boston to Somerville!",
     @path="boston.txt",
     @target="somerville.txt">
```

Great! Now we'll create an instance of the `CompositeCommand`, add
each sub-command with `#add_command`, and then execute each command
with `#execute`.

```
command = CompositeCommand.new
# => #<CompositeCommand:0x007ff6f5b82948 @commands=[]>

command.add_command quarterback, receiver, team_owner
# => [#<Quarterback:0x007ff6f5c5c148
     @action="Hut! Hut! Red 19! Red 19! Hike!",
     @path="boston.txt",
     @play="I'm going to throw a perfect pass!">,
     #<Receiver:0x007ff6f5c949f8
     @action="Run, run, run!!!",
     @path="boston.txt",
     @play="I'm going to catch the ball!">,
     #<TeamOwner:0x007ff6f5ccd028
     @action="We are moving the team from Boston to Somerville!",
     @path="boston.txt",
     @target="somerville.txt">]

command.execute
# ...  Omitted for brevity ...

exit
```

Finally, let's list out the files in our current directory and view the contents
of our recently created text file.

```
$ ls
# => football.rb   somerville.txt

$ less somerville.txt
# => Quarterback: I'm going to throw a perfect pass!
     Receiver: I'm going to catch the ball!
     TeamOwner: We moved from Boston to Somerville!
```

Wow! The **Command** pattern in action!

## Discussion

The **Command** pattern suggests that we create objects that perform
specific tasks and actions. For our example, the `Quarterback` object
created a file, the `Receiver` appended to the file, and the `TeamOwner`
object moved it. Each of the command objects completed their action
through `CompositeCommand#execute`.

Having one object, an instance of `CompositeCommand`, that executes all
stored commands presents us with solutions ranging from simple file
manipulation to user triggered interaction. The **Command** pattern
also allows us to "store" and "remember" commands prior to and after
execution.

Hope you enjoyed our example and go Boston Narwins!
