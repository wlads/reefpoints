---
layout: post
title: 'JavaScript Performance For The Win'
author: 'Alex Navasardyan'
tags: JavaScript, Engineering
social: true
published: true
comments: true
---

JavaScript performance is a very hot topic nowadays. There's a lot of information out there on what
browsers do with JavaScript code in order to execute it faster. Let's go over some of the tips that
will help you write faster JavaScript code.

## Tooling

There're are couple of tools that you can use to identify and fix peformance problems. One of the
them is Chrome Developer Tools (open Chrome Developer Tools, switch to `Profiles` tab and click `Start`).
Developer Tools will give you a great overview of what actual happens in your application under the hood
(what functions are called, how much CPU time they consumed, how much memory). That's a great starting
point. Now you can start fixing performance where it matters.

## Non-optimizable code

`try-catch` and `try-finally` blocks will not be optimized by the V8 (to be clear, if the function contains
a `try` block, the whole function will not be optimized).

```javascript
// code
try {
  iMightThrowFunc();
} catch(exception) {
  iHandleExceptions(exception);
}
// code
```

A better way of writing the code above, would be to isolate the `try` block into a separate function so `code`
can be optimized and only `iMightThrowFunc` would not be optimized:

```javascript
function iMightThrow() {
  try {
    // [code]
  } catch(exception) {
    iHandleExceptions(exception);
  }
}

// code
iMightThrow();
// code
```

## Using Local Variables

If you're using a piece of code many times, it's better to create a local variable for it for a couple of reasons:

1. faster scope look ups (once the variable is local scope, it's faster to retrieve it)
2. caching (performing an operation once and storing the result will result in less work for the browser)

## Literals

It might sound very obvious but you should use object literals whenever you can.

```javascript
// use
var array = [];
// instead of
var array = new Array(16);
```

You rarely know what the size of the array is going to be in your application. Let V8 manage the growth
of the array as you add items to it. It will also ensure that the array is in "fast elements" mode and
item access is always fast. You can read more about V8 object representation [here](http://jayconrod.com/posts/52/a-tour-of-v8-object-representation).

#### "Dictionary Mode"

An object will go into "dictionary mode" when you add too many properties dynamically
(outside constructor), `delete` properties, use properties that cannot be valid identifiers.

```javascript
function forInFunc() {
  var dictionary = {'+': 5};
  for (var key in dictionary);
}
```

When you use an object as if it was a dictionary, it will be turned into a dictionary (hash table).
Passing such an object to for-in is a no no.

#### Iterating over a regular array

```javascript
function arrayFunc() {
  var arr = [1, 2, 3];
  for (var index in arr) {

  }
}
```

Iterating over an array using `for-in` is slower than a `for` loop and the entire function containing
a `for-in` statement will not be optimized.

Using `for` loop is almost always a safe bet. Do you need to iterate over object's properties?

```javascript
var objKeys = Object.keys(obj);
var propertyName;

for (var i = 0, l = objKeys.length; i < l; i++) {
  propertyName = objKeys[i];
  // more code
}

for (var propertyName in obj) {
  if (obj.hasOwnProperty(propertyName)) {
    // more code
  }
}
```

## For-In

`For-In` statements can prevent the entire function from being optimized in a few cases. It will result
in "Not optimized: ForInStatement is not fast case" bailout.

### `key` has to be a pure local variable

It cannot be from upper scope or referenced from lower scope.

```javascript
var key;

function doesNotSeemToBeLocalKey() {
  var obj = {};
  for (key in obj);
}
```

## Arguments

Careless manipulations with `arguments` might cause the whole function to be non-optimizable. It might result in
one of these "bailouts": "Not optimized: Bad value context for arguments value" and "Not optimized: assignment
to parameter in arguments object".

### Reassigning `arguments`

```javascript
// do not re-assign arguments
function argumentsReassign(foo, bar) {
  if (foo && foo === 5) {
    bar = 'Barracudas';
  }
  // code that uses `bar`
}

// use local variables instead
function argumentsReassign(foo, bar) {
  var localBar;

  if (foo && foo === 5) {
    localBar = 'Beantown Pub';
  }
  // code that uses `localBar`
}
```

### Leaking `arguments`

```javascript
// `arguments` is a special object and it is costly to materialize.
function leaksArguments() {
  var args = [].slice.call(arguments);
  // code that uses `args`
}

// does not leak arguments
// accessing `arguments.length` is just an integer and doesn't materialize
// `arguments` object
function doesNotLeakArguments() {
  var args = new Array(arguments.length);

  for (var i = 0; i < args.length; ++i) {
    // `i` is always valid index in the arguments object
    // so we merely retrieve the value
    args[i] = arguments[i];
  }
  // code that uses `args`
}
```

Note, that in most cases optimizing takes more code. You can probably write a build step for that:

```javascript
function doesNotLeakArguments() {
  arguments_slice(args, arguments);
  // code that uses `args`
}
```

Happy Coding!
