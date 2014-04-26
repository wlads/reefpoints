---
layout: post
title: 'Don't override init'
twitter: bcardarella
github: bcardarella
author: 'Brian Cardarella'
tags: ember
social: true
published: true
comments: true
summary: Use events instead'
---

Too frequently do I see the following problem. Someone creates a new
class and overrides init:

```javascript
var UserController = Ember.ObjectController.extend({
  init: function() {
    // some custom stuff
  }
})

export default UserController;
```

`init` is a popular function to override because it is automatically run
after the object is instantiated. The problem is with the above example
the controller is broken. I forgot to make a call to `this.super()`
which will call the original `init` from `Ember.ObjectController` which
amongst other things will set up the `content` property which is the entire point
of having an `ObjectController` in the first place.

Instead of overriding `init` I have been writing functions that are
specific to the logic I want to kick off on object instantiation and
have that function trigget `on('init')`:

```javascript
var UserController = Ember.ObjectController.extend({
  doSomething: function() {
    // some custom stuff
  }.on('init')
})

export default UserController;
```

Now I don't risk messing with the original behavior of the parent class.

Calling up the `super` chain is powerful and important but I found
myself too often forgetting to call it. The only time I would find
myself overriding `init` is if I want to **change** the instantiating
behavior of the object.
