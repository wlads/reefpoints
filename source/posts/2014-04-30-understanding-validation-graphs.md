---
layout: post
title: "Understanding validation graphs"
comments: true
author: 'Brian Cardarella'
github: bcardarella
twitter: bcardarella
social: true
summary: The power behind ember-validations
published: true
tags: ember
---

If you have heard me speak about
[ember-validations](https://github.com/dockyard/ember-validations) then
you may have heard me mention the term **validation graph**. What is
this? Why is it important?

If you come from a Rails background then you are used to the validations
being stored in an array on the instance of the model. When you validate
your model all of those validations will be run and an errors object is
produced. If you make a change to a property you have to run the
validations again to determine the validity of the model.

I would refer to the style of
validations described above as *lazy validations*. Meaning the
validity of the model may not be truly representitive of its
current state. We have to opt-into running the validations again to
determine this. Fortunately in most cases the validations are run for us
before we save. On the server this all happens within a request/response
cycle so we don't really care too much about the validations
being lazy because we care about the final result, not the state of the
model at any given point during that cycle.

ember-validations has *eager validations*. This means when the property
that is associated with any number of validations changes those
validations are run again to determine the state of the model. This is
great for client side apps that need to show the current state of the
entire model any time you make a change, say during a user sign up. I
might want to disable the Submit button if there are any failing
validations. If I make a correction I want the error message to go away
once the correction is made. I should not have to wait on form
submission to see my errors.

How does ember-validations do this? Let's say you have the following
validations:

```javascript
var UsersController =
Ember.ObjectController.extend(Ember.Validations.Mixin, {
  validations: {
    firstName: {
      presence: true,
      length: 5
    },
    password: {
      confirmation: true
    }
  }
});
```

There are 3 validations on 2 properties. Each validation is an
instantiated class that can observe the one or more properties. In the
case of `firstName` there is the `Presence` and `Length` validators
observing `firstName`. The `Confirmation` validator is actually
observing `password` **and** `passwordConfirmation` for changes. Each
validator has a `isValid` flag that is set to `true` or `false`
depending upon the result. Each of these validators are pushed onto a
`_validators` array and the parent object is observing
`_validators.@each.isValid` for any changes. If any of the validators
are `false` the parent's `isValid` state is now `false`.

Please take a moment to re-read the above paragraph because it is very
important to have a good handle on this before we move forward. **The
validating object's `isValid` flag is the result of its validator's
`isValid` flags**

Because we are in quack-quack duck-typed JavaScript we don't **have** to
pass validator instances into the `_validators` array. *What if we pass
another validatable object?* Now things get interesting.

Let's say we have a `Profile` that belongs to a `User`. The `Profile`
can have its own set of validations as well as its own `isValid` flag.
If the `Profile` is mixed into the `Users`'s validation graph then the
`User` will be invalid when the `Profile` is invalid. We can use this
pattern to buld an incredibly deep and complex graph where the validation
state bubbles up to the root whenever a property change takes place
anywhere in the graph.

We can do this simply with:

```javascript
var UsersController =
Ember.ObjectController.extend(Ember.Validations.Mixin, {
  validations: {
    firstName: {
      presence: true,
      length: 5
    },
    password: {
      confirmation: true
    },
    profile: true
  }
});
```

Notice `profile: true` in the graph. As long as `profile` is the path to
the object to validate against ember-validations will work its magic.

However, the above only really works if the validations exist on the
`Profile` **model** and not the controller. I have been putting some
time into thinking how best to do this. I welcome suggestions and
thoughts on this API as well as the validation graph in general.
