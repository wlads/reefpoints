---
layout: post
title: "Complex Search Pages Feel Better in Ember"
comments: true
author: Dan McClain
twitter: "_danmcclain"
googleplus: 102648938707671188640
github: danmcclain
social: true
summary: "Creating a better search experience with Ember"
published: true
tags: ember
---

With many server rendered search pages, a change to your search parameters
typically renders a new page. The use of some JavaScript can alter the
search results, as seen below. Note that both refreshes and JavaScript results
swapping happens.

<iframe width="560" height="315" src="//www.youtube.com/embed/pstevGCOUHs" frameborder="0" allowfullscreen></iframe>

Whenever the results are altered, it feels (and is) slow. The times that
refresh the whole page feel the slowest, but even when a partial
change happens, it's obvious and slow. It feels clunky

With Ember, we can provide a better experience. The video below is a similiar
style search page on a site we built for [Learnivore](http://learnivore.com) with Ember.

<iframe width="560" height="315" src="//www.youtube.com/embed/7F2F1iGOw4s" frameborder="0" allowfullscreen></iframe>

Notice that the page never refreshes completely. The search box always stays on
the page. And when we switch categories, only the relevant options are swapped
out, we don't have to redraw the whole page. And when we select an additional
filter on the left, only the search results are swapped out. **This page performs
better because it performs less work.** It feels better because you are constantly
seeing parts of the page reloaded without being changed. The filters on the left
only change when they need to.

It will also perform better on low bandwith connections; it only requests the
data necessary to render the page.  This will require fewer bytes to be sent
compared to the server rendered page.  When you render the page on the server,
you have to include every tag necessary to render that content. When you are
using a single page application architecture like Ember, it will only need the
data that makes up that result.

What a representation of the server rendered page looks like coming across the
web to your device:

```html
<html>
  <head>
    <title>Your search results</title>
    <!-- Several to tens of lines for stylesheets and javascript -->
  </head>
  <body>
    <header>
      <h1>Search results!</h1>
      <p>This can be tens of lines, hundreds of characters to establish content
      and look</p>
    </header>
    <div>
      <a href="somepage">Here is one of the search results</a>
      <p>Some description of your search result</p>
      <img src="SomeImage>
    </div>
    <!--Repeat the result 10/20/50 times -->
    <footer>
      <a href="about>About us</a>
      <p>Hundreds more characters to provide links, style, etc</p>
    </footer>
  </body>
<html>
```

Since the page needs to be completely reloaded, we need to display not only
the contents, but any header and footer content. This simplified example also
lacks any type of filters or inputs to alter your results, which would make the
amount of data sent to your device larger to view the page. This needs to happen
whenever the page is updated.

Compare the above to what Ember requires to update the page:

```json
{
  searchResults: [
    {
      title: 'Here is one of the search results', url: 'somepage',
      description: 'Some description of your search result', image: 'SomeImage'
    },
    Repeated 10/20/50 times
  ]
}
```

Bytes are wasted sending down the markup to render the page; it's already
there, along with the header and footer. This payload is much smaller, and
provides a friendlier experience to those on a slow connection.

We can provide better interactions with Ember because the user will not see unnecessary
rerendering of the same content. The requests to update the content will be
smaller, so new results will arrive faster. The difference in speed of these two
approaches is increased as the user's bandwidth shrinks. Faster pages help with
conversions, and Ember can provide a faster, more intuitive experience.
