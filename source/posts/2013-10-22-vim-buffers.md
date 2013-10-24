---
layout: post
title: 'Buffers, Windows, Tabs... Oh My! Part 1: Vim Buffers'
comments: true
author: 'Doug Yun'
twitter: 'DougYun'
github: duggiefresh
social: true
summary: "A painless tutorial on Vim buffers"
published: true
tags: vim, workflow
---
First off, [GO SOX](http://boston.redsox.mlb.com)!!!11

Now that I've reinforced my allegiance to America's favorite baseball team, let's
talk about Vim. In this series of posts, we'll explore buffers,
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

Let's create a dummy directory and some of text files:

```
mkdir dummy && cd dummy
echo 'The Red Sox rule!' > redsox.txt && echo 'Cardinals drool!' > cardinals.txt
```

Next, open up the `redsox.txt` file.

```
vim redsox.txt      # => The Red Sox rule!
```

Congratulations, you're already using buffers!

### Buffer indicators

Let's open the `cardinals.txt` file in a *hidden* buffer. We can accomplish
this through the current `redsox.txt` buffer by using `:badd` or `:bad`. Next, we'll
list out all buffers, hidden or active, with `:ls`.

```
# Inside the current buffer, get into Vim's command mode and use the command `:badd`.
# List all buffers with `:ls`.

:badd candinals.txt     # 'badd' => 'Buffer ADD'
                        # You can also use `:bad`
:ls
  ### =>   1    %a   "redsox.txt"              line 1
           2         "cardinals.txt"           line 1
```

The `:ls` command returns information about each buffer: the unique buffer
number, buffer indicators, file name, and the line number of your current
position within the file.

* Buffer number: A unique number to identify individual buffers.
* Buffer indicators:
  * `%`: buffer in the current window
  * `#`: alternate buffer, which can be accessed by `CTRL-6`
  * `a`: active buffer, loaded and visible
  * `h`: hidden buffer, loaded but not visible
  * `-`: a buffer that cannot be modified, `modifiable` off
  * `=`: a buffer that is readonly
  * `+`: a buffer that has been successfully modified
  * `x`: a buffer with read errors
  * ` `: if there is no buffer indicator, it signifies a buffer that has not been
  loaded yet
* Buffer name: The name of the file.
* Buffer line number: The current line number that the cursor is on.

### Working with multiple buffers

As we can see, our `cardinals.txt` has yet to be loaded. Let's open it into
our window and view our current buffers.

```
:e cardinals.txt   # => Cardinals drool!

:ls
  ### =>   1    #    "redsox.txt"              line 1
           2    %a   "cardinals.txt"           line 1
```

Nice! We can see that our `redsox.txt` file is our alternate buffer. Let's switch
to the `redsox.txt` by hitting `CTRL-6`.

Now we'll create a new text file, `worldseries.txt`, write `World Series!` inside that file,
and check out our list of buffers.

```
:e worldseries.txt   # Write "World Series!" inside the file and save it.
:ls
  ### =>   1    #    "redsox.txt"              line 1
           2         "cardinals.txt"           line 1
           3    %a   "worldseries.txt"         line 1
```

Our alternate buffer is the `redsox.txt` file. Remember, if we want to quickly
switch to the alternate buffer, we can use `CTRL-6`. What if we want to open the
`cardinals.txt` into our current window?

Well, we have a couple of options. From the `worldseries.txt` file, we can use the
following vim commands:

* `:bp` :  Switch to the previous buffer
* `:b2` :  Switch to buffer number 2
  * `:b` : Takes a buffer number as an argument

Go ahead and give it a try.

Here are some other pertinent buffer commands:

* `:bn` : Switch to the next buffer
* `:ball` : Open all buffers into windows
* `:brew` : Go back to the first buffer in the list - "Buffer REWind"
* `:bd` : Delete the buffer - also takes buffer numbers as arguments
  * `:bd 1 2 3` : Will remove buffer numbers 1, 2, and 3
  * *Note*: `:q` is not the same as `:bd`... try it and verify with `:ls`!

### So what good are buffers?

To be honest, I just realized the power of buffers about a month ago.
Previously, thanks to a large monitor, I would have multtple windows
- as many as 6-8 - open during one Vim session.
Multiple windows are great, however, if I really needed to focus on a few
files, I'd have to close each insignificant file window.

Nowadays, my workflow comprises of two or three windows, with multiple buffers in the background.
This has allowed me to rapidly move between files that I actively open and edit.

### Remapping buffer commands

Here are some key remappings that speed up buffer movement:

```
" ~/.vimrc (or wherever else you keep your .vimrc)

" Move to the previous buffer with "gp"
nnoremap gp :bp<CR>

" Move to the next buffer with "gn"
nnoremap gn :bn<CR>

" List all possible buffers with "gl"
nnoremap gl :ls<CR>

" List all possible buffers with "gb" and accept a new buffer argument [1]
nnoremap gb :ls<CR>:b
```

*Note*: Remapping `gp` will remove the Vim default functionality of `gp`.
Use `:h gp` to read more about it.


Hope that provides some insight into the capabilities of Vim buffers!
If there is anything you'd like to add, please feel free and
comment in the discussion area. Thanks!

* [1] Special thanks to [romainl](http://www.reddit.com/r/vim/comments/1p2a62/a_painless_tutorial_on_vim_buffers/ccxzq7e).
