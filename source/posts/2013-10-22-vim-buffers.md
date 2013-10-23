---
layout: post
title: 'Buffers, Windows, Tabs... Oh My! Part 1: Vim Buffers'
comments: true
author: 'Doug Yun'
twitter: 'DougYun'
github: duggiefresh
social: true
summary: "A painless tutorial on Vim buffers"
published: false
tags: vim, workflow
---
First off, [GO SOX](http://boston.redsox.mlb.com)!!!11

Now that I've reinforced my allegiance to America's favorite baseball team, let's
talk about Vim. In these series of posts, we'll explore buffers,
windows, and tabs.

Today, our topic will be *buffers*, editable files that are
available in-memory.

When you first open a file through a Vim session, you are creating and working
in a buffer, typically through a window. For the sake of today's discussion,
we will consider working with multiple buffers through only one window, our
viewport of the working buffer.

### Let's open a buffer

We're going to setup an easy exercise for today's post. If you don't want to
follow along, feel free to try the exercise in your own project.

Let's create a dummy directory and a some of text files:

```
mkdir dummy && cd dummy
echo 'The Red Sox rule!' > redsox.txt && echo 'Cardinals drool!' > cardinals.txt
```

Next, open up the `redsox.txt` file.

```
vim redsox.txt      # => The Red Sox rule!
```

Congratulations, you're viewing the `redsox.txt` file through a buffer!

### Hidden Buffers

Let's open the `cardinals.txt` file in a *hidden* buffer. We can accomplish
this through the current `redsox.txt` buffer by using `:badd`. Next, we'll
list out all buffers, hidden or active, with `:ls`.

```
# Inside the current buffer, get into Vim's command mode and use the command `:badd`.
# List all buffers with `:ls`.

:badd candinals.txt     # 'badd' => 'Buffer ADD'
                        # You can also use `:bad`
:ls
# # =>   1  %a   "redsox.txt"              line 1
         2       "cardinals.txt"           line 1
```

The `:ls` command returns information about each buffer: the unique buffer
number, buffer indicators, file name, and the line number of your current
position within the file.

* Buffer number: A unique number to identify individual buffers.
* Buffer indicators:
  * %: buffer in the current window
  * #: alternate buffer, which can be quickly accessed with `CTRL-6`
  * a: active buffer, loaded and visible
  * h: hidden buffer, loaded but not visible
