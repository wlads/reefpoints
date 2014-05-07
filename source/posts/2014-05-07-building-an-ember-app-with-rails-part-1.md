---
layout: post
title: "Building an Ember App with Rails Part 1"
comments: false
author: 'Brian Cardarella'
github: bcardarella
twitter: bcardarella
social: true
summary: ember-cli & Rails
published: true
tags: ember, ruby, ruby on rails
---

This series will take us through building and structuring an application
with an Ember front-end built with
[https://github.com/stefanpenner/ember-cli](ember-cli) and a Ruby on
Rails backend. We'll discuss project structure, testing, and deployment
to Heroku.

During the course of this series I am going to re-build the
[http://bostonember.com](Boston Ember) website. (if it looks terrible
that means I'm not done yet)

## Getting setup with our tools

Let's start by making sure all relevant dev tools are installed on our
machine. I am using the following:

* Ruby 2.1.1
* Rails 4.1.1
* Node 0.10.26
* npm 1.4.7
* Postgres (only necessary because we are deploying to Heroku)

Versions at or above these versions should be OK for following along. Please refer elsewhere on how to install these tools on your development
machine.

Next I will install ember-cli

```bash
npm install -g ember-cli
```

Confirm that you have `ember-cli` installed:

```base
ember --version
```

You should see:

```bash
version: 0.0.27
```

Or a greater version.

## Setting up our project

For this project we will keep our Rails and our Ember apps in separate
directories with a top-level directory containing the two. We'll have to
do some project generating and renaming. 

I first create a new top-level directory:

```bash
mkdir bostonember
cd bostonember
```

Now we're going to generate our Rails project:

```bash
rails new bostonember -B -S -d postgresql
mv bostonember rails
```

Note how we renamed the directory the Rails project is in to `rails`. This
does not affect anything in that directory. If you do not have Postgres
on your machine omit `-d postgresql`

Now the ember project:

```bash
ember new bostonember
mv bostonember ember
```

Now it should be obvious why we moved the Rails project. We should now have
a structure like:

Let's confirm that our ember app runs:

```bash
cd ember
ember server
```

In your browser visit `http://localhost:4200` and you should see "Welcome to Ember.js"

```
bostonember
|- ember
|- rails
```

At this point you can put everything in your top level directory under
version control:

```bash
git init
git add .
gc -m "Initial commit"
```

Let's make some modifications to our Rails app.

```bash
rm -rf rails/app/assets
```

In `rails/Gemfile` remove the following:

* coffee-rails
* jquery-rails
* turbolinks
* jbuilder

Now everything related to the Asset Pipeline is completely removed.

Add the following to the `Gemfile`:

```ruby
gem 'active_model_serializers
```

If you don't have Postgres on your machine you can set this for
Production only:

```ruby
group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
```

Run `bundle install` in your `rails` directory. Let's commit our
changes:

```bash
git add .
gc -m "Removed asset pipeline and added active_model_serializers in Rails"
```

That wraps up Part 1. In Part 2 will focus on Ember and creating
some functionality in our app.
