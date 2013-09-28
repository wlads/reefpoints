---
layout: post
title: "Vim: Moving Lines Ain't Hard"
comments: true
author: 'Doug Yun'
twitter: 'DougYun'
github: duggiefresh
social: true
summary: 'Quick ways to move lines'
published: true
tags: vim, workflow
---
In the last post, we briefly discussed the power of the
[*map* command](http://reefpoints.dockyard.com/2013/09/11/vim-staying-on-home-row-via-map.html).
In today's post, we're going to use *map* again in order to move
lines and blocks around.

Let's use an example:
Our goal is to move the *first line* to its proper location. From this:

```
--- second line ---
--- third line ---
--- first line ---
```

To this:

```
--- first line ---
--- second line ---
--- third line ---
```

Delete, Then Paste
------------------

Here is one of the most common ways, it ain't pretty but it gets the job done.
We'll delete the desired line and paste it to the target location.

```
--- second line ---
--- third line ---
--- first line ---

# Delete the "first line", move to the "second line", and paste the registered
# "first line" above the "second line".
#
# :3 --> <ENTER> --> dd --> j --> P
#
# or...
#
# :3d --> <ENTER> --> :2P --> <ENTER>
```

I Like the Way You Move
--------

The second way, use the *move* command with `:m`. I like this method a lot, as it
requires fewer keystrokes. It does require line numbers though. When using
absolute line numbers, the destination will be below the line number you specify,
so use `:m0` to move to the top of the file.
Try using
[hybrid mode](http://jeffkreeftmeijer.com/2013/vims-new-hybrid-line-number-mode/).

```
--- second line ---
--- third line ---
--- first line ---

# Move your cursor on the "first line" (the third line), use the *move* command and
# pass your desired line number as an argument. Hit enter.
#
# :3 --> <ENTER> --> :m0 --> <ENTER>
#
# or...
#
# :3m0 --> <ENTER>
```

Lazy Moving
-----------

Now getting to the *map* command, I've found this pretty handy when
I need to move a line or block of lines a couple of lines upward or downward.

```
" In your ~/.vimrc
"
" Normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==

" Insert mode
inoremap <C-j> <ESC>:m .+1<CR>==gi
inoremap <C-k> <ESC>:m .-2<CR>==gi

" Visual mode
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv
```

Now you can move lines by holding *CTRL* and *j* (for up a line) or
*k* (for down a line).

```
--- second line ---
--- third line ---
--- first line ---

# Move to the "first line", hold <CTRL> and move up twice.
#
# :3 --> <ENTER> --> <CTRL> + jj
```

Now let's move a block of lines:

```
--- fourth line ---
--- fifth line ---
--- first line ---
--- second line ---
--- third line ---

# Move to the "first line".
# Select the "first line", "second line", and the "third line" with Visual mode.
# Hit CTRL and move upwards twice.
#
# :3 -- <ENTER> --> <SHIFT> + V --> jj --> <CTRL> + kk
```

Other Ways
----------

There are plenty of other tricks that move around lines in Vim. The preceding
examples were just a few that I employ everyday. If you've got something cool to
share, please let me know!
