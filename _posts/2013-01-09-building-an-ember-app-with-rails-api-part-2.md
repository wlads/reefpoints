---
layout: post
title: "Building an Ember app with RailsAPI - Part 2"
comments: true
author: "Brian Cardarella"
twitter: bcardarella
github: bcardarella
category: ember
social: true
summary: "Building the Ember app"
published: true
---

[Fork the project on Github!](https://github.com/bcardarella/ember-railsapi)

[Use the app live on Heroku](http://ember-rails-api.herokuapp.com/)

In [Part 1](/ember/2013/01/07/building-an-ember-app-with-rails-api-part-1.html) I showed you how to setup a `Rails-API` app for Ember. Now let's build the app itself.

In this part I will go over building the Ember app from the perspective of a Rails developer. I will be making comparisons to where Ember resembles common patterns in Rails and even Ruby itself.

I know I promised a 2-part series but I'm going to extend this to 3-parts. This post was growing too large to cover everything.

## Part 2 - Building with Ember

We need to start with something I forgot to setup in Part 1. Ember looks for templates in the `Ember.TEMPLATES` JavaScript object which is provided to us with the `handlebars_assets` gem we setup in Part 1. We just need to tell the gem to compile for Ember, do this in `config/initializers/handlebars_assets.rb`

{% highlight ruby %}
if defined?(HandlebarsAssets)
  HandlebarsAssets::Config.ember = true
end
{% endhighlight %}

Let's dive in by creating out application layout template in `app/assets/javascripts/templates/application.hbs`

{% highlight html %}
{% raw %}
<div class='navbar navbar-inverse navbar-fixed-top'>
  <div class='navbar-inner'>
    <div class='container'>
      <div class='nav-collapse collapse'>
        <ul class='nav'>
          <li>{{#linkTo 'home'}}Home{{/linkTo}}</li>
          <li>{{#linkTo 'users.index'}}Users{{/linkTo}}</li>
        </ul>
      </div>
    </div>
  </div>
</div>
<div class='container' id='main'>
  <div class='content'>
    <div class='row'>
      <div class='span12'>
        <div class='page-header'></div>
        {{outlet}}
      </div>
    </div>
  </div>
</div>
{% endraw %}
{% endhighlight %}

[Read more about Ember Templates](http://emberjs.com/guides/templates/handlebars-basics)

This is the Ember equivalent of a Rails layout template. The `outlet` is the Ember equivalient to `yield` in Rails. So this template will wrap the other templates we plan on rendering. I will come back to the `<li>`s in the nav later.

Next we're going to setup a default route and render a template. In `app/assets/javascripts/routes.coffee`

{% highlight coffeescript %}
App.Router.reopen
  location: 'history'
  rootURL: '/'

App.Router.map (match) ->
  match('/').to 'home'
  match('/users').to 'users'
{% endhighlight %}

[Read more about Ember Routes](http://emberjs.com/guides/routing)

This will tell the Ember Router to use the History API intead of the default 'hash' URLs for routes. We also map the root url of our app to `home`. The new Ember Router will use this string to make some assumptions. If there is a `App.HomeController` object it will use that controller. If not it will just render out the `home` template. Now, under the hood Ember is still using a `App.HomeController` controller but it will define one on the fly. I will get into this in a future blog post. When you call `reopen` this is the Ember way to reopen and monkey patch a class. As you can see the Ember Router syntax is similar to the one in Rails. This is by design. We need the 2nd route there so our `application.hbs` template can compile as it is referencing the `usersIndex` route.

Let's write `app/assets/javascripts/templates/home.hbs`

{% highlight html %}
<h1>Welcome!</h1>
{% endhighlight %}

Now let's 

That's it. If you run your rails server and load the app you should see the following
![Welcome](http://i.imgur.com/1j50C.png?1)

Congratulations you've build your first Ember app! Let's make it do
something useful. We are going to add the `/users` page, so edit
`app/assets/javascripts/templates/users/index.hbs`

{% highlight html %}
{% raw %}
<h1>Users</h1>
<table class='table table-striped'>
  <tr>
    <th>ID</th>
    <th>Name</th>
  </tr>
</table>
{% endraw %}
{% endhighlight %}

Reload your app and you can click back and forth between 'Users' and 'Home'. Thanks to the `linkTo` actions we setup in `application.hbs` that map to controllers being automatically generated because we haven't created them yet and those controllers automatically render the templates all of same naming convention. Does that sound familiar? That's right, its our good friend [Convention Over Configuration](http://en.wikipedia.org/wiki/Convention_over_configuration)!

Now when clicking between the two pages the nav is not properly updating the `active` class on the `<li>` tags. In Ember you can [bind element class names to actions](http://emberjs.com/guides/templates/binding-element-class-names) This will require a bit of code but as we add more controllers I'll show how we can easily reuse what we're about to write. Let's start by adding the bindings to `application.hbs` Modify the `<li>` tags in the nav menu to:

{% highlight html %}
{% raw %}
<li {{bindAttr class="isHome:active"}}>{{#linkTo 'home'}}Home{{/linkTo}}</li>
<li {{bindAttr class="isUsers:active"}}>{{#linkTo 'users.index'}}Users{{/linkTo}}</li>
{% endraw %}
{% endhighlight %}

This binding of `isHome:active` tells Ember to make the class `active` if the `isHome` attribute on the controller is `true`. If it is `false` the value will be nothing. The same goes for `isUsers`. Because this code lives in `application.hbs` we need to add these attributes to `app/assets/javascripts/controllers/applicationController.coffee`

{% highlight coffeescript %}
App.ApplicationController = Ember.Controller.extend
  isHome: (->
    @get('currentRoute') == 'home'
  ).property('currentRoute')

  isUsers: (->
    @get('currentRoute') == 'users'
  ).property('currentRoute')
{% endhighlight %}

[Read more about Ember Controllers](http://emberjs.com/guides/controllers)

Each attribute is a function that will compare the `currentRoute` attribute to a value and return that boolean result. We instruct the attribute to be a [computed property](http://emberjs.com/guides/object-model/computed-properties) Computed properties are simple to understand, we tell Ember that when `currentRoute` is `set` to a different value the value of `isHome` will be automatically updated. Ember will then instruct anything bound to that attribute to update as well.

Finally we're going to update our routes to set `currentRoute` depending upon the route. Let's add two route classes to `app/assets/javascripts/routes.coffee`

{% highlight coffeescript %}
App.HomeRoute = Ember.Route.extend
  setupController: (controller, model) ->
    @controllerFor('application').set('currentRoute', 'home')

App.UsersIndexRoute = Ember.Route.extend
  setupController: (controller, model) ->
    @controllerFor('application').set('currentRoute', 'users')
{% endhighlight %}

Two new concepts:

* `setupController` a function automatically called on each visit to the route. It will pass in an instance of the controller and a model if you supply one (we'll see this in a bit)
* `this.controllerFor` when interacting with a specific controller you may want to modify a different controller. In this case the wrapping controller is `ApplicationController` and we need to update the `currentRoute` attribute. You *must* use the `set` function otherwise Ember won't know to notify any computer property observers.

Now reload your app and click between the actions and your should see the active states properly set depending upon your route.

Next we're going to start using real data. We're going to fetch the collection of Users from the server and display them on the index page. Let's start with telling Ember what our data store looks like in `app/assets/javascript/store.coffee`

{% highlight coffeescript %}
App.Store = DS.Store.extend
  revision: 11
  adapter: DS.RESTAdapter.create({ bulkCommit: false })
{% endhighlight %}

[Read more about Ember's REST Adapter](http://emberjs.com/guides/models/the-rest-adapter)

The REST adapter allows us to pull from an API backend assuming certain conventions are followed in the URIs and JSON response. Thankfully we set this up properly in [Part 1](http://reefpoints.dockyard.com/ember/2013/01/07/building-an-ember-app-with-rails-api-part-1.html)

Now we'll create a new model in `app/assets/javascripts/models/user.coffee`

{% highlight coffeescript %}
App.User = DS.Model.extend(
  firstName: DS.attr('string')
  lastName:  DS.attr('string')
  quote:     DS.attr('string')
  fullName: (->
    "#{@get('firstName')} #{@get('lastName')}"
  ).property('firstName', 'lastName')
)
{% endhighlight %}

[Read more about Ember models](http://emberjs.com/guides/models)

We are defining each attribute that is coming over the wire, as well as a computed propery that will combine `firstName` and `lastName`. Simple enough!

Now we need to modify the `users` route to fetch the data

{% highlight coffeescript %}
App.UsersIndexRoute = Ember.Route.extend
  model: ->
    App.User.find()
  setupController: (controller, model) ->
    controller.set('users', model)
    @controllerFor('application').set('currentRoute', 'users')
{% endhighlight %}

The `App.User.find()` makes a remote call, fetches the collection, and instantizes the models. This collection is then passed to `setupController` through the `model` attribute. We then assign this colleciton to the `users` attribute on the controller. Now edit `app/assets/javascripts/templates.usersIndex.hbs` and add in the following before closing the `</table>` tag

{% highlight html %}
{% raw %}
{{#each user in users}}
  <tr>
    <td>{{user.id}}</td>
    <td><a href='#'>{{user.fullName}}</a></td>
  </tr>
{{/each}}
{% endraw %}
{% endhighlight %}

Reload your page and you should see something similar to
![List](http://i.imgur.com/Pq8pc.png)

Finally we're going to add a `show` page to round out this post. Let's start with the index template that we just updated. Modify the 2nd `<td>` element to:

{% highlight html %}
{% raw %}
<td>{{#linkTo 'showUser' user}}{{user.fullName}}{{/linkTo}}</td>
{% endraw %}
{% endhighlight %}

We need to next update `App.Router` for the proper mapping

{% highlight coffeescript %}
App.Router.map (match) -> 
  match('/').to 'home'
  match('/users').to 'users', (match) -> 
    match('/:user_id').to 'show'
{% endhighlight %}

Note how we are matching against `:user_id` and not `:id` that Rails developers are used to.

I must confess I don't entirely understand why the `/` map is necessary under `/users`, I would have thought the top nesting could be used and it wouldn't be necessary to redefine a root path. Please enlighten me in the comments! Ok, the router maps are updated, lets add the `show` route.

{% highlight coffeescript %}
App.UsersShowRoute = Ember.Route.extend    
  model: (params) ->
    App.User.find(params.user_id)
  setupController: (controller, model) ->
    controller.set('content', model)
    @controllerFor('application').set('currentRoute', 'users')
{% endhighlight %}

And we'll add the `app/assets/javascripts/templates/users/show.hbs` template

{% highlight html %}
{% raw %}
<h1>{{fullName}}</h1>

<div>
  <q>{{quote}}</q>
</div>

<div class='page-header'></div>

{{#linkTo 'users' class='btn'}}Back{{/linkTo}}
{% endraw %}
{% endhighlight %}

Finally we need to replace the `<a>` tags in the `users` template to:

{% highlight html %}
{% raw %}
{{#linkTo 'users.show' user}}{{user.fullName}}{{/linkTo}}
{% endraw %}
{% endhighlight %}

So we are linking to the `showUsers` named route and passing the instance of a `User` as the paramater. Ember will pull out the id on the object and set that to the `:user_id` segment on the path.

Reload your app and click through to the show page and you should see

![Show](http://i.imgur.com/8VCIi.png)

Hooray! But wait, as Rails devs we love to be [DRY](http://en.wikipedia.org/wiki/Don't_repeat_yourself) and the routes have a perfect candidate for this. We can create a base route class that our `Users` routes can inherit from:

{% highlight coffeescript %}
App.UsersRoute = Ember.Route.extend
  setupController: ->
    @controllerFor('application').set('currentRoute', 'users')

App.UsersIndexRoute = App.UsersRoute.extend
  model: ->
    App.User.find()
  setupController: (controller, model) ->
    @_super()
    controller.set('users', model)

App.UsersShowRoute = App.UsersRoute.extend    
  model: (params) ->
    App.User.find(params.user_id)
  setupController: (controller, model) ->
    @_super()
    controller.set('content', model)
{% endhighlight %}

So now we have a common route class to set the `currentRoute` attribute. And because we are using the `setupController` function in each of our child route classes we have to use the Ember `this._super()` call up the inheritance chain. `_super()` is something added to Ember to work similar to `super` in Ruby provided you have made proper use of `extend` and `reopen`.

Reload our app and everything should work!

So we have only implemented the 'Read' of 'CRUD' in this part, but we have also introduced alot of new concepts. In Part 3 we will implement the 'Create Update Destroy' actions.
