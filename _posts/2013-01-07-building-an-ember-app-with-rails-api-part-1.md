---
layout: post
title: "Building an Ember app with RailsAPI - Part 1"
comments: true
author: "Brian Cardarella"
twitter: bcardarella
github: bcardarella
category: ember
social: true
summary: "Setting up RailsAPI for writing an Ember App"
published: true
---

[Fork the project on Github!](https://github.com/bcardarella/ember-railsapi)

[Use the app live on Heroku](http://ember-rails-api.herokuapp.com/)

Lately I've been playing with [Ember.js](http://emberjs.com) and I have
really grown to love it. I get the same "AHA!" feeling I got building my
first [Rails](http://rubyonrails.org) app 7 years ago. Let's see how to
build a simple
[CRUD](http://en.wikipedia.org/wiki/Create,_read,_update_and_delete) app
using the [RailsAPI](https://github.com/rails-api/rails-api) as the
backend. We're going to build a new app and deploy to Heroku.

## Part 1 - Getting Set Up

{% highlight bash %}
gem install rails-api
rails-api new ember-app
cd ember-app
{% endhighlight %}

Similar to the `rails` command `RailsAPI` comes with a `rails-api`
command which under the hood is just using the normal `rails` CLI code
but overriding some of the templates generated. Out of the box
`RailsAPI` won't generate the [asset pipeline](http://guides.rubyonrails.org/asset_pipeline.html) directories
as there is [still some
debate](https://github.com/rails-api/rails-api/issues/50) if it will use
[Sprockets](https://github.com/sstephenson/sprockets),
[Rake-Pipeline](https://github.com/livingsocial/rake-pipeline) or some
other solution. In this example we're going to use Sprockets as it will
save us a lot of time. `RailsAPI` is bundled with
[ActionPack](https://github.com/rails/rails/blob/3-2-stable/actionpack/actionpack.gemspec)
which has `Sprockets` as a dependency. All we need to do is add in the
directories

{% highlight bash %}
mkdir -p app/assets/{javascripts,stylesheets,images}
mkdir -p vendor/assets/{javascripts,stylesheets,images}
{% endhighlight %}

Now we need to copy in the vendored asset files. You can either build yourself our run the following to copy directly from my Github project

{% highlight bash %}
cd vendor/assets/javascripts
wget https://raw.github.com/bcardarella/ember-railsapi/master/vendor/assets/javascripts/ember-data.js
wget https://raw.github.com/bcardarella/ember-railsapi/master/vendor/assets/javascripts/ember.js
wget https://raw.github.com/bcardarella/ember-railsapi/master/vendor/assets/javascripts/jquery.js
wget https://raw.github.com/bcardarella/ember-railsapi/master/vendor/assets/javascripts/modernizr.js
cd ../../..
{% endhighlight %}

Let's setup the directory structure for our Ember app

{% highlight bash %}
mkdir -p app/assets/javascripts/{controllers,models,views,templates}
{% endhighlight %}

And now we'll setup the load order in our `app/assets/javascripts/application.coffee` file

{% highlight coffeescript %}
#= require modernizr
#= require jquery
#= require handlebars
#= require ember
#= require ember-data
#= require bootstrap
#= require_self
#= require store
#= require routes
#= require_tree ./controllers
#= require_tree ./models
#= require_tree ./templates
#= require_tree ./views

window.App = Ember.Application.create()
{% endhighlight %}

Add the `routes.coffee` and `store.coffee` files:

{% highlight bash %}
touch app/assets/javascripts/routes.coffee
touch app/assets/javascripts/store.coffee
{% endhighlight %}

And the `app/assets/stylesheets/application.sass` file

{% highlight sass %}
@import 'bootstrap'

body
  padding-top: 60px
{% endhighlight %}

That was a good amount of setup. Now we have the application structure for an Ember app in our asset pipeline. This will make things cleaner once we start coding.

Let's setup the necessary gem dependencies in our `Gemfile`. Just replace the entire contents with the following:

{% highlight ruby %}
source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.13'
gem 'rails-api'
gem 'thin'
gem 'active_model_serializers', :github => 'rails-api/active_model_serializers'

group :development, :test do
  gem 'debugger'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

group :assets do
  gem 'sass-rails', '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
  gem 'compass-rails'
  gem 'uglifier'
  gem 'bootstrap-sass', '~> 2.0.3.0'
  gem 'handlebars_assets'
end

group :development do
  gem 'quiet_assets'
end
{% endhighlight %}

There are two gems to take note of:

* [ActiveModelSerializers](https://github.com/rails-api/active_model_serializers) is a project that is written by the `Ember` core team which will normalize the [JSON](http://en.wikipedia.org/wiki/JSON) output for models in a `Rails` app.
* [HandlebarsAssets](https://github.com/leshill/handlebars_assets) will allow the `AssetPipeline` to compile [Handlebars](http://handlebarsjs.com/) templates which is required for Ember. There is the [Ember-Rails](https://github.com/emberjs/ember-rails) gem which will also do this but I have found `HandlebarsAssets` to be a leaner solution.

Let's create a simple model and the serializer

{% highlight bash %}
rails-api g model User first_name:string last_name:string quote:text
rails-api g serializer User
{% endhighlight %}

Now open up `app/serializers/user_serializer.rb` and add the fields that require serialization

{% highlight ruby %}
class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :quote
end
{% endhighlight %}

Again, this will instruct `Rails` to turn our `ActiveRecord` object into a `JSON` object properly normalized for `Ember`. Let's write the Controller. Create and edit `app/controllers/users_controller.rb`

{% highlight ruby %}
class UsersController < ApplicationController
  def index
    render json: User.all
  end
end
{% endhighlight %}

Take note that we are inheriting `ApplicationController` but in a `RailsAPI` app `ApplicationController` itself inherits from `ActionController::API` instead of `ActionController::Base`.

This basic controller will serve up all of our users to our Ember app. We'll add more later.

Now let's add some routes to `config/routes.rb`

{% highlight ruby %}
EmberApp::Application.routes.draw do
  class FormatTest
    attr_accessor :mime_type

    def initialize(format)
      @mime_type = Mime::Type.lookup_by_extension(format)
    end

    def matches?(request)
      request.format == mime_type
    end
  end

  resources :users, :except => :edit, :constraints => FormatTest.new(:json)
  get '*foo', :to => 'ember#index', :constraints => FormatTest.new(:html)
  get '/', :to => 'ember#index', :constraints => FormatTest.new(:html)
end
{% endhighlight %}

A few things are happening here:

* We are constraining against the format with a custom `FormatTest` class. We only want to map certain routes to `JSON` requests and certain routes to `HTML` requesets.
* The `get '*foo'...` will greedily match all routes except `/` so we have the following line. We want to direct all `HTML` requests to a single `controller#action`. I will go into the reason why in a bit.

So let's create that `Ember` controller. This will act as the primary application serving controller that is hit when people visit the app.

{% highlight ruby %}
class EmberController < ActionController::Base; end
{% endhighlight %}

Note that we are inheriting from `ActionController::Base` this time and not `ApplicationController`. This was the controller actions can respondt to non `JSON` requests.

Now we will add the view in `app/views/ember/index.html.erb`

{% highlight erb %}
<!DOCTYPE html>
<html lang='en'>
  <head>
    <%= stylesheet_link_tag :application, :media => :all %>
    <%= javascript_include_tag :application %>
    <title>Title</title>
  </head>
  <body>
  </body>
</html>
{% endhighlight %}

That is all the view that your Ember app will need. Ember will automatically attach its own default template to the `<body>` tag.

Let's add some data to `db/seeds.rb`

{% highlight ruby %}
User.create(:first_name => 'William', :last_name => 'Harrison', :quote => "I'm just singin' in the rain!")
User.create(:first_name => 'Abraham', :last_name => 'Lincoln', :quote => "I'd like to see a show tonight.")
{% endhighlight %}

Now run your migrations and seed

{% highlight bash %}
rake db:migrate db:seed
{% endhighlight %}

Ok, now our app is in a good spot to start developing an Ember app with. Let's review what we did

1. Generated a new app using `rails-api`
2. Set up the javascript and stylesheet assets
3. Wrote a very simple JSON API for returning all users

If you fire up your app you'll see a blank page. Not too interesting. In [Part 2](http://reefpoints.dockyard.com/ember/2013/01/09/building-an-ember-app-with-rails-api-part-2.html) we'll build the Ember app itself.

