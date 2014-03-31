---
layout: post
title: 'Magic behind ES6 Generators'
comments: true
author: 'Alex Navasardyan'
twitter: twokul
github: twokul
social: true
published: true
tags: javascript, es6
summary: 'Overview of ES6 generators'
---

## Overview

The next version of JavaScript (ES6 or ES.next) is going to have a lot of
great features built in that are going to make developer's life much easier.
[Promises](http://wiki.ecmascript.org/doku.php?id=strawman:promises),
[Modules](http://wiki.ecmascript.org/doku.php?id=harmony:modules),
[WeakMaps](http://wiki.ecmascript.org/doku.php?id=harmony:weak_maps),
[Generators](http://wiki.ecmascript.org/doku.php?id=harmony:generators) to name a few. In this
post I want to talk about generators.

Generators are objects that encapsulate suspended execution context. What the heck does it mean?
In other words, generators allow you to pause execution of your code and return a value.

Let's say you need to write a `cubic` function (for any given number, calculate a cubic number)
and then print it out.

Code without generators for 10 numbers:

```javascript
function out(n) {
  console.log('Cubic number:', n);
}

function *cube(n) {
  n = n * 3;
  out(n);
}

for (var i = 0; i < 10; i++) {
  cube(i);
}
```

Code with ES6 generators for 10 numbers:

```javascript
function *cube(n) {
  var i = 0, j = n;
  while (i < n) {
    i++;
    j = j * 3;
    yield j;
  }
}

var c = cube(10);
for (var i = 0; i < 10; i++) {
  console.log('Cubic number:', c.next().value);
}
```

Can you spot the difference? Generator represents a sequence of numbers and every time you call
`next()` it gives you the next number in the sequence (it actually gives you an object back
with two properties: `value` and `done`):

```javascript
c.next(); // => { value: 3, done: false }
```

Once the limit is reached, generator will return:

```javascript
c.next(); // => { value: undefined, done: true }
```

Pretty cool, eh?

Note, that generators look *just* like functions, but with `*`s:

```javascript
// regular function
function cube()  {}

// es6 generator
function *cube() {}
```

If you're a Python developer, generators and `yield` are not new to you. But it's a big step forward
for JavaScript.

## For-Of

The `for of` loop is a new iteration construct in ES6 which supports generators. This is really for
performance purposes. Instead of returning a full array, you can just return a generator which
lazily gives values back on each iteration. That decreases memory allocation and you can express
infinite data structures (since no array allocation is needed).

A really interesting use case for generators is async operations:

```javascript
spawn(function() {
  var users = yield db.get('users');
  var posts = yield db.get('posts');
});
```

`spawn` is a function in [node.js](http://nodejs.org) that allows you to create child processes.
You can read about it [here](http://nodejs.org/api/child_process.html#child_process_child_process_spawn_command_args_options).

`spawn` hands control over the function to the scheduler, which knows that the function will `yield`
promises and will send the values back as soon as the promises are going to be resolved (fulfilled).

This is really powerful.

## Availability

If you really want to use this feature, you're going to have to use transpilers, such as [Traceur](https://github.com/google/traceur-compiler)
or [Regenerator](https://github.com/facebook/regenerator). The reason for that is two new language keywords
introduced by ES6 generators: `yield` and `function *`. There's a really good blog post about [polyfilling generators](http://gu.illau.me/posts/polyfilling-generators/)
that goes in depth about how transpilers deal with the new syntax.

Native implementations of generators are available in Firefox and Chrome Canary
(you will need to enable [harmony experimental flag](chrome://flags/#enable-javascript-harmony)).

I encourage you to play around with the generators and get familiar with the syntax because in couple of
years from now, we all will be writing code using generators (hopefully).

P.S.

Great article about [ES6 generators](https://developer.mozilla.org/en-US/docs/Web/JavaScript/New_in_JavaScript/1.7#Generators).
