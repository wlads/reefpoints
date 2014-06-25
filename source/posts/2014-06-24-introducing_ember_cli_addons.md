---
layout: post
title: 'Introducing Ember CLI Addons'
twitter: 'rwjblue'
github: 'rjackson'
author: 'Robert Jackson'
tags: ember, ember cli
social: true
comments: true
published: true
---

Distribution of reusable Ember.js libraries has been a pain point for quite a while. During application development we have frequently wished for a silver bullet for the sharing of concepts/code from one project to another.

[Ember CLI](https://github.com/stefanpenner/ember-cli) has given us the opportunity to set the conventions for sharing that we have been searching for.

Over the last few weeks we have been focusing our efforts on the Ember CLI Addon story, and current support the following scenarios out of the box:

* Performing operations on the `EmberApp` created in the consuming applications `Brocfile.js`. The most common things this would be used to call `app.import` (see [Ember CLI - Managing Dependencies](iamstef.net/ember-cli/#managing-dependencies) for more details) or process the various options provided by the consuming application. Examples: [ember-cli-pretender](https://github.com/rjackson/ember-cli-pretender), [emberFire](https://github.com/firebase/emberFire), and [ember-cli-ic-ajax](https://github.com/rjackson/ember-cli-ic-ajax)
  
* Adding preprocessors to the default registry. This allows us to use a custom preprocessor to handle our templates, JavaScript, and/or styles. Example: [ember-cli-esnext](https://github.com/rjackson/ember-cli-esnext)

* Providing a custom application tree to be merged with the consuming application. This allows you to distribute anything that might need to be imported in the consuming application; including components, templates, routes, mixins, helpers, etc. Example: [ember-cli-super-number](https://github.com/rondale-sc/ember-cli-super-number)

* Providing custom express middlewares. This allows for an addon to completely customize the development servers behaviors, making things like automated mock Ember Data API's actually possible. This is currently only available on master (will be available in  0.0.37 and higher).

One of the design goals that the current crop of example addons follow is that they can all be installed and used simply via:

```bash
npm install --save-dev <package name>
```

## Details

### Discovery

Ember CLI detects the presence of an addon by inspecting each of your applications dependencies and searching their `package.json` files for the presence of `ember-addon` in the keywords section. 

### Creation

Once the available addons are detected, Ember CLI will require the addon.  By default it will use standard Node.js require rules (see [here](http://nodejs.org/api/modules.html#modules_all_together) for a breakdown), but you can provide a custom entry point by specifying a `ember-addon-main` property in your `package.json`.

Either way you go, during the various commands that cause a new build to be done (`ember server`, `ember test`, `ember build`, etc) Ember CLI will create a new instance of the class that your addon returns passing it the `Project` instance for the current project. The `Project` model has a few functions that might be useful to your addon. You can see a full list by inspecting the [source](https://github.com/stefanpenner/ember-cli/blob/master/lib/models/project.js), but to name a few:

* `require` -- Lets you require files or packages from the consuming application.
* `config` -- Returns the configuration for the provided environment.
* `resolve` -- Looks up a file from the root of the project using standard Node require semantics, but with the projects root as the base directory.

### Build Process Inclusion

When the consuming application's `Brocfile.js` is processed by Ember CLI to build/serve/etc the addon's `included` function is called passing the `EmberApp` instance. You can use this to access the options provided (for configuration of your addon for example).

### Intra Build Hooks

There are a few other points in the build process that your addon can hook into via the `treeFor` function. `treeFor` is called to setup the final build output for a few specific points in the build process. The addons `treeFor` function will be called with an argument that signifies which tree is being asked for.

Currently, the following trees can be customized by the addon:

* `app` -- The tree returned by your addon for the `app` tree will be merged with that of the application. This is an excellent place to add custom initializers for your addon, add routes/controllers/views/components/templates/etc (anything that goes in `app/` really). For additional information read through the [blog post](http://hashrocket.com/blog/posts/building-ember-addons) describing how `ember-cli-super-number` was turned into an addon.
* `styles` -- The tree returned by your addon for the `styles` tree will be merged with your applications styles (generally `app/styles/`).
* `vendor` -- The tree returned by your addon for the `vendor` tree will be merged with your applications vendor tree (generally `vendor/`). 

All of the trees returned by addons are merged into the corresponding tree in the application. The application's direct trees are always last so they will always override any files from an addon. This actually makes a wonderful place for application specific customization: your addon could provide a good default template, and the application can override by simple placing their own template in lat same path.

## Future

Many things are still planned for the "Addon Story" in Ember CLI. A few of them below:

* Allow addons to specify preferred ordering (before or after another addon). Similar in concept (and stolen from) the Ember initializer ordering. This is implemented on master and will be included in 0.0.37.
* Allow addons to provide a `blueprintPaths` function that will return addition paths for blueprints to be looked up. This will allow an addon to override internal blueprints or add their own.
* Allow more than one preprocessor to be used at once. Currently, it is only possible to have a single preprocessor, but this is a limitation if you want both SCSS and plain CSS (for example).
* Expose post-processed stages. This will allow for better customization of the final output which things like [autoprefixer](https://github.com/ai/autoprefixer) would be able to take advantage of.

## Call To Arms

This API is still very fluid and not set in stone. We need as much feedback as possible to truly solidify things.
