---
layout: post
title: "Rails 4.0 Sneak Peek: Asynchronous ActionMailer"
comments: true
author: Brian Cardarella
github: bcardarella
twitter: bcardarella
legacy_category: ruby
social: true
summary: "How to send your emails using the new Rails 4.0 Queue"
published: true
---

My previous [deep dive into the Rails 4.0 Queueing system](http://reefpoints.dockyard.com/ruby/2012/06/25/rails-4-sneak-peek-queueing.html)
 was motivated by a patch to Rails I was working on while at [RailsCamp New England](http:/railscamps.org) this past weekend. I'm happy to say that [Rails 4.0 now has an optional asynchronous ActionMailer](https://github.com/rails/rails/pull/6839).

The API for pushing your emails to the background is very simple. If you
want to make this change application wide simply set it in your
`application.rb` (or in any of the environment files)

```ruby
config.action_mailer.async = true
```

Or if you want to only make specific mailers asynchrounous

```ruby
class WelcomeMailer < ActionMailer::Base
  self.async = true
end
```

That's it! Any messages that are being delivered will be sent as a
background job. In fact, the rendering is happening on the background as
well.

You will need to take care that the arguments you are passing your
mailers can be properly marshalled. Instead of:

```ruby
WelcomeMailer.welcome(@user).deliver
```

You should do:

```ruby
WelcomeMailer.welcome(@user.id).deliver
```

Then in your mailer:

```ruby
class WelcomeMailer < ActionMailer::Base
  def welcome(id)
    @user = User.find(id)
    ...
  end
end
```

## Switching it up ##

The default queueing system is `Rails.queue`, but you can override this to use any queueing system you
want by overriding `ActionMailer::Base#queue`.

```ruby
class WelcomeMailer < ActionMailer::Base
  def queue
    MyQueue.new
  end
end
```

Your custom queue should expect the jobs to respond to `#run`, same as
`Rails.queue`.

## Credit ##

Much of the original code was cribbed (with permission) from [Nick
Plante](http://blog.zerosum.org)'s
[resque_mailer](https://github.com/zapnap/resque_mailer) gem.
