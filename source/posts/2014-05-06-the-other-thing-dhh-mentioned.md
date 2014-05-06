---
layout: post
title: "The other thing DHH mentioned"
comments: true
author: 'Brian Cardarella'
github: bcardarella
twitter: bcardarella
social: true
summary: The Design Pattern Cargo Culting of the Ruby Community
published: true
tags: ruby, ruby on rails, opinion
---

By now [you've probably seen DHH's Rails Conf 2014 Keynote](http://www.confreaks.com/videos/3315-railsconf-keynote). 
Love it or hate it, the one thing you can't do is deny it got people's attention. I wasn't there, and I admit I reacted to Twitter
before actually viewing it. If you only listened on Twitter your
perception of the keynote is most likely that DHH is anti-testing. That
is very far from the truth. Go and watch the video, a lot of what he
talks about resonated with me. I still believe in "testing first" and
"red-green-refactor" but my style is not as dogmatic as some other's. I
rely on integration tests quite a bit, and I don't mind hitting the database
during unit tests. Slow tests that actually test how clients
use your app are much better than fast tests that actually test nothing.

On a side-note, I would be interested to know what DHH thinkgs about BDD
as opposed to TDD, if he even thinks there is a difference. For me I
feel there is a distinct difference and I would characterize my style of
development as BDD.

But I don't want to talk about testing. I want to talk about the other
thing DHH came down on during his keynote: Design Patterns.

Now before I get raked over the coals let me start by saying that
overall design patterns are great. It was the MVC(ish) and ActiveRecord
patterns that made Rails itself possible. When we speak in patterns it
becomes the lingua franca for programmers. I can jump from language to
language and can, with relative ease, recognize the patterns.

However, in the Ruby/Rails communities we have gone overboard. Design
Patterns are the new Holy Grail of software development. A few
years ago people were very excited about TDD, as DHH said it was sold to
us as a necessary tool for "professional software development". Now that
everybody just assumes TDD is happening the thought leaders went in
search of the next intellectually challenging concept to hold everyone
accountable for. This began to spring up maybe 2 years ago, at least
that's when I started to notice it. Design pattern talks at conferences, books
dedicated to design patterns, podcasts talking about patterns, blog
posts (of which we have written a few), code schools teaching design
patterns - developers ate them up. The Ruby community was hungry for
patterns.

There feels to me a loss of pragmatism in the ruby community. I think
this is due to there being no major problems to solve in Rails anymore.
Developers are always looking for problems to solve, and in this case
the hive mind has decided to hyper optimize on patterns.

I get it, they are intellectually stimulating. Implementing a pattern to
"perfection" will give a developer that sense of self-satisfaction. "My
code is clean". Until the next feature comes in and you have to blow up
what you've been perfecting.

Be pragmatic. Don't follow the trends just because some guys behind a
microphone say you should.
