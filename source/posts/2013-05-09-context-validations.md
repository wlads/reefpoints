---
layout: post
title: Context Validations
comments: true
author: Brian Cardarella
twitter: bcardarella
github: bcardarella
category: ruby
social: true
summary: An alternative to the normal Rails validations
published: true
---

I just released a new [gem called ContextValidations](https://github.com/dockyard/context_validations)

ContextValidations allows you to set validations on the instance of
ActiveRecord models. Any class-level validations you have already set
in your models are ignored. You may be asking yourself "Whaaaaaat?" so
let's look into why.

## Conditional Validations Are A Smell ##

When applications grow in complexity the validation models required to
support them usually grow too. Eventually you will have to "work around"
the validations with conditionals that rely upon state flags. In some
cases you end up writing empty model objects for use with your forms to
avoid the mess that conditional validations introduce.

The problem here is that the model is defining a single set of
validations but the model needs to absorb different sets of data under
different circumstances. Imagine you have a user account that where
depending upon how the users get to your app will depend upon what data
they need to provide. You might also be importing data from an external
incomplete data set. Do you set these records aside into another table
until the records are claimed and the user can complete registration? Or
do you allow the records to save and have the model enter a state of
`unclaimed` to avoid authentication until `claimed`? You could just
avoid the validations all together but you definitely don't want to
allow records that don't have the most basic of identifying information
such as `email` or `username` to be saved.

You can imagine with this scenario the current solution with Rails is
either a very complex and messy validation model or breaking things out
into other models and having a strategy to reconciling that at a later
point in time.

## Context Matters ##

I have come to believe that defining a monolithic validation set in your
model is the wrong way to go. Context matters. If I am an admin I should
be able to write data to a record that might not be acceptable to a
regular user. Even the simple case of not requiring a password unless
the record is new.

### Controllers Are the Context ###

I believe the rule of "Fat Model, Skinny Controller" has conditioned
Rails developers to never ever put anything more than a few lines of
code into your controllers. For the most part this is a good trend. But
as we have seen with [Strong Parameters](https://github.com/rails/strong_parameters) 
there are circumstances where adding a few more lines to our controllers
isn't going to end the world. I submit the case is also true for
validations. The controller is the context in which the user is
interacting with the data. Going back to the admin example, you most
likely have a `UsersController` and an `Admin::UsersController` defined.
Two controllers, same data. Different contexts. Not only should you
allow mass assignment to the models differently for each context but
what is considered "valid data" should also be different.

## Context Validations ##

To handle this need I have just releaed
[ContextValidations](http://rubygems.org/gems/context_validations).
The goals of this gem are simple:

1. Maintain simplicity
2. Enable instance level validations
3. Don't deviate from exisitng Rails validations
4. Backwards compatibility with 3rd party libraries

Before I dive into each one let's see how a set of validations might be
applied in a controller

```ruby
class UsersController < ApplicationController
  include ContextValidations::Controller

  def create
    @user = User.new(user_params)
    @user.validations = validations(:create)
    if @user.save
      # happy path
    else
      # sad path
    end
  end

  def base_validations
    validates :first_name, :last_name :email, :presence => true
    validates :email, :uniqueness => true, :format => EmailFormat
    validates :password, :confirmation => true
  end

  def create_validations
    validates :password, :presence => true
  end
end
```

### Maintain Simplicity ###

At this point some of you are probably thinking [Form Objects](http://rhnh.net/2012/12/03/form-objects-in-rails).
Perhaps in the end, Form Objects will be the real answer for what I
strive for. But right now I don't see a justification for the increase
in complexity. `ContextValidations` has attempted to keep the complexity
as low as possible while still allowing for flexibility. The
`ContextValidations::Controller` module can be mixed into any object,
not just controllers. Let's say you had a [Service Object](http://stevelorek.com/service-objects.html)

```ruby
class UserService
  include ContextValidations::Controller

  def initialize(params)
    @params = params
  end

  def create
    @user = User.new(create_params)
    @user = validations(:create)
  end
end
```

At this point the code looks identitly to the controller example from
above. The validations are accessible anywhere, from any object.

### Instance level validations ###

The real key here is that the instance of the model is able to declare
what its validations are rather than the class. To that end you must
mixin the `ContextValidations::Model` module into any model you want to
use `ContextValidations`

```ruby
class User < ActiveRecord::Base
  include ContextValidations::Model
end
```

This mixin will do several things to you `ActiveRecord` model

1. A `#validations` setter and getter is added. The default for
`#validations` is an empty array. When any arrays are assigned they are
wrapped in an array and falttened out.

2. The `:validate` callbacks are completed removed. This allows the
model to accept validations set on the class by 3rd party libraries but
these validations will never run.

3. The `#run_validations!` protected method is overwritten to run
through the instance level validations instead of running the
`:validate` callback.

### Don't deviate from exisitng Rails validations ###

The only difference from writing your validations now is they are
written on the instance. The `#validates` method functions exactly the
same way. You can still pass conditional validations if you'd like but I
wouldn't recommend it.

### Backwards compatibility with 3rd party libraries ###

As mentioned above we don't want your Rails app to crash if 3rd party
libraries are declaring regular Rails validations in your models. They
are just ignored.

## Moving forward ##

There are a few directions things could move in. I still haven't come
up with a simple way to test `ContextValidations`. There will also be
validations that are always used regardless of the context. I don't
think it makes sense to constantly rewrite these validations. One
possibility would be to consider the class validations the
`base_validations` that are always run then you can declare context
validations on the instance. This might cause issues with 3rd party
libraries that are using conditional validations. But, we could easily
get around that by ignoring any class level validations that have
conditionals on them.

I am eager to get feedback on this. I am sure this might cause some
friction as it moves outside of the comfort zone for many Rails devs but
now I am happy with the direction.
