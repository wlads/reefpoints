---
layout: post
title: "Building an Ember App with Rails Part 2"
comments: true
author: 'Brian Cardarella'
github: bcardarella
twitter: bcardarella
social: true
summary: Writing our first ember test
published: true
tags: ember, ruby, ruby on rails
---

We need to start this part with a bug fix. There is a bug for the live reload. In `ember/tests/helpers/start-app.js` 
insert the 2nd line:

```js
var Router = require('bostonember/router')['default'];
```

Now on line 16 add:

```js
Router.reopen({
  location: 'none'
});
```

This bug exists in `0.0.27` of ember-cli and will hopefully be fixed in a future verision.

([there is a pending PR to fix this](stefanpenner/ember-cli#667))

Now start your server:

```bash
cd ember
ember server
```

Open your browser and go to: `http://localhost:4200/tests`

You should see something like the following:

![Screen 1](http://i.imgur.com/bufKV2c.png)

This is a typical [Qunit](http://qunitjs.com/) test suite with some
[JSHint](http://www.jshint.com/) tests already in our app. What you'll notice in the lower
right-hand corner is a blank white box. This box is where our
integration tests will execute. This is an IFRAME so we can see our
applications interacted with in real-time (albeit very fast real-time).

Let's build out a landing page for our app. We will TDD this entire
application over this multi-part series. Create a new directory and file
`ember/tests/integration/landing-page-test.js`.

All of our files will be in
[ES6 module](http://wiki.ecmascript.org/doku.php?id=harmony:modules)
format. If you are unfamiliar with ES6 modules I suggest you go and read
up.

```js
import startApp from 'bostonember/tests/helpers/start-app';

var App;

module('Integration - Landing Page', {
  setup: function() {
    App = startApp();
  },
  teardown: function() {
    Ember.run(App, 'destroy');
  }
});

test('Should welcome me to Boston Ember', function() {
  visit('/').then(function() {
    equal(find('h2#title').text(), 'Welcome to Boston Ember');
  });
});
```

Once you save this file go back to your browser. You should not need to reload anything, ember-cli has a live reload feature on file
change. Now you should see your failing test:

![Screen2](http://i.imgur.com/l7y146I.png)

Let's make the test pass:

In `ember/app/templates/application.hbs`

```hbs
<h1 id="title">Welcome to Boston Ember</h1>
{{outlet}}
```

Check your test suite and it should be all green.

![Screen3](http://i.imgur.com/242RLGf.png)

Congratulations on your first ember test!

Next time we'll build out some pages and write tests to interact with
these pages.
