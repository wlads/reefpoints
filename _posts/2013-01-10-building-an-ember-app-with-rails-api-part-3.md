---
layout: post
title: "Building an Ember app with RailsAPI - Part 3"
comments: true
author: "Brian Cardarella"
twitter: bcardarella
github: bcardarella
category: ember
social: true
summary: "CUD, it isn't just for cows"
published: true
---

[Fork the project on Github!](https://github.com/bcardarella/ember-railsapi)

[Use the app live on Heroku](http://ember-rails-api.herokuapp.com/)

In [Part 1](/ember/2013/01/07/building-an-ember-app-with-rails-api-part-1.html) I showed you how to setup a `Rails-API` app for Ember.

In [Part 2](/ember/2013/01/09/building-an-ember-app-with-rails-api-part-2.html) I showed you the basics of building an Ember app, reading from a backend API and displaying that information.

Today we're going to do some coding on the Rails side and the Ember side to add Creating, Updating, and Destroying records.

## Part 3 - The Big Finish

In [Part 1](http://reefpoints.dockyard.com/ember/2013/01/07/building-an-ember-app-with-rails-api-part-1.html) we setup the backend using [Rails API](https://github.com/rails-api/rails-api/). In [Part 2](http://reefpoints.dockyard.com/ember/2013/01/09/building-an-ember-app-with-rails-api-part-2.html) we built out the basics of an Ember app, reading from a remote data source and displaying that data. Now we're going to add the ability to Create, Update, and Destroy that data. This part will be a mix of Ember and Rails code.

*Note: If you have been following along that [Part 2](http://reefpoints.dockyard.com/ember/2013/01/09/building-an-ember-app-with-rails-api-part-2.html) was recently updated to reflect new changes to the Ember Router, you will need to go back and update your code. Absolute make sure to update your ember.js and ember-data.js dependencies as they have been updated on the github repo*

### Create ###

Let's start by adding a `Create` button to our index page:

{% highlight html %}
{% raw %}
{{#linkTo 'users.new' class='btn btn-primary'}}Create{{/linkTo}}
{% endraw %}
{% endhighlight %}

We need to add the proper route so the index page doesn't blog up. While we're in here we'll add the `edit` route as well.

{% highlight coffeescript %}
App.Router.map (match) ->
  @resource 'users', ->
    @route 'new'
    @route 'edit',
      path: '/:user_id/edit'
    @route 'show'
      path: '/:user_id'
{% endhighlight %}

And now we can add the `UsersNewRoute`

{% highlight coffeescript %}
App.UsersNewRoute = App.UsersRoute.extend
  model: ->
    App.User.createRecord()
  setupController: (controller, model) ->
    @_super()
    controller.set('content', model)
{% endhighlight %}

Don't be fooled by the `createRecord()` call. This will not write anything to the backend. This call is simply used to create a new model. Now let's create the template `app/assets/javascripts/templates/users/new.hbs`

{% highlight html %}
{% raw %}
<h1>Create {{fullName}}</h1>
<form>
  <fieldset>
    <div>
      <label {{bindAttr for="firstNameField.field_id"}}>First Name</label>
      {{view Ember.TextField valueBinding='firstName' name='first_name' viewName='firstNameField'}}
    </div>
    <div>
      <label {{bindAttr for='lastNameField.elementId'}}>Last Name</label>
      {{view Ember.TextField valueBinding='lastName' name='last_name' viewName='lastNameField'}}
    </div>
    <div>
      <label {{bindAttr for='quoteField.elementId'}}>Quote</label>
      {{view Ember.TextArea valueBinding='quote' name='quote' viewName='quoteField'}}
    </div>
    <a href='#' {{action save}} class='btn btn-success'>Create</a>
  </fieldset>
</form>
<div class='page-header'></div>

<a href='#' {{action cancel}} class='btn btn-inverse'>Cancel</a>
{% endraw %}
{% endhighlight %}

Next we'll add `app/assets/javascripts/controllers/users/newController.coffeescript`

{% highlight coffeescript %}
App.UsersNewController = Ember.ObjectController.extend
  save: ->
    @store.commit()
    @content.addObserver 'id', @, 'afterSave'

  cancel: ->
    @content.deleteRecord()
    @transitionToRoute('users.index')

  afterSave: ->
    @content.removeObserver 'id', @, 'afterSave'
    @transitionToRoute('users.show', @content)
{% endhighlight %}

The first two function `save` and `cancel` are actions that are mapped in the template. Let's break down each:

* `save` will make a call to `this.store.commit()`. You will notice we are not modifying a model, assigning params, etc... as you would in a Rails app. Keep in mind that when you modify data that is bound in the form you are actually modifying the data in the model itself. The datastore in Ember needs to be directed when these modifications should be made "permanent", and because we are using the RESTAdapter Ember will attempt to write these changes to the backend. We then attach an observer to the model's `id` attribute, when it changes we want to then transition off the page and to the `show` page for the model.
* `cancel` If the user decides to not create a new user we must delete the record we created then transition to the `index` page.

There is (what I believe is) a bug in Ember-Data that currently prevents you from using the Model Lifecycles to properly handle creates. In the example above the code will only move forward if the backend responds with a 200. This of course won't work if there is an error of some type. The use will get stuck. Ideally the code should be:

{% highlight coffeescript %}
save: ->
  @content.one 'didCreate.user', ->
    @content.die '.user'
    @transitionToRoute 'users.show', @content
  @content.one 'didError.user', ->
   @content.die '.user'
   # handle the errors however you want
{% endhighlight %}

This would use the life cycle callbacks and the jQuery `one` event. Hopefully this issue is addressed soon as this is the ideal way to handle these create events.

[Learn more about the Ember Model Lifecycle](http://emberjs.com/guides/models/model-lifecycle)

Finally we're going to hook up the back end in `app/controllers/users_controller.rb`

{% highlight ruby %}
def create
  user = User.new(params[:user])

  if user.save
    render json: user
  else
    render json: user, status: 422
  end
end
{% endhighlight %}

It has been mentioned that `422` is the proper status code for validation failures. Personally I would prefer to use `respond_with` but it isn't part of the default Rails-API stack, [hopefully this will change](https://groups.google.com/forum/?fromgroups=#!topic/rails-api-core/QhPh2VG7yTU).

Now let's run our app and see how it goes.

![New1](http://i.imgur.com/JnTn3.png)

Whoops, we have `undefined undefined` for the `fullName`. Let's set `firstName` and `lastName` to empty strings in our `new` route:

{% highlight coffeescript %}
App.UsersNewRoute = App.UsersRoute.extend
  model: ->
    App.User.createRecord({firstName: '', lastName: ''})
{% endhighlight %}

If anybody knows of a cleaner way to do this please leave a comment below. I suspect there is a way to set the default value in the model itself.

Now when we add data and create it will write to the back end, take us to the show page. When can then click `Back` and we can see the record has been automatically added to the collection on the `index` page.

Adding `Edit` should be straight forward now that we have done create. Start will adding the route:

{% highlight coffeescript %}
App.UsersEditRoute = Ember.Route.extend
  model: (params) ->
    App.User.find(params.user_id)
  setupController: (controller, model) ->
    controller.set('content', model)
    @controllerFor('application').set('currentRoute', 'users')
{% endhighlight %}

You'll notice that this route is identity to `App.UsersShowRoute` we wrote in Part 2, let's DRY this up

{% highlight coffeescript %}
App.UserRoute = Ember.Route.extend
  model: (params) ->
    App.User.find(params.user_id)
  setupController: (controller, model) ->
    controller.set('content', model)
    @controllerFor('application').set('currentRoute', 'users')

App.UsersShowRoute = AppUserRoute.extend()
App.UsersEditRoute = AppUserRoute.extend()
{% endhighlight %}

Next we'll add the edit link to `app/assets/javascripts/templates/users/show.hbs`

{% highlight html %}
{% raw %}
{{#linkTo 'users.edit' content class='btn btn-primary'}}Edit{{/linkTo}}
{% endraw %}
{% endhighlight %}

Now the edit template itself in `app/assets/javascripts/templates/users/edit.hbs`

{% highlight html %}
{% raw %}
<h1>Edit {{fullName}}</h1>
<form>
  <fieldset>
    <div>
      <label {{bindAttr for="firstNameField.field_id"}}>First Name</label>
      {{view Ember.TextField valueBinding='firstName' name='first_name' viewName='firstNameField'}}
    </div>
    <div>
      <label {{bindAttr for='lastNameField.elementId'}}>Last Name</label>
      {{view Ember.TextField valueBinding='lastName' name='last_name' viewName='lastNameField'}}
    </div>
    <div>
      <label {{bindAttr for='quoteField.elementId'}}>Quote</label>
      {{view Ember.TextArea valueBinding='quote' name='quote' viewName='quoteField'}}
    </div>
    <a href='#' {{action save}} class='btn btn-success'>Update</a>
  </fieldset>
</form>
<div class='page-header'></div>

<a href='#' {{action cancel target='controller'}} class='btn btn-inverse'>Cancel</a>
{% endraw %}
{% endhighlight %}

And now the controller `app/assets/javascripts/controllers/users/editController.coffee`

{% highlight coffeescript %}
App.UsersEditController = Ember.ObjectController.extend
  save: ->
    @store.commit()
    @transitionToRoute 'users.show', @content

  cancel: ->
    if @content.isDirty
      @content.rollback()
    @transitionToRoute 'users.show', @content
{% endhighlight %}

This controller looks similar to `App.UsersNewController` but let's explore the differences

* `save` here because the model already has an `id` we can commit to the datastore and transition. Again, once the bug mentioned above is resolved we would handle this differently.
* `cancel` instead of deleting the record we want to rollback to its previous state. And we can only rollback if the record has changed.

I'm sure you know what is next. The `new` template is nearly identical to the `edit` template. Let's create `app/assets/javascripts/templates/users/form.hbs`

{% highlight html %}
{% raw %}
<h1>{{headerTitle}} {{fullName}}</h1>
<form>
  <fieldset>
    <div>
      <label {{bindAttr for="firstNameField.field_id"}}>First Name</label>
      {{view Ember.TextField valueBinding='firstName' name='first_name' viewName='firstNameField'}}
    </div>
    <div>
      <label {{bindAttr for='lastNameField.elementId'}}>Last Name</label>
      {{view Ember.TextField valueBinding='lastName' name='last_name' viewName='lastNameField'}}
    </div>
    <div>
      <label {{bindAttr for='quoteField.elementId'}}>Quote</label>
      {{view Ember.TextArea valueBinding='quote' name='quote' viewName='quoteField'}}
    </div>
    <a href='#' {{action save}} class='btn btn-success'>{{buttonTitle}}</a>
  </fieldset>
</form>
<div class='page-header'></div>

<a href='#' {{action cancel target='controller'}} class='btn btn-inverse'>Cancel</a>
{% endraw %}
{% endhighlight %}

And in both the `new` and `edit` template remove the markup and replace with

{% highlight html %}
{% raw %}
{{ template 'users/form' }}
{% endraw %}
{% endhighlight %}

Now we need to edit the two controllers. In `App.UsersNewController` add to the two attributes:

{% highlight coffeescript %}
headerTitle: 'Edit'
buttonTitle: 'Update'
{% endhighlight %}

And likewise in `App.UsersEditController`:

{% highlight coffeescript %}
headerTitle: 'Create'
buttonTitle: 'Create'
{% endhighlight %}

Last part for this section is to add the `update` action to `app/controllers/users_controller.rb`:

{% highlight ruby %}
def update
  user = User.find(params[:id])
  if user.update_attributes(params[:user])
    render json: user
  else
    render json: user, status: 422
  end
end
{% endhighlight %}

Now go through and everything should work! This allows us to treat the templates similar to a partial in Rails.

Finally we're going to add the ability to delete records. Because this is an action we are going to limit to the `edit` page we will put the link below the `render` call

{% highlight html %}
{% raw %}
<a href='#' {{action 'destroy'}} class='btn btn-danger'>Destroy</a>
{% endraw %}
{% endhighlight %}

Now we add the action to the `App.UsersEditController`

{% highlight coffeescript %}
destroy: ->
  @content.deleteRecord()
  @store.commit()
  @transitionToRoute 'users.index'
{% endhighlight %}

And we add the `destroy` action to the backend

{% highlight ruby %}
def destroy
  user = User.find(params[:id])
  if user.destroy
    render json: user, status: 204
  else
    render json: user
  end
end
{% endhighlight %}

The `204` status here is refers to `No Content`. Ember-data expects this to ensure the destroy action is a success.

That's it! You've just created your very first Ember app with all of the CRUD actions. Congratulations!
