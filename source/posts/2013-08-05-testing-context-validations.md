---
layout: post
title: "Testing Context Validations"
comments: true
author: Dan McClain
twitter: "\_danmcclain"
github: danmcclain
social: true
summary: "We moved your model validations to your controller, now we're going to help you test them"
published: true
tags: ruby on rails, gems, context validation, testing
---

## Quick Refresher on ContextValidation
A few months ago, Brian released the [ContextValidations gem](http://reefpoints.dockyard.com/ruby/2013/05/09/context-validations.html).
ContextValidations moves your model validations to the controller,
allowing you to vary your validations by context, rather than relying on
conditional validations.

## Let's validate our user

We have a user model, that requires a password and a username when a
user signs up. They can change their username and password, but if they
can leave the password blank when updating their account, it will retain
the old password. Whenever they enter a password , it must be 9
characters or greater. We're going to ignore the actual implementation
of the password saving scheme and password confirmation in this example.
Also, this example ignores setting up the test helper for [valid\_attribute](https://github.com/bcardarella/valid_attribute)
and MiniTest::Spec.

### Implementing the Tests and Validations in the Model

To test the above requirements model validations, we'd do the following:

```ruby
describe OldUser do
  describe 'new user' do
    subject { OldUser.new password: 'password_to_confirm' }

    it { must have_valid(:username).when('bob', 'test1234') }
    it { wont have_valid(:username).when('', nil) }
    it { must have_valid(:password).when('validpassword1234') }
    it { wont have_valid(:password).when('', nil, 'tooshort') }
  end

  describe 'existing user' do
    subject { old_users(:example) }

    it { must have_valid(:username).when('bob', 'test1234') }
    it { wont have_valid(:username).when('', nil) }
    it { must have_valid(:password).when('', nil, 'validpassword1234') }
    it { wont have_valid(:password).when('tooshort') }
  end
end
```

And here is the implementation of the model:

```ruby
class OldUser < ActiveRecord::Base
  attr_accessor :password
  validates :username, presence: true
  validates :password, presence: true, if: :new_record?
  validates :password, length: { minimum: 9 }, allow_blank: true
end
```

### Implementing the Tests and Validations in the Controller with ContextValidations

We've been using ContextValidations with our client work since its
release and realized we could unit test the controller to test the
validations.

Our unit tests for the controller are here:

```ruby
describe UsersController do
  describe '#create' do
    subject { User.new(validations: validations_for(:create)) }

    it { must have_valid(:username).when('bob', 'test1234') }
    it { wont have_valid(:username).when('', nil) }
    it { must have_valid(:password).when('validpassword1234') }
    it { wont have_valid(:password).when('', nil, 'tooshort') }
  end

  describe '#update' do
    subject { User.new(validations: validations_for(:update)) }

    it { must have_valid(:username).when('bob', 'test1234') }
    it { wont have_valid(:username).when('', nil) }
    it { must have_valid(:password).when('', nil, 'validpassword1234') }
    it { wont have_valid(:password).when('tooshort') }
  end
end
```

Note the use of `validations_for`. It is a MiniTest
helper method defined by ContextValidations, which looks up the name
of the controller from the describe block, creates an instance of it,
and retrieves the validations for the context passed in. This prevents
you from needing to create your own instance and calling `validations`
on it. The resulting tests end up looking very similar to what your
model tests would look like.

Our model implementation is very light:

```ruby
class User < ActiveRecord::Base
  include ContextValidations::Model

  attr_accessor :password
end
```

And our validations are defined in the controller:

```ruby
class UsersController < ApplicationController
  include ContextValidations::Controller

  private

  def base_validations
    validates :username, presence: true
    validates :password, length: { minimum: 9 }, allow_blank: true
  end

  def create_validations
    validates :password, presence: true
  end
end
```

All of the examples are part of [this repository](https://github.com/dockyard/testing_context_validations).

## Wrapping it up

As you can see, writing the validation tests for the controller are
almost identical to writing them for the model. There are a few
differences in setting up the subject for the tests, but the only major
difference is that you are testing the controller instead of the model.
If you have any feedback on the tests we came up with, feel free to let
us know!
