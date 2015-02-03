---
layout: post
title: 'Debugging a Broccoli Tree'
twitter: 'rwjblue'
github: 'rwjblue'
author: 'Robert Jackson'
tags: broccoli
social: true
comments: true
published: true
---

[Broccoli](https://github.com/broccolijs/broccoli) is a great tool for building up assets gradually through a list of changing steps. Unfortunately, when things go wrong in one of your steps it is often very difficult to figure out what is happening at each stage.

Here is where [broccoli-stew](https://github.com/stefanpenner/broccoli-stew) comes in, it is a Broccoli utility library that contains a number of super useful plugins with a [posix](https://en.wikipedia.org/wiki/POSIX) flair to them. Tools like `mv`, `rename`, `find`, `map`, `rm`, `log`, and `debug` make it much easier to reason about your Broccoli build.

And thanks to the `debug` and `log` plugins it has become **massively** easier to log the contents of each tree, or get an extra copy to poke at manually.

### Initial Brocfile.js

Lets assume you have the following `Brocfile.js`:

```javascript
// Brocfile.js
var Funnel = require('broccoli-funnel');
var ES2015 = require('broccoli-es6modules');
var log = require('broccoli-stew').log;

var app = new Funnel('app', {
  destDir: 'my-app-name',
});

var transpiledTree = new ES2015(app);

module.exports = transpiledTree;
```

The goal of the Brocfile.js listed above is:

1. Grab all files in `app/` and its subdirectories
2. "move" those files to `my-app-name/`
3. transpile those files from [ES2015](http://webreflection.blogspot.co.uk/2015/01/javascript-and-living-ecmascript.html).

So far this seems pretty easy, but what if your resulting output didn't contain the files you expected?  How would you track that down?


### Log Tree

You can log the files in a tree using `broccoli-stew`'s `log`:

```javascript
// Brocfile.js
var Funnel = require('broccoli-funnel');
var ES2015 = require('broccoli-es6modules');
var log = require('broccoli-stew').log;

var app = new Funnel('app', {
  destDir: 'my-app-name'
});

var loggedApp = log(app, { output: 'tree', label: 'my-app-name tree' });

var transpiledTree = new ES2015(loggedApp);

module.exports = transpiledTree;
```

Using `log` like this will list out the files that are present just after the `Funnel` step.  It might output something like the following:

```
my-app-name tree
└── my-app-name/
   ├── my-app-name/cat.js
   └── my-app-name/dog.js
```

This is super helpful to see that the right files are selected, but what if you are seeing the right files but the contents were not right?

### Debug Tree

Using `broccoli-stew`'s `debug` you can have a duplicate copy of the tree generated into the root of the project so you can inspect it later (it will not get cleaned up at the end of the build like the temp folders do).


```javascript
// Brocfile.js
var Funnel = require('broccoli-funnel');
var ES2015 = require('broccoli-es6modules');
var debug = require('broccoli-stew').debug;

var app = new Funnel('app', {
  destDir: 'my-app-name'
});

var debugApp = debug(app, { name: 'my-app-name' });

var transpiledTree = new ES2015(debugApp);

module.exports = transpiledTree;
```

The `debug` plugin as used above will create a folder on disk at `DEBUG-my-app-name` in the root of your project with the full contents of the `app` tree when it was called. You can review this folder's contents at your leisure without worrying about the Broccoli server calling cleanup and deleting the directory.

### Conclusion

Using `broccoli-stew` to debug a Broccoli pipeline is absolutely awesome, and makes getting a project using Broccoli much easier.  Thanks to [@stefanpenner](https://twitter.com/stefanpenner) and [@chadhietala](https://twitter.com/chadhietala) for pushing things forward!

If you'd like to checkout and play with the `Brocfile.js` above, you can do the normal `git clone` and `npm install` song and dance with [https://github.com/rwjblue/debugging-broccoli](https://github.com/rwjblue/debugging-broccoli).
