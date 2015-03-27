---
layout: post
title: "Pluralize Your Word(s) With ember-pluralize"
comments: true
author: "Romina Vargas"
twitter: "i_am_romina"
github: rsocci
social: true
summary: "Introducing a pluralizing addon based on a given count."
published: true
tags: ember, addon, javascript
---

Do you ever find yourself repeating identical pieces of code throughout
different projects? If so, that's the perfect indicator for an addon
opportunity. Ember Addons allow you to quickly integrate sharable code
into different projects, without copy and pasting, via one simple command:

```bash
  ember install:addon addon-name
```

On some of our most recent projects, we kept finding the need to
pluralize words based on _how many_ of each item we had. Also, since
our data is dynamic and constantly changing, the pluralization of a
word should remain in sync with our fluctuating data. And so
[`ember-pluralize`](https://github.com/rsocci/ember-pluralize) was born.

After a quick `ember install:addon ember-pluralize`, using the addon
is a piece of cake.

Let's suppose we have a model like so:

```javascript
export default Ember.Route.extend({
  model: function() {
    return Ember.A([
      Ember.Object.create({ name: 'Cartman', cheesyPoofs: 20 }),
      Ember.Object.create({ name: 'Stan', cheesyPoofs: 5 }),
      Ember.Object.create({ name: 'Kyle', cheesyPoofs: 1 }),
      Ember.Object.create({ name: 'Kenny', cheesyPoofs: 0 })
    ]);
  }
});
```

Now we want to output how many Cheesy Poofs each person has. This addon
provides a helper that allows us to do the following in our template:

```hbs
{{#each model as |person|}}
  {{person.name}} has {{h-pluralize person.cheesyPoofs "Cheesy Poof"}}
{{/each}}
```

which will output

```hbs
// Cartman has 20 Cheesy Poofs
// Stan has 5 Cheesy Poofs
// Kyle has 1 Cheesy Poof
// Kenny has 0 Cheesy Poofs
```

And now, as they each start throwing back some Cheesy Poofs, the counts
will start to update, as well as the word "Cheesy Poof", according to
how many are remaining. Alternatively, if you don't need to display the
actual number, passing in `omitCount=true` as the third parameter will
exclude it from the output:

```hbs
{{#each model as |person|}}
  {{person.name}}'s {{h-pluralize person.cheesyPoofs "Cheesy Poof" omitCount=true}}
{{/each}}
```

```hbs
// Cartman's Cheesy Poofs
// Stan's Cheesy Poofs
// Kyle's Cheesy Poof
// Kenny's Cheesy Poofs
```

Note: If you're using Ember Data, you will be provided with a built in pluralize
helper through the [Ember Inflector](https://github.com/stefanpenner/ember-inflector)
library. The helper is registered for availability in the template; the
functionality is similar, but given that it takes up to two arguments
(the count and the word), you're not able to solely display the pluralized
word based on a given a count.

If you'd like to see more on the addon, it can be found on
[GitHub](https://github.com/rsocci/ember-pluralize)!
