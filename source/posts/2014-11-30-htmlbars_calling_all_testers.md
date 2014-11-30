---
layout: post
title: 'HTMLBars: Calling All Testers'
twitter: 'rwjblue'
github: 'rwjblue'
author: 'Robert Jackson'
tags: ember, ember cli, htmlbars
social: true
comments: true
published: true
---

HTMLBars support has landed in Ember's canary channel thanks to the tireless work
of the HTMLBars team. Make sure to chat them up at [EmberConf](http://emberconf.com/) (you
are going right?!?!) for some war stories.

We are nearing the end of the 1.9 [beta cycle](http://emberjs.com/builds/#/beta) (aiming for 2014-12-06)
which means we will be making the go / no-go decision on all pending features in Canary when we branch
for the next beta cycle. Clearly, we would all love to have 1.10 use HTMLBars.

In order to enable the HTMLBars feature flag in the 1.10 betas (shipping around 2014-12-09), we need
help confirming that no major issues exist. This is where *you* come in!

### Using Canary Builds with Ember CLI

Upgrading to the canary channel with Ember CLI is very straightforward.

#### Update Bower

Run the following:

```bash
rm -rf bower_components
bower install --save handlebars#~2.0.0
bower install --save ember#canary
bower install
```

Bower also prompts you to confirm various "resolutions" that it is unsure of. Make sure you
pick `ember#canary` and Handlebars 2.0 if prompted.

#### Update NPM Dependencies

Run the following:

```bash
npm uninstall --save-dev broccoli-ember-hbs-template-compiler
npm install --save-dev ember-cli-htmlbars
```

#### Summary

Now we have successfully updated to the latest canary builds of Ember. Next up: HTMLBars.

### Using HTMLBars with Ember CLI

Enabling HTMLBars is as simple as adding the following to your `config/environment.js` (under
`EmberENV.FEATURES` section):

```
EmberENV: {
  FEATURES: {
    'ember-htmlbars': true
  }
},
```

Now restart any running `ember serve` commands you have and you should be running with HTMLBars.

### Report Issues

This part is critical: Please report any issues [at GitHub](https://github.com/emberjs/ember.js/issues),
especially regressions from 1.8 or 1.9-beta. If your business has certain browser requirements (IE8 for example)
testing on those edge-case platforms today will help us resolve issues in time for 1.10.
