---
layout: post
title: 'Design Patterns: The Observer Pattern'
comments: true
author: 'Doug Yun'
twitter: 'DougYun'
github: duggiefresh
social: true
summary: 'NSA Edition: Exploring design patterns and their use cases'
published: true
tags: software design patterns, ruby
---

Note: We won't be going over the Ruby
module
[*Observable*](http://ruby-doc.org/stdlib-2.0/libdoc/observer/rdoc/Observable.html).
Instead, we'll building out the pattern ourselves.

## Your First Day at the NSA

Welcome to the National Security Agency, [Agent
Smith](http://www.forodecostarica.com/attachments/201136d1337091462-los-gringos-se-burlan-de-nuestro-pais-agent-smith.jpg).
You have quite an impressive background, and we believe your "go-getter"
attitude will instill a new kind of vigor within the organization.

Your cubicle is down to the left... here are some NDAs for
you to fill out. I'll swing by your desk in the afternoon and pick them
up from you later. Oh, and before I forget, here is your first assignment.

Go get 'em, tiger!

## The First Assignment

```
Agent Smith
Spook First Class
[REDACTED]
NSA                                                     08-20-[REDACTED]

                     Operation [REDACTED] Observers

Welcome, Agent Smith:

Bluntly, we'd like to track everyone's emails.

Attached are two documents.

The first document will show you the basic structure of a typical email,
and the second document will provide you a basic profile of a suspicious
person.

If there are any questions, please reach me at [REDACTED].

Best of luck,





Agent [REDACTED]
[REDACTED]
[REDACTED]
NSA
```

```ruby
# Document 1:
# Basic structure of an email

module Email
  extend self

  def send(subject, sender, receiver)
    puts %Q[
      Subject: #{subject}
      From:    #{sender}@example.com
      To:      #{receiver}@example.com
      Date:    #{Time.now.asctime}
    ]
  end
end
```

```ruby
# Document 2:
# Characteristics of a suspicious person

class Person
  include Email
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def send_email(subject, receiver)
    Email.send(subject, name, receiver)
  end
end
```

As we look through the `Email` module, we see that it contains
`Email.send` which takes three arguments: `subject`, `sender`, and
`receiver`.

Gazing at the suspicious `Person` class, we see that it includes the
`Email` module. `Person#send_email` takes two parameters: a subject
and a receiver. `Person#name` will stand in as the sender of the email.

Hypothetically, let's see how a suspicious person would send an email:

```
bill = Person.new 'Bill'
bill.send_email 'Fishing Trip', 'Fred'
  # =>
      Subject: Fishing Trip
      From:    Bill@example.com
      To:      Fred@example.com
      Date:    Wed Aug 16 20:35:09 2006
```

Hmm... as you sit in your cubicle, you ponder the numerous possible ways of
tracking emails. You won't need anything too complicated, just
something to kick off a notification once an email has been sent.

Volia! You realize you can use the *Observer* pattern!

## The Subject and its Observers

First, let's start off by creating two *observer* classes,
`Alert` and `Agent` classes.

```ruby
class Alert
  def gotcha(person)
    puts "!!! ALERT: #{person.name.upcase} SENT AN EMAIL !!!"
  end
end

class Agent
  def gotcha(person)
    puts "!!! TIME TO DETAIN #{person.name.upcase} !!!"
  end
end
```

Next, let's create a `Subject` module.

```ruby
module Subject
  attr_reader :observers

  def initialize
    @observers = []
  end

  def add_observer(*observers)
    observers.each { |observer| @observers << observer }
  end

  def delete_observer(*observers)
    observers.each { |observer| @observers.delete(observer) }
  end

  private

  def notify_observers
    observers.each { |observer| observer.gotcha(self) }
  end
end
```

Here within the `Subject#initialize`, we create an empty array which
will contain a list of *observers*. `Subject#add_observer` simply pushes
our desired *observers* into the array.

Finally, we can alter the suspicious `Person` class, which will act as
the *subject* class. Let's include the `Subject` module now.

```ruby
class Person
  include Email, Subject
  attr_reader :name

  def initialize(name)
    # 'super' requires a parentheses because we're calling
    # super on the superclass, 'Subject'
    super()
    @name = name
  end

  def send_email(subject, receiver)
    Email.send(subject, name, receiver)
    notify_observers
  end
end
```
`Subject#notify_observers` calls `#gotcha` on each *observer*, which
informs each *observer* that `Person#send_email` has been kicked off.

Now let's give it a whirl...

```
alert = Alert.new
agent = Agent.new

bill = Person.new 'Bill'

bill.add_observer alert, agent   # Bill now has two observers watching him

bill.send_email 'Fishing Trip', 'Fred'
  # =>
      Subject: Fishing Trip
      From:    Bill@example.com
      To:      Fred@example.com
      Date:    Wed Aug 16 20:35:09 2006

!!! ALERT: BILL SENT AN EMAIL !!!
!!! TIME TO DETAIN BILL !!!
```

Perfect, it works! Now we can start protecting our freedom!

## Discussion

In our example above, we have two *observers*, the `Alert` and `Agent`
classes, and a *subject*, `Person`. By creating the `Subject` module,
any instance of `Person` now informs and updates any *observer* through
`#notify_observers`, ultimately removing any implicit coupling from `Alert` and
`Agent`.

There are a few similarities between the *Observer* and
[*Strategy*](http://reefpoints.dockyard.com/2013/07/25/design-patterns-strategy-pattern.html)
patterns. Both patterns employ an object (the Observer's *subject* and
the Strategy's *context*) that makes calls to another object (the
Observer's *observer* or Strategy's *strategy*). The difference between
the two patterns is the purpose and use case. The *Strategy* pattern
relies on the *strategy* to do the work, while the *Observer* pattern
informs the *observers* of what is going on with the *subject*.

Hope you enjoyed this short example, thanks for reading!
