---
layout: post
title: "Thoughts on Designing Responsive Websites"
comments: true
author: Amanda Cheung
github: acacheung
category: design
social: true
summary: "What I've learned by making a few responsive websites - Part 1"
published: true
---

Things I have learned about the design process of making responsive websites:

## Design Mobile First ##

Why do I like to design for narrower screen sizes first? Because it places emphasis on hierarchy and content organization. It prioritizes making decisions about organizing the content of the site, which of course is the most important part! (Take a look at some of [Karen McGrane's stuff](http://karenmcgrane.com/category/content-strategy/) if you want to read more about content strategy) Which sections make the most sense near each other? Does the layout order make it easy for a user to find what she or he is looking for? Imagine how disjointed it could be for a mobile user if the content groupings didn't flow in context among each other. Figuring all this out before moving on to designing wider screen sizes can be very helpful. Everything can't be shoved ["above the fold"](http://iampaddy.com/lifebelow600/) in mobile. Say goodbye to hearing that everything is important!

## Don't Fight the Web, Work With It! ##

Think ahead about how design elements are going to be implemented during initial design stages. Can it be written out of CSS? Maybe some elements can't be, but let's keep those to a minimal. With all the fancy CSS3 things we can do now, we shouldn't have to open up Photoshop to make design edits. In the way that form should follow function, allow implementation to inform design. This is not an argument against [skeuomorphism](http://sachagreif.com/flat-pixels/), but it just so happens that flatter designs tend to be more web-friendly. Sorry, pirate scrolls. Not sorry.

## Get in the Browser ASAP ##

After laying out a few basic wireframes, I like to jump right into HTML and CSS (or really, [HAML](http://haml.info/) and [SASS](http://sass-lang.com/)). Whether you start on paper, Illustrator, or Photoshop, the design won't look like how it's really going to look until it's in the browser. It makes more sense for me to get right in to iterations while seeing how layouts are behaving at different screen sizes. I find myself doing a lot of trial and error because I can never be sure of what may or may not work. If I think of a possible solution, I try it out. If it doesn't work better than what I had, I'll revert it and try something else. The majority of my designing and problem-solving happens in the browser now where I can shrink and expand the width of the window to see how everything is coming together. For me, getting right into this [iterative design](http://en.wikipedia.org/wiki/Iterative_design) process beats out creating thorough mockups that will only represent so little of the "final product".

There's a lot of stuff to know so the best way to learn is to dive right in!