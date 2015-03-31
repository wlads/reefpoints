---
layout: post
title: 'Helping Our Engineers'
twitter: 'acacheung'
github: 'acacheung'
author: 'Amanda Cheung'
tags: html
social: true
comments: true
published: true
summary: 'Writing Pseudo-Code as UX Developers'
---

## Writing Pseudo-Code as UX Developers

As a team, we are always trying to improve our process at DockYard to
make things easier for one another. I’m part of the UX development team, which
takes care of the HTML and CSS/Sass for our projects.
One thing we have found to be helpful to our Ember/back-end engineers is pseudo-coding
where loops and conditionals should go in our templates. It only takes a basic understanding of
[flow control]
(https://pine.fm/LearnToProgram/chap_06.html).

When we are in the development phase of a project, UX development usually tries to
complete HTML first. That way UX dev and engineering can work in
parallel without completion times depending on each other. What can we
do to make this process smoother? Below are two code examples of what an engineer may see given these mockups.
<img alt="Has no followers"
src="https://dl.dropboxusercontent.com/u/38675407/followers--no-followers.png">
<img alt="Followers shows interests"
src="https://dl.dropboxusercontent.com/u/38675407/followers--with-interests.png">

Unorganized comments:

```handlebars
{{! at the beginning the user will not have any followers so show this}}
<div class="follows-wrap">
  <h2 class="follows--is-empty">You don’t have any followers.</h2>
</div>

{{! when a user has followers show this block and not the block above}}
<div class="follows-wrap">
  <div class="follows">
    <div class="follow">
      <img src="" class="follow__image">
      <h2 class="follow__name">Alfred H.</h2>
      <h3 class="follow__interests__heading">Follows for:</h3>
      {{! must be following for at least one interest to have a follower. when the follower is only following for one interest will not have the part that says 2 others or span below that}}
      <p class="follow__interest">Tennis &amp; Racquet Sports,
        <a href="#" class="follow__interest--other">2 others</a>
        <span class="follow__modal__interests">
          <span class="follow__modal__interest">Photography</span>
          <span class="follow__modal__interest">Soccer</span>
        </span>
      </p>
    </div>
  </div>
</div>
```

Pseudo-code comments:

```handlebars
<div class="follows-wrap">
  {{! if user has followers}}
    <div class="follows">
      {{! each follower / following}}
        <div class="follow">
          <img src="" class="follow__image">
          <h2 class="follow__name">Alfred H.</h2>
          <h3 class="follow__interests__heading">Follows for:</h3>
          <p class="follow__interest">
            Tennis &amp; Racquet Sports
            {{! if following for more than one interest}}
              ,
              <a href="#" class="follow__interest--other">2 others</a>
              <span class="follow__modal__interests">
                <span class="follow__modal__interest">Photography</span>
                <span class="follow__modal__interest">Soccer</span>
              </span>
            {{!end if}}
          </p>
        </div>
      {{! end each}}
    </div>
  {{! else}}
    <h2 class="follows--is-empty">You don’t have any followers.</h2>
  {{! end if}}
</div>
```

The unorganized way can get out of hand with complex applications. The
pseudo-code method turns out to be slightly more work for UX developers,
but it saves our engineers a lot of time and confusion. Being able to break
things down into simple if/else statements or each loops has been much more efficient.
No more reading paragraphs of what’s supposed to go where and when, or
re-organizing the template!
