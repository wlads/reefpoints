---
layout: post
title: 'Design Patterns: The Observer Pattern'
comments: true
author: 'Doug Yun'
twitter: 'DougYun'
github: duggiefresh
social: true
summary: 'Exploring design patterns and their use cases'
published: false
tags: software design patterns, ruby
---

## Your First Day at the NSA

Welcome to the Agency, [Agent
Smith](http://www.forodecostarica.com/attachments/201136d1337091462-los-gringos-se-burlan-de-nuestro-pais-agent-smith.jpg).
You have quite an impressive background, and we know your "go-getter"
attitude will instill a new kind of vigor within the organization.

Your cubicle is down this way to the left... here are some NDAs for
you to fill out. I'll pick them up from you later in the afternoon. And,
here is your first assignment. Go get 'em, tiger!

## Your First Assignment

```
Agent Smith
Spook First Class
NSA
[REDACTED]                                                 08-16-2006

                        Operation Red Rover

Hello, Agent Smith

We'd like to track everyone's emails.

Attached are two documents.

The first document will show you the basic structure of an email, and
the second document will provide you a basic list of attributes that of
a suspicous person.

If there are any questions, please reach me at [REDACTED].

Best of luck,





Agent [REDACTED]
Spook Boss
NSA
[REDACTED]
```

```ruby
# Document 1:
# Basic structure of an email

module Email
  extend self

  def send subject, sender, receiver
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

  def initialize name
    @name = name
  end

  def create_email subject, receiver
    Email.send subject, name, receiver   # Note: Person#name is the email sender
  end
end
```

As we look through the `Email` module, we see that it contains
`Email.send` that takes three arguments: `subject`, `sender`, and
`receiver`.

Gazing at the suspicious `Person` class, we see that it includes the
`Email` module. `Person#create_email` takes two parameters: a subject
and a receiver. `Person#name` will stand in as the sender of the email.

Let's try see how a suspicious person would send an email:

```
bill = Person.new 'Bill'
bill.create_email 'Fishing Trip', 'Fred'
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

## Observers Observing the Observed

First, let's start off by creating a `Snooper` and `Agent` classes.

```ruby
class Snooper
  def gotcha person
    puts "!!! ALERT: #{person.name.upcase} SENT AN EMAIL !!!"
  end
end

class Agent
  def gotcha person
    puts "Time to detain #{person.name}!"
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

  def add_observer *observers
    observers.each do |observer|
      @observers << observer
    end
  end

  private

  def notify_observers
    observers.each do |observer|
      observer.gotcha self
    end
  end

  def delete_observer observer
    observers.delete observer
  end
end
```

Finally, we can alter the suspicious `Person` class.

```ruby
class Person
  include Email, Subject
  attr_reader :name

  def initialize name
    # 'super' requires a parentheses because we're calling
    # super on the superclass, 'Subject'
    super()
    @name = name
  end

  def create_email subject, receiver
    Email.send subject, name, receiver
  end
end
```
