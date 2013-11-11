---
layout: post
title: 'Introducing Capybara-Extensions'
comments: true
author: 'Michael Dupuis Jr.'
twitter: 'michaeldupuisjr'
github: michaeldupuisjr
social: true
summary: "Write more descriptive tests with additional finders and
matchers for Capybara."
published: true
tags: Testing, Ruby
---

## Testing with Capybara
We love Capybara at DockYard. We use it for virtually all of our integration tests and
rely on it for writing tests that not only replicate how users flow
through an application, but also for how they interact with page
elements.

Briefly, let's take a look at a Rails application with and without
Capybara. Without Capybara, inheriting from `ActionDispatch::IntegrationTest` provides
some helpful `RequestHelpers` like `get`, which takes a path, some
parameters, and headers (via [RailsGuides](http://guides.rubyonrails.org/testing.html#integration-testing-examples)):

```ruby
require 'test_helper'
 
class UserFlowsTest < ActionDispatch::IntegrationTest
  fixtures :users
 
  test "login and browse site" do
    # login via https
    https!
    get "/login"
    assert_response :success
 
    post_via_redirect "/login", username: users(:david).username, password: users(:david).password
    assert_equal '/welcome', path
    assert_equal 'Welcome david!', flash[:notice]
 
    https!(false)
    get "/posts/all"
    assert_response :success
    assert assigns(:products)
  end
end
```

Capybara adds some syntactic sugar with its
`Capybara::Session#visit` method, and produces code that reads a lot cleaner and mimics
how a user engages with the application:

```ruby
require 'test_helper'
require 'capybara'
require 'capybara_minitest_spec' # MiniTest::Spec expectations for Capybara

class PostsTest < ActionDispatch::IntegrationTest
  fixtures :users

  test "login and browse site" do
    visit login_path

    within find('form#session-new') do
      fill_in 'username', with: users(:david).username
      fill_in 'password', with: users(:david).password
      click_button 'Submit'
    end 

    current_path.must_equal welcome_path
    page.must_have_content 'Welcome david!'

    visit posts_path
    page.must_have_content 'Welcome to ReefPoints!'
  end
end
```

Jonas Nicklas, who maintains Capybara, writes how the library leads to [cleaner tests and clearer intent](http://www.elabs.se/blog/51-simple-tricks-to-clean-up-your-capybara-tests). This is exactly what we
want from our tests, which not only test our code, but also
document our application's behavior. A lot more could be written about
this idea, but I'm going to assume I'm preaching to the choir here and
jump into DockYard's newest gem:
[CapybaraExtensions](https://rubygems.org/gems/capybara-extensions).

CapybaraExtensions extends Capybara's finders and matchers. Our goal is
to cull many of the `find` statements from our tests and remove the
verbose CSS and
xpath locators that come along with them. 

## Finders
### find_\<element\>
The library contains helper
methods for finding elements like `form`, `table`, and lists, as well as
many HTML5 elements like `article`, `aside`, `footer`, and `header`. 

So the above code in which we pass a CSS selector

```ruby
within find('form#session-new') do
  ...
end
```
becomes the following:

```ruby
within form('Login') do
  ...
end
```

In this example, "Login" is text found in the form. Passing the text contained within the element we're looking for better reflects what a user is thinking when she sees a form that
says "Login."

Finder methods are also aliased so that you can call `#form`
instead of `#find_form` (which you might expect from a finder method).
This makes for better readability with the oft-used `Capybara::Session#within` method.

### first_\<element\>
Each "find" method also has a corresponding "first" method. So when you
have multiple `article` elements on a page with the text 'Lorem ipsum,' you can call
`first_article('Lorem ipsum')` without returning an ambiguous match in
Capybara.

### \<element\>_number
In instances when you have lists or tables and you'd like to verify the
content of a specific `li` or `tr`, CapybaraExtensions allows
you to target the nth occurence of the element via
`#list_item_number` and `#row_number`.

So given the following HTML:

```html
<ul>
  <li>John Doe</li>
  <li>Jane Doe</li>
  <li>Juan Doe</li>
</ul>
```

You can find the second `li` with:

```ruby
list_item_number(2) # => 'Jane Doe'
```

Use these methods for testing how elements are being ordered.

## Matchers
CapybaraExtensions extends Capybara's matchers with methods for
verifying the presence of images, the value of input fields, and the
presence of meta tags. All of these methods return a boolean.

### field_values
CapybaraExtensions comes with a `#has_field_value?` method which checks
the value of a form field. Ensuring that your records save and update
correctly should be the domain of your unit tests, however this method
can come in handy when you're not persisting data to the back-end. For
example, after performing a search, you may want to ensure that the
query persists in the search field after redirect.

```ruby
within form('Search') do
  has_field_value?('search', 'capybara images')
end
# => true
```
### images
Asserting that text appears on the page is easy with Capybara's
`#must_have_content` method; asserting
that a particular image appears has always been a little tougher.
`#must_have_image` takes a hash with the `src` and/or `alt` attributes
you're looking for.

```ruby
page.has_image?(src: 'http://gallery.photo.net/photo/8385754-md.jpg',
alt: 'Capybara')
# => true
```

### meta_tags
`#has_meta_tag` checks the `head` for meta tags. Just pass in the `name`
and `content` you're expecting to find. We use this method quite a bit to ensure that our pages are looking good
from a search engine optimization standpoint.

```ruby
page.has_meta_tag?('title', 'Introducing CapybaraExtensions') 
# => true
```

We hope this gem makes your tests a little more descriptive and your `test_helper.rb` a little lighter. As always, we welcome pull requests and issues via Github. Thanks!

## Resources
* CapybaraExtensions on [Rubygems](http://rubygems.org/gems/capybara-extensions)
* CapybaraExtensions on [Github](https://github.com/dockyard/capybara-extensions)
* CapybaraExtensions on
[RubyDoc.info](http://rubydoc.info/gems/capybara-extensions/frames)

