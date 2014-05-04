---
layout: post
title: "The problem with server-rendered errors"
comments: true
author: 'Brian Cardarella'
github: bcardarella
twitter: bcardarella
social: true
summary: Handling validation errors returned from the server is no easy task
published: true
tags: ember
---

The 3rd most popular question with
[ember-validations](https://github.com/dockyard/ember-validations) is
how can the library work with server-rendered validation errors, such as
the ones returned with [ember-data](https://github.com/emberjs/data).

The short answer for now: it can't.

(btw, 2nd most popular question is about `uniqueness`/remote validations
and the 1st most popular question is when will I provide a `dist/`
directory... I'll cover the 2nd Q in an upcoming blog post. As far as
`dist/` its never going to happen, ever)

Here is the problem. When you are dealing with a client-side model and a
server-rendered model there won't always be a 1-to-1 representation of the
model. In those cases you can rely on ember-data's serializer to
transform the properties on a server-rendered error object to ones that
exist on the client data model. How about properties that don't exist at
all in any form on the client? You could have a validation error on
something only meant for server-rendered purposes. How do we best handle
this?

Let's imagine for a moment that we can properly map all the properties
back to their client-side equivalents. Now what? How do you resolve
these validation errors? How do you know in the UI when the validation
error has been resolved to clear the error message? Are you preventing data
submission until your client model is valid? If the errors are happening
server-side the odds are high that these are not validations that can be
known to be resolved on the client unless you do another data
submission and wait to see how the server responds.

So to re-cap the two isses are:

1. Potential lack of context on which properties errors can map back to
1. Inability to know when server-rendered validation errors are
   satisfied on the client

To start to consider a possible solution I think we need to step back
and consider the ultimate goal of client side validations. In my mind
this is puropse: *to help the user submit valid data to the server*.

Client side validations are just UI sugar. They are there to guide your
users. ember-validations only has model-layer concerns, which means you
have to provide how the validation errors are displayed on your UI. This
is why I also wrote
[ember-easyForm](https://github.com/dockyard/ember-easyForm) which
handles the complexity of what I consider to be best practices of how
validation messages should be displayed and cleared. To fix this problem
would have to tackle it from both sides:

1. How will server-rendered errors be stored in the validation graph?
   (ember-validations)
1. How will server-rendered errors be displayed and resolved in the client?
   (ember-easyForm)

### Storing server-rendered errors

If you are already using ember-data then your data model is handling
this for you already. IMO you should never mix your validations into
your data model, they should be mixed into your controller:

```javascript
var UserController =
Ember.ObjectController.extend(Ember.Validations.Mixin, {
  validations: {
    firstName: {
      presence: true
    }
  }
});
```

This way the controller has its own `errors` object which will not clash
with the `errors` object on your data model. One possiblity of
referencing the model's server-rendered errors is to have a `base`
validator that is not part of the validation graph but who's errors can
be used for presentation purposes.

### Displaying server-rendered errors

So how do you properly display these error messages? Do you try to
associate them with a property? What if that property is not represented
by a form input? What if you aren't even using a form? How do you know
when to clear the errors?

I believe this is a complex issue. My first pass at handling this in
EasyForm will be to display all of the server-rendered errors in a
single place. An upcoming version of EasyForm will simply group all
errors in `base` and display them. These errors will not clear out due
to any corrections made by the client. They will only clear when some
other action clears out those errors, for example when ember-data itself
clears out or changes the content of its `errors` object.

### Conclusion

This is far from ideal. This moves us away from the "best practices" for
[high conversion forms outlined by Luke
Wroblewski](http://alistapart.com/article/inline-validation-in-web-forms).
But it is better than not guiding your users. If the server errors for
any given reason we don't want our users sitting there without any
feedback.

I am very interested in other approaches and brainstorming on the best
direction for this. Please feel free to comment below.
