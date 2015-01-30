---
layout: post
title: "Why I'm disappointed in React Native"
comments: true
author: 'Brian Cardarella'
twitter: 'bcardarella'
social: true
published: true
tags: opinion, javascript
---

This week at React.js Conf 2015 React Native was introduced. You can see
the two most important videos here:

<iframe width="560" height="315"
src="https://www.youtube.com/embed/KVZ-P-ZI6W4" frameborder="0"
allowfullscreen></iframe>

<iframe width="560" height="315"
src="https://www.youtube.com/embed/7rDsRXj9-cU" frameborder="0"
allowfullscreen></iframe>

The TLDR is that Facebook has developed a view layer for React that can
be used within native mobile apps. Within this context React's templates
can call native components (and views) as if you were referring to normal
HTML elements. Furthermore a JavaScript layer has been introduced to the
native layer that runs the React applications, this means that you can
debug your React Native applications in Chrome Web Tools while it runs
on an iOS device.

This is *amazing* technology and I don't think anyone was expecting
this. As an Ember developer I'm jealous. After some reflection I
realized I was also incredibly disappointed in Facebook for heading in
this direction.

### We are (supposed to be) all in this together

The web development Holy Grail right now is to compete directly with (perhaps
someday replace) native mobile applications. With React Native the web
has lost a huge partner in Facebook for helping make this a reality.
What incentive does Facebook have for pushing forward mobile web now
that they can just produce native applications with web technology? What
incentive do the existing React developers (and the large number of
developers that will move to React in the near future) have for building
and proving out mobile web use-cases with React Native? **None**.

### We are getting close

This year saw significant improvements in mobile web. We are so close.
Check out this video from Google showing off the potential of mobile
web:

<iframe width="560" height="315"
src="https://www.youtube.com/embed/v0xRTEf-ytE" frameborder="0"
allowfullscreen></iframe>

No longer is mobile web a matter of *if* but a matter of *when*.
However, with Facebook effectively taking themselves out of the
conversation we've lost one of the best use-cases and the largest voices
with one of the most popular JavaScript frameworks.

Mobile web is a point of friction currently, and that friction existing
is good because it will drive people and companies to pursue solutions
to the problem. React Native is a work-around for mobile web. Some will
think of it as a "best of both worlds" and perhaps they are correct. But
the problem of mobile web will continue to exist.

### Business needs trump ideological ones

Of course Facebook should do what is in its own best interest. [In 2012
Mark Zuckerberg said that Facebook bet too heavily on
HTML5](http://techcrunch.com/2012/09/11/mark-zuckerberg-our-biggest-mistake-with-mobile-was-betting-too-much-on-html5/).
He was correct then and he is correct now: mobile web feels like shit
when compared to native. The User Experience is the primary concern for
any product company. This, however, should not stop us from persuing
mobile web and pushing the technology forward. I just hope that React
Native doesn't impede that progress in any way.
