---
layout: post
title: "Introducing Test Support for Ember Validations!"
comments: true
social: true
author: Marin Abernethy
twitter: "pairinMarin"
github: maabernethy
summary: "A guide to using the new test helpers in ember-validations"
published: true
tags: ember
---

If you are an avid user of [`ember-validations`](https://github.com/dockyard/ember-validations), you will be 
delighted to know the latest version includes test support! If you haven't used the [`ember-validations`]
(https://github.com/dockyard/ember-validations) addon, I recommend you check it out. It allows you to easily 
validate properties on a model in your ember applications. When a property with associated validations changes
those validations will automatically re-run to determine the state of the model. `ember-validations` comes with 
many handy built in validators including presence, absence, format, length, numericality, and even the option 
to create custom validators.

To test whether your validations are working as expected, you can now employ these two test helpers:

**[`testValidPropertyValues(propertyName, values [, context ])`](https://github.com/dockyard/ember-validations/blob/master/test-support/helpers/validate-properties.js#L61)** and

**[`testInvalidPropertyValues(propertyName, values [, context ])`](https://github.com/dockyard/ember-validations/blob/master/test-support/helpers/validate-properties.js#L65)**

  * propertyName (String): the property that you are validating.
  * values (Array): an array of property values to check.
  * context (function) *optional*: if specified, this function will be called with the object 
  under test as an argument. See example below.

For example, say we were building an Ebay or Craigslist type application where users complete a form about a 
product they would like to put on the market.

```js
import Ember from 'ember';
import EmberValidations from 'ember-validations';

export default Ember.ObjectController.extend({
  validations: {
    price: {
      numericality: true
    },
    productDescription: { 
	    presence: true, 
	    length: { minimum: 20 }
    }
  }
});
```

Given the controller and validations above, our unit tests will now look something like this:

```js
import { test, moduleFor } from 'ember-qunit';
import {
  testValidPropertyValues,
  testInvalidPropertyValues
} from '../../helpers/validate-properties';

moduleFor('controller:product', ‘Unit Test - Product New‘, {
  needs: ['ember-validations@validator:local/presence',
          'ember-validations@validator:local/length',
          'ember-validations@validator:local/numericality',
         ]
});

testValidPropertyValues('price', [350, 2]);
testInvalidPropertyValues('price', ['thirty', '', null, undefined]);

testValidPropertyValues('productDescription', [‘A shiny new Apple watch!’, ‘’]);
testInvalidPropertyValues('productDescription', [‘Fake watch', '', null, undefined]);
```

[`ember-validations`](https://github.com/dockyard/ember-validations) also allows you to add validators 
to nested objects:

```js
export default Ember.Component.extend({
  validations: {
    'seller.username': {
      presence: true,
      length: { minimum: 5 }
    }
  }
});
```

In this case, we need to stub out the `seller` in our tests so that the nested property can be
found and validated properly:

```js
beforeEach: function() {
    this.subject({
      seller: Ember.Object.create()
    });
  }
});

testValidPropertyValues('seller.username', ['BuyMyStuff', 'moneymoney123']);
testInvalidPropertyValues('seller.username', ['', null, undefined]);
```

If a property's validation is dependent upon another properties value, you can need to pass a context to the test 
helpers. Sticking with our marketplace application example, say a seller has to choose their preferred method of 
contact and is only required to enter their chosen one.

```js
export default Ember.ObjectController.extend({
  validations: {
    phone: {
      presence: {
	      if: ‘phoneIsPrefferedContactMethod’
      },
      format: {
	      with: ‘/\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/‘
      }
    }
  }
});
```

In our tests, we would set `phoneIsPrefferedContactMethod` to `true` or `false` inside a function and pass that to the
test helpers.

```js
testValidPropertyValues('phone', ['6173378898', ‘978-345-3939‘], function(subject) {
  subject.set('phoneIsPrefferedContactMethod', true);
});

testValidPropertyValues('phone', ['', null, undefined, '6173378898'], function(subject) {
  subject.set('phoneIsPreferredContactMethod', false);
});

testInvalidPropertyValues('phone', ['', null, undefined], function(subject) {
  subject.set('phoneIsPreferredContactMethod', true);
});
```

Thats it! Now that [`ember-validations`](https://github.com/dockyard/ember-validations) provides
the test helpers, [`testValidPropertyValues()`](https://github.com/dockyard/ember-validations/blob/master/test-support/helpers/validate-properties.js#L61)
and [`testInvalidPropertyValues()`](https://github.com/dockyard/ember-validations/blob/master/test-support/helpers/validate-properties.js#L65), testing your validations 
is simple and painless. Good luck!
