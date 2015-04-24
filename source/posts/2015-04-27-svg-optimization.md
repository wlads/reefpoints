---
layout: post
title: "Reduce Page Size With One Optimized SVG File"
comments: true
social: true
author: Cory Tanner
twitter: "ctannerweb"
ithub: ctannerweb
summary: "Showing you how to combine multiple svg files into a single optimized SVG and then use it site wide."
published: true
tags: html, css
---

It's sometimes hard to decide on best practices for implementing multiple SVGs (Scalable Vector Graphics) in your app or website.

Currently at [DockYard](https://twitter.com/DockYard "DockYard Twitter") we are working on a new project which includes rethinking graphic optimization. The obvious choice is to have every graphic possible in a SVG format rather than .png files.

With the now mandatory responsive design standards for websites you need vector images that scale cleanly on any screen size.

SVG’s are the obvious choice but how to organize them is the real question.

# Lets get into the fun stuff
There are two main techniques of implementing SVG’s into your website.

Placing `<svg>` code into your HTML directly (inline SVG).

Save a .svg file to your `/image` folder for every vector image and style a `<div>` with the background-image as the .svg file

Both have advantages and disadvantages that I want to go over before I present the solution.

### Inline SVG
With a inline SVG you are doing just how it sounds, copying SVG code directly into your HTML.

It should look like this

```hmtl
<svg class="Narwin" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 369.81 335.778" enable-background="new 0 0 369.81 335.778">
  <path d="m369.76 0h-3.278c-1.631.677-3.824 1.941-6.495 3.828-6.155 4.304-75.846 54.04-106.39 76.55-11.04-5.284-35.756-13.821-69.785-6.259-44.22 9.811-57.758 50.991-59.59 102.62-1.846 51.639-3.074 93.43-33.2 108.78-30.11 15.37-49.3-5.888-52.848-14.74-1.218-3.075 12.924-11.07 6.158-35.03 0 0-14.742 7.366-19.672 15.369 0 0-12.295-15.369-24.572-14.771 0 0-2.175 27.521 15.369 35.05 4.284 1.847 9.803 46.707 54.684 57.765 44.852 11.04 134.59 8.602 167.16-9.849 32.557-18.423 40.473-42.599 45.46-102.62 3.557-42.656 3.576-86.58-6.429-112.3 22.978-23.46 84.49-91.94 90.13-98.5 2.234-2.61 3.298-4.466 3.345-5.507v-.022c.003-.138-.015-.258-.047-.367m-153.44 216.8c-.733 7.482-12.826 23.18-16.779 31.368-7.367 15.272-8.508 29.454-19.21 43.838-7.821 10.46-22.454 17.15-35.679 16.868-5.05-.098-23.19-3.161-17.545-11.638 6.728-10.07 15.96-15.719 21.07-27.89 6.293-14.992 9.232-27.916 19.05-41.815 14.481-20.475 50.41-24.64 49.09-10.731m-5.441-75.42c-7.05 2.291-14.598-1.576-16.888-8.633-2.281-7.06 1.565-14.644 8.643-16.916 7.04-2.272 14.625 1.594 16.906 8.651 2.29 7.06-1.575 14.645-8.661 16.898"></path>
</svg>
```

Editing the `<path>` is not normally necessary but you should edit the `<svg>` and add a class. The important thing to keep in mind is that with the class you can style your `<svg>` in your css.

The positives with Inline SVG is that it is extremely lightweight. Something this small would only weigh about 2kb. That size is dependent on the complexity of the paths inside the SVG tags.

When you start to get more complicated SVG’s with groups and multiple paths your code length will begin to increase greatly. You can end up with over 100 lines of SVG code in your HTML if your graphic is too complex.

### .SVG Files
The method of saving every SVG graphic/icon as an independent file can be appealing and seem like the go to solution for your SVG questions. The process of saving an image to your `/images` folder and then using css to make a background-image is simple and the same as adding a normal .jpg as a background-image.

```html
.process__graph {
  background-image: url(/images/graph.svg);
}
```

This will make your HTML lighter than the inline SVG approach but will increase media weight per page.

The important thing to remember is that chrome will only carry around 6 images at a time when it pulls files from the server. This means that when you save all your SVG’s as independent files it will slow down your page speed.

This is why we want to stay away from saving multiple .svg files to our `/images` folder because we don’t want to bottleneck ourselves with being limited in the amount of vector images we can use on a single page.

# Solution???
<img src="http://i3.kym-cdn.com/photos/images/original/000/538/731/0fc.gif" title="Why not both inline and a .svg file" style="max-width: 450px;"/>

This is a technique that [Amanda](https://twitter.com/acacheung) showed me and I quickly saw the benefits in code organization and page performance.

To make this simple and quick we are going to be dealing with three graphs that we need on the page. Each graph has unique patterns that makes the code way to long to use as inline SVG.

![](http://i.imgur.com/xizVEao.png "Research")

![](http://i.imgur.com/lHT1K1B.png "Creation")

![](http://i.imgur.com/GfiKWKd.png "Project")

If we make independent .svg files and then need to add more in the future we will start to affect page load times with all the files the browser has to pull from the server.

The solution is to make one file the browser has get but apply inline SVG code that asks for only a certain group ID inside the .svg that we will specify. This technique will only show the graph we want even when there are 3 graphs in one .svg file.

### Making your .SVG File
In illustrator make sure the artboard width and height are equal to all three graphs width and height when stacked on top of each other. In this example we have 360px by 108px (width/height) graphs.

**Step One**

To find the needed  artboard size with the specified single graph size we want to multiply the height by three.

**Step Two**

The width will stay the same which results in a 360px by 324px artboard in illustrator.

**Step Three**

In illustrator stack each graph on top of each other with 0px space between each graph. This is to keep the math we are going to be using easy.

![](http://i.imgur.com/7FDPysL.png "All 3 Graphs")

**Step Four**

Now you want each graph to be in its own separate group inside the `Layer 1` group. This is very important for when we use our inline SVG to identify which graph we are using.

**Final Step**

When this is done you want each group to be [ungrouped](https://helpx.adobe.com/illustrator/using/grouping-expanding-objects.html) as much as we can in order to eliminate unnecessary groups and paths. This will help optimize the final .svg file.

<img src="http://i.imgur.com/CCUaL8a.png" title="Layers" style="max-width: 300px;"/>

You should be left with one top layer and three sub groups that are named how you want them to be identified in the `<svg>` code.

Save your file as a .svg and place it in your `/images` folder.

### Lets get started with some HTML!
```html
<svg class="process__graph" title="Research Graph" viewBox="0 0 360 108">
  <use xlink:href="images/graph--shared.svg#research"\></use>
</svg>
```

**What is this?**

We have combined the advantages of both inline `<svg>` code and .svg files. We still have our class inside the `<svg>` element which lets us do anything we want to it with css. Then we have a `<use>` element that asks for the research group ID that we specified in the .svg layers.

The trick here is to get our math correct in the viewbox. We want the first graph inside this .svg file so we are starting at

viewBox=“**0 0** 360 108"

which is x=0 and y=0 in our .svg file (top left). The next two numbers are the aspect ratio of the graph we want. This is the same for every graph in this example.

The `<use>` element is what does most of the magic. You declare the path to your .svg file and follow that with the relevant group ID.

```html
<use xlink:href="images/graph--shared.svg#research"\></use>
```

For the second graph further down the page we add the following to our HTML.

```html
<svg class="process__graph" title="Creation Graph" viewBox="0 108 360 108">
  <use xlink:href="images/graph--shared.svg#creation"\></use>
</svg>
```

As you can see we changed the viewbox to start at y=108. This will start the viewbox exactly where the second graph starts in the file.

Like the first graph the height is the same so we are starting at 180px Y and ending after another 108px Y as stated in the viewBox.

viewBox=“0 **108** 360 **108**”

The last graph we follow the same rules.

```html
<svg class="process__graph" title="Project Graph" viewBox="0 216 360 108">
  <use xlink:href="images/graph--shared.svg#project"\></use>
</svg>
```

The third graph starts at 216px Y and ends after another 108px Y.

### The CSS
You may have noticed that I have a class inside the `<svg>`.

This is so we can control the .svg image that will be on the page. You want to define the width and height of your image in the css and apply any styling you need done on the SVG.

```css
.process__graph {
  height: 108px;
  width: 360px;
}
```

In this CSS class you can add floats or center the image with

```css
.process__graph {
  margin-right: auto;
  margin-left: auto;
  height: 108px;
  width: 360px;
  display: block;
}
```
Feel free to do any kind of styling to the SVG.

## What have we done?
We have taken the best of two techniques.

The inline HTML is clean and simple while only using one .svg file so the browser does not have to make multiple trips back to the server.

As [Brian Cardarella](https://twitter.com/bcardarella) explains it.

> Think of images on your website as books. Would you rather carry one book over to the bookshelf or have a bunch of books that require multiple trips to the bookshelf.

When using HTML/CSS you always want to find the lightest and most efficient techniques. This will not only make you a better developer but your visitors will thank you for having a fast website with little load time.

This technique is perfect for social media icons that are used throughout your website. No matter what you can use one .svg file and it will become cached on the users browser.

Organization is vital when using HTML/CSS and this is a great way to categorize your graphics while increasing page speed.

When users are visiting your website for the first time every tenth of a second taken away from a completely loaded webpage counts.
