---
layout: post
title: "ClientSideValidations 3.2 Released!"
comments: true
author: Brian Cardarella
twitter: bcardarella
github: bcardarella
legacy_category: ruby
social: true
summary: "Better late than never"
published: true
tags: ruby on rails, gems
---

I just released [ClientSideValidations 3.2](https://github.com/bcardarella/client_side_validations)

This is a very big release for the gem, one that took *way* too much
time to get done. I want to start by re-introducing people to the gem,
what the value is, and what the changes for 3.2 are.

ClientSideValidations is just that, it will extract the validations from
your model and apply them to your forms on the client. The
[README](https://github.com/bcardarella/client_side_validations/blob/master/README.md)
has more comprehensive instructions. But here is the quick guide:

Add `rails.validation.js` to your asset pipeline, then add `:validate =>
true` to your form like so:

```erb
<%= form_for @user, :validate => true do |f| %>
```

And that is it. If you have more [complex validators](https://github.com/bcardarella/client_side_validations/blob/master/README.md#conditional-validators) or 
[custom validators](https://github.com/bcardarella/client_side_validations/blob/master/README.md#custom-validators)
on your models then you can quickly support these as well.

## Changes ##

Version 3.2 brings many changes to the gem. The first of which is that
from this version on we will be following [Semantic Versioning](http://semver.org) or trying our best to do so.

The next change, and the biggest backward-incompatible change, is that
the support for `SimpleForm`, `Formtastic`, `Mongoid`, and `MongoMapper`
have been removed. These have been put into their own
[plugins](https://github.com/bcardarella/client_side_validations/wiki/Plugins):

* [SimpleForm](https://github.com/dockyard/client_side_validations-simple_form)
* [Formtastic](https://github.com/dockyard/client_side_validations-formtastic)
* [Mongoid](https://github.com/dockyard/client_side_validations-mongoid)
* [MongoMapper](https://github.com/dockyard/client_side_validations-mongo_mapper)

This will be the convetion from now on. The `ClientSideValidations` gem
itself will only support `Rails` out of the box. If there are additional
FormBuilders or ORMs that people need support for these will be done so
via the plugins. This will allow for quicker bug fixes and less
complexity in the core gem.

I have also released a gem for [Turbolinks support](https://github.com/dockyard/client_side_validations-turbolinks).
Turbolinks support will be part of the core gem for the next release
(4.0).

There have been a significant number of bug fixes for this release. If
you ran into a bug before odds are it is now resolved.

`Proc`s are now fullow supported in `ActiveModel` validators, you just
have to force the validation to evaluate:

```erb
<%= f.text_field, :validate => { :length => true } %>
```

I have also added a FormBuilder method for adding validations for
attributes that are not being written to the form but may be added
dynamically later:

```erb
<%= f.validate :age, :weight %>
```

This method can also take validator specific options.

## JavaScript API Additions and Changes ##

The first major change is that `data-validate="true"` is no longer
rendered on the inputs server-side. It is added to the input at
run-time.

The second is the addition of some [jQuery functions](https://github.com/bcardarella/client_side_validations/blob/master/README.md#enabling-disabling-and-resetting-on-the-client):

```javascript
$(form or input).enableClientSideValidations();
$(form or input).disableClientSideValidations();
$(form).resetClientSideValidations();
```

* `$.fn.enableClientSideValidations()` acts upon either a form or input
  and will enable them for ClientSideValidations. If you are adding
forms or inputs dynamically to the DOM via AJAX or some other means you
*need* to call this function on them.

* `$.fn.disableClientSideValidations()` acts upon either a form or an
  input and will disable them for ClientSideValidations.

* `$.fn.resetClientSideValidations()` will reset the validations. This
  means disabling, removing all error messages, and enabling
validaitons.

## Security ##

There have been some security fixes. Mostly around the `Uniqueness`
middleware.

* Calls to the uniqueness middleware only act upon models and
attributes that have a uniqueness validator defined in the model.

* The [API for turning off uniqueness app-wide has been changed](https://github.com/bcardarella/client_side_validations/blob/master/README.md#security).

## Backwards incompatiable changes ##

* If you were relying upon `data-validate="true"` being rendered on the
  inputs from the server your code will break.

* `ClientSideValidations::Config.uniqueness_validator_disabled` has been
  removed. Please add `ClientSideValidations::Config.disabled_validators
= [:uniqueness]` to your initializer if you require this functionality.

Please give the gem a try and [let me know](http://twitter.com/bcardarella) what you think!
