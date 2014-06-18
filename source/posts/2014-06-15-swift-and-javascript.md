---
layout: post
title: 'Swift and JavaScript'
twitter: twokul
github: twokul
author: 'Alex Navasardyan'
tags: javascript, swift
social: true
published: true
comments: true
summary: 'Swift explained for JavaScript developers'
---

You might have already heard about a new language from Apple, [Swift](https://developer.apple.com/swift/).
If you haven't, make sure to check it out. This is the language that is going to replace [Objective-C](https://en.wikipedia.org/wiki/Objective-C) in the future.

So why should a JavaScript developer be excited about a language like Swift?
Because semicolons are optional in Swift, too.

### Variables

Let's declare a variable in `JavaScript`:

```javascript
var country = 'Argentina';
```

Here's how the same declaration looks like in Swift:

```swift
var country: String = "Argentina";
```

However, the same statement can be rewritten as such:

```swift
var country = "Argentina"; // inferred as String
```

Swift uses type inference. It looks on the right hand side of the assignment
to figure out the type of the variable.

Swift is type safe language. It performs type checks during compilation time
and informs you if there are any type mismatch errors. Unlike in JavaScript,
that means that after you defined `country` variable and its type was
inferred to be `String`, you can't re-assign with another type:

```swift
country = 2; // Cannot convert the expression's type to type 'String'
```

### Constants

JavaScript doesn't have a concept of a `constant`. All "constants" are just
variables (typically in the outer scope). You can "freeze" the object using
[Object.freeze()](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/freeze)
to prevent new properties to be added and existing properties to be removed.

The next version of JavaScript is going to introduce [const](https://people.mozilla.org/~jorendorff/es6-draft.html#sec-13.2.1)
keyword and will support constants:

```javascript
const y = 10; // Note that you need to specift the value of the constant
y = 20;       // SyntaxError: Assignment to constant variable
```

If you want to define a constant in Swift, you will use `let` keyword:

```swift
let bestCity = "Boston";
bestCity = "Cape Town"; // Cannot assign to 'let' value 'bestCity'

// Swift allows you to use underscore as a delimiter
// to improve readability of your code
let oneMillion = 1_000_000;
```

### Tuples

So what is a [tuple](http://en.wikipedia.org/wiki/Tuple)? TL;DR it's an ordered list of things.

You can think of a tuple as if it's an object:

```javascript
var villain = {
  name:     'Magneto',
  realName: 'Max Eisenhardt',
  powers:   ['Magnetic flight', 'Magnetic force fields']
};

villain.name; // => 'Magneto'
```

In Swift, the declaration of a tuple will look like this:

```swift
let villain = (
  name:     "Magneto",
  realName: "Max Eisenhardt",
  powers:   ["Magnetic flight", "Magnetic force fields"]
);

villain.name; // => "Magneto"
villain.1;    // => "Max Eisenhardt"
villain.2;    // => [...]
```

Tuples are useful when you want to return multiple values from a function as a single compound value (that is
exactly what we do so often in JavaScript).

### Arrays and Dictionaries

Definining an array or a dictionary looks very similar.

In JavaScript:

```javascript
var names = ['Alex', 'Rob', 'Dan'];
var ages  = { 'Alex': 13, 'Rob': 5, 'Dan': 4 };

names[0];     // => 'Alex'
ages['Alex']; // => 13
```

In Swift:

```swift
var names = ["Alex", "Rob", "Dan"];
var ages  = ["Alex": 13, "Rob": 5, "Dan": 4];

names[0];     // => "Alex"
ages["Alex"]; // 13
```

### Generics

In a very generic, hand wavy terms `Generics` introduce type safety and reusability of the code. They're frequently used
in classes and methods that operate on them.

To illustrate what `Generics` are, let's implement a [`Queue`](https://en.wikipedia.org/wiki/Queue_(abstract_data_type)).

```javascript
function Queue() {
  this._queue = [];
}

Queue.prototype.enqueue = function(item) {
  this._queue.push(item);
}

Queue.prototype.dequeue = function() {
 return this._queue.shift();
}

var queue = new Queue();

queue.enqueue(2);
queue.enqueue('3');
queue.enqueue(0.5);
```

Now wasn't that easy, eh?

Note, that you don't have to care about types in JavaScript that much. You just `enqueue` a value of any type
and you're all set.

Swift is different. You can't push objects of different types onto the array.

Here's a `Queue` class for `Integer` values:

```swift
class Queue {
  var _queue = Int[]();
  
  func enqueue(item: Int) {
    _queue.append(item);
  }

  func dequeue() -> Int {
    return _queue.removeAtIndex(0);
  }
}

var queue = Queue();

queue.enqueue(2);
queue.enqueue(3);
queue.enqueue(4);
queue.enqueue("4"); // Cannot convert the expression's type to type 'Int'
```

What if you want to create a `Queue` class for `String` values? You're going to have copy implementation of `Queue<Int>` class
and replace `Int` with `String`. A lot of code duplication. Here's where `Generics` shine.

```swift
class Queue<T> {
  var _queue = T[]();

  func enqueue(item: T) {
    _queue.append(item);
  }

  func dequeue() -> T {
    return _queue.removeAtIndex(0);
  }
}

var intQueue    = Queue<Int>();
var stringQueue = Queue<String>();

intQueue.enqueue(2);
intQueue.enqueue(3);
intQueue.enqueue(4);

stringQueue.enqueue("2");
stringQueue.enqueue("3");
stringQueue.enqueue("4");
```

Now you can create `Queue` of the different types with just one `Queue` implementation.

### Conclusion

Swift is a step in the right direction in my opinion. They lowered the "language ramp up" time by simplifying Objective-C syntax
quite a bit without damaging the power of the language. I feel like it looks really compelling to JavaScript developers.
