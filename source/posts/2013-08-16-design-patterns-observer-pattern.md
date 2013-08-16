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

We'd like to read everyone's emails.

The attached document will show you the basic structure of an email.

If there are any questions, please reach me at [REDACTED].

Best of luck,





Agent [REDACTED]
Spook Boss Class
NSA
[REDACTED]
```

```ruby
# Basic structure of an email

class Email
  attr_reader :sender, :subject, :receiver

  def initialize sender, subject, receiver
    @sender = sender
    @subject = subject    
    @receiver = receiver
  end

  def send
    puts %Q[
      From:    #{sender}@example.com
      Subject: #{subject}
      To:      #{receiver}@example.com
    ]
  end
end
```

As we look through the class `Email`, we see that it has three attributes `receiver`, `sender`, 
