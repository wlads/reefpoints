---
layout: post
title: "DismissibleHelpers released"
comments: true
author: Dan McClain
twitter: "_danmcclain"
github: danmcclain
category: ruby
social: true
summary: "Add simple to implement help text that users can dismiss"
published: true
---

Have an application where you want to add some help text for the user,
but they really only need to see it once? With the
[`dismissible_helpers`](https://github.com/dockyard/dismissible_helpers)
gem, you can quickly add dismissible help text to your application.

* [View the project on GitHub](https://github.com/dockyard/dismissible_helpers)
* [View the demo here](http://dismissible-helpers-example.herokuapp.com/)
* [View the demo source code](https://github.com/dockyard/dismissible_helpers_example)

## What you get

DismissibleHelpers includes:

 * DismissibleHelpers View Helper - Renders the help text only if the visitor
has not dismissed it
 * DismissedHelpers Routes and controller - Handles the JavaScript requests
to store the dismissal state
 * DismissedHelpers Javascript - Handles the front end interactions with
the help text

By default, `dismissible_helpers` will use a cookie to store the
dismissal status of the help text.

## Three minute setup

To start using `dismissible_helpers` without any customization, you only
three steps away.

<ol>

  <li><p> Add <code>dismissible_helpers_routes</code> to your <code>config/routes.rb</code>

{% highlight ruby %}
YourApplication::Application.routes.draw do
  dismissible_helpers_routes

  # Your other routes
end{% endhighlight %}
  </p></li>

  <li><p> Add the Javascript: Add the following to your <code>app/assets/javascripts/application.js</code>.

{% highlight javascript %}
// Your other require statments
//=require dismissible_helpers
//=require_self

$(function(){
  $('.dismissible').dismissible()
}){% endhighlight %}
  </p></li>

  <li><p> Call the <code>render_dismissible_helper</code> method with the string you want to
       render. The string passed to the method will be processed by the I18n method
       <code>t</code>, so the content of the help message should be stored in your localization
       file.

{% highlight erb %}
<%= render_dismissible_helper 'help.some_help_message' %>
{% endhighlight %}
  </p></li>

</ol>

## Advanced setup

### Changing the way the help text is removed

By default, the dismissed helper is removed from the page via
`$(helper).remove()`. This can be customized by passing a callback to the
`.dismissible()` call. To use jQuery's `.slideUp()` you would use the
following call:

{% highlight javascript %}
$(function(){
  $('.dismissible').dismissible({
    success: function(helper){
      helper.slideUp(); //'helper' is the jQuery-wrapped element
    }
  });
});
{% endhighlight %}

### Storing dismissed helpers for authenticated users

`dismissible_helpers` can store the help text dismissal state on a
user/account. That way, when a user dismisses some help text, it follows
them across browsers.

`dismissible_helpers` will attempt to retrieve the authenticated user by
checking for a `current_user` helper method. If the
ApplicationController responds to `current_user`, `dismissible_helpers`
will check to see if the returned object has a `dismissed_helpers`
attribute. It will then add the dismissed help text to that model.

`dismissible_helpers` expects that the `dismissed_helpers` attribute is
an array. With vanilla ActiveRecord, you can achieve this with attribute
serialization:

First, add the column to your model (we'll assume it's an Account class
in this example)

{% highlight ruby %}
class AddDismissedHelpersToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :dismissed_helpers, :text
  end

  def down
    remove_column :accounts, :dismissed_helpers
  end
end
{% endhighlight %}

Then add the `serialize` call to your model

{% highlight ruby %}
class Account < ActiveRecord::Base
  serialize :dismissed_helpers, Array
end
{% endhighlight %}

If you are using PostgreSQL as your database, you could use
[postgres_ext](https://github.com/dockyard/postgres_ext) to
add native array support to your models. You would just need the
following migration to add the dismissed_helpers attribute
to your model:

{% highlight ruby %}
class AddDismissedHelpersToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :dismissed_helpers, :string, :array => true
  end

  def down
    remove_column :accounts, :dismissed_helpers
  end
end
{% endhighlight %}

## Wrapping up

Hopefully you find the gem useful. If you find any issues with it, 
[let us know](https://github.com/dockyard/dismissible_helpers/issues)!
