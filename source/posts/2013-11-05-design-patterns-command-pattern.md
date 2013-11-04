---
layout: post
title: 'Design Patterns: The Command Pattern'
comments: true
author: 'Doug Yun'
twitter: 'dougyun'
github: duggiefresh
social: true
summary: 'Exploring design patterns and their use cases'
published: false
tags: software design patterns, ruby
---

## Let's get ready for some football!

One of my favorite sports is American football; it's strategic, physical,
and overall wild! As a fan, and once player, of the sport, I've learned some
valuable lessons. For example, I've learned that "persistence is key",
"giving up is for losers", and "water sucks, Gatorade is better."

While those are fine gems of wisdom, today we'll be
covering one of the most overlooked teachings in football: the **Command** pattern.

## Put me in, Coach

Let's start by creating a football player, a `BostonNarwin`class from which our
football players will inherit from.

```ruby
class BostonNarwinCommand
  attr_reader :action

  def initialize(action)
    @action = action
  end

  def name
    self.class
  end
end
```

Next, we'll need some key players; let's just focus on a `Quarterback` and a `Receiver`.

```ruby
class QuarterbackCommand < BostonNarwinCommand
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

class ReceiverCommand < BostonNarwinCommand
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

class TeamOwnerCommand < BostonNarwinCommand
  attr_reader :path, :target

  def initialize(path, target)
    super "We are moving the team from #{path} to #{target}!"
    @path = path
    @target = target
  end

  def execute
    FileUtils.mv path, target
    file = File.open target, 'a'
    file.write "#{name}: We moved from #{path} to #{target}!"
    file.close
  end

  def prettify(path)
    (pathname.chomp(File.extname(pathname))).capitalize
  end
end
```

Next, let's create a class that keeps track of every player's command.

```ruby
class CompositeCommand < BostonNarwinCommand
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
quarterback = QuarterbackCommand.new('boston.txt', 'I'm going to throw a perfect pass!')
receiver = ReceiverCommand.new('boston.txt', 'I'm going to catch the ball!')
team_owner = TeamOwnerCommand.new('boston.txt', 'somerville.txt')

```
