---
layout: post
title: "Automating Reefpoints"
comments: true
author: Dan McClain
twitter: "_danmcclain"
googleplus: 102648938707671188640
github: danmcclain
social: true
summary: "We used Travis-CI to automatically publish this blog"
published: true
tags: automation
---

We have a healthy mix of developers and designers, plus a project manager and
office manager. This results in a group of people with varying degress of command line expertise.
To make it easier to write blog posts, [I added instructions to create a blog
post using only GitHub](https://github.com/dockyard/reefpoints#the-github-web-interface-way).

This made it super easy for anyone to create a new blog post, have people
review it, but one piece was missing: making it easy for people to publish
their article once it was reviewed. Well, I solved that problem today with
[Travis-CI](http://travis-ci.org) and a little bit of bash script.

The first step required was to script the publishing of our blog. We already
use [`middleman-gh-pages`](https://github.com/neo/middleman-gh-pages), which makes publishing as easy as `rake publish`.
I created the following [`travis_deploy.sh`](https://github.com/dockyard/reefpoints/blob/master/travis_deploy.sh) script:

```sh
#!/usr/bin/env bash

set -e

git config --global user.email "socko@dockyard.com"
git config --global user.name "sockothesock"


# This specifies the user who is associated to the GH_TOKEN
USER="sockothesock"

# sending output to /dev/null to prevent GH_TOKEN leak on error
git remote rm origin
git remote add origin https://${USER}:${GHTOKEN}@github.com/dockyard/reefpoints.git &> /dev/null

bundle exec rake publish

echo -e "Done\n"
```

`middleman-gh-pages` is smart in that it figures out your GitHub remote based
on the origin, so what we did is update the origin to use a GitHUb OAuth token
that allows writing to public repos. We store the OAuth token in the
environment variable `GHTOKEN`, which we encrypt in our [`travis.yml`](https://github.com/dockyard/reefpoints/blob/master/.travis.yml):

```yml
language: ruby
sudo: false
cache: bundler
rvm:
- 2.0.0
branches:
  only:
  - master
script: "./travis_deploy.sh &> /dev/null"
env:
  secure: eAyjmkDKLbXnGvC75KRNVLoAr6WE7ldT6JGOzOKOfQ9WxhEFgzAXoKZVO4mX4DfDfJbZbCyFmxKqALXGXjaBKwU2eQKeq1g4svBnxGPHmOKFMfVjkSCFag0bppE2JK9VXn70lVYFh8kJHavHgQ2pRYlSb78WfmUKbbB9PSH/rSE=
notifications:
  slack:
    secure: o2ksyDNq6Ea2oHUbUpgICYHAUdZ0QgHSQNqgn/gginNyPYAd2MtS2h7iXVrzSgeXDSNi6WpAvAeOcUnzpA6h6oBkl0YvUTaXJs50IepWfAE4UZPwX9ZFfV8YiwnOCU9ByUTU2L9qeq83W3LuDYY7j6xZJjP5KMLC78TqTKy5pd8=
```

I also added a Slack notification so that people can see when new blog posts
get published. The last thing I did was go into the Travis-CI setting and
turned off the option to build Pull Requests, as that would publish articles
before they were merged.  I accidentally leaked the OAuth Token in the Travis
logs (that's why the `script` step is redirecting output to `/dev/null`).

In the end, it was really simple to automate the publication of our blog. It
has the added bonus of publishing corrections to the blog when anyone's pull
request is merged.
