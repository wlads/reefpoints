---
layout: post
title: "Thoughts on Designing Responsive Websites"
comments: true
author: Amanda Cheung
github: acacheung
category: design
social: true
summary: "What I've learned by making a few responsive websites - Part 1"
published: false
---

## Design Via Progressive Enhancement ##

Or as some call it, mobile first (but we don't believe in device breakpoints). Why do I like to design for narrower screen sizes first? Because it places emphasis on hierarchy and content organization. It prioritizes making decisions about organizing the content of the site, which of course is the most important part! (Take a look at some of Karen McGrane's stuff if you want to read more about content strategy) Which sections make the most sense near each other? Does the layout order make it easy for a user to find what she or he is looking for? Imagine how disjointed it could be for a mobile user if the content groupings didn't flow in context among each other. Figuring all this out before moving on to designing wider screen sizes can be very helpful. Everything can't be shoved "above the fold" in mobile. Say goodbye to hearing that everything is important!

## Don't Fight the Web, Work With It! ##

Think ahead about how design elements are going to be implemented during initial design stages. Can it be written out of CSS? Maybe some elements can't be, but let's keep those to a minimal. With all the fancy CSS3 things we can do now, we shouldn't have to open up Photoshop to make design edits. In the way that form should follow function, allow implementation to inform design. This is not an argument against skeuomorphism, but it just so happens that flatter designs are more web-friendly. Sorry, pirate scrolls. Not sorry.

## Get in the Browser ASAP ##

After laying out a few wireframes, I like to jump right into HTML and CSS (or really, HAML and SASS). Whether you start on paper, Illustrator, or Photoshop, the design won't look like how it's really going to look until it's in the browser. Also, the majority of my designing and problem-solving happens in the browser where I can shrink and expand the width of the window to see how everything comes together.