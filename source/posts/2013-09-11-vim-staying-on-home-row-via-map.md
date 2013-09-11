---
layout: post
title: 'Vim: Staying on Home Row via Map'
comments: true
author: 'Doug Yun'
twitter: 'DougYun'
github: duggiefresh
social: true
summary: 'Map commands for quick escapes and saves'
published: false
tags: vim, workflow
---

Here at DockYard, the majority of us are using Vim. I don't want to
write about the benefits of using this sweet editor, as that would take too long,
but instead, I'd like to share a couple of my favorite mappings for
escaping and saving files.

Vanilla Vim: Escaping and Saving
--------------------------------
Escaping out to *Normal* mode from the other modes in Vim is straightforward:
simply hit the `Esc` key.
Saving files is accomplished by, from `Normal` mode, pressing `:w` and then `Enter`.

So... What's the Problem?
--------------------
During a session, especially when I'm writing large pieces of text,
I'd find myself in a repetitive rut:

* I just typed out a couple of sentences and want to save my progress
* I'd remove my left hand from home row to hit the `Esc` key
* Saving the file required me, once again to leave home row, to hit `:w` and then the `Enter` key
* To continue on, I'd press `i` and type along
* Repeat, repeat, repeat...

See where I'm getting at?

Introduction to Map
-------------------
Before we review and
[copy-pasta](http://thumbs.dreamstime.com/z/spaghetti-eating-mess-11376903.jpg)
the portion of my `.vimrc`, let's briefly go over the very basics of the map commands.
You can find the entire [map documentation here](http://vimdoc.sourceforge.net/htmldoc/map.html)
or by typing `:help map` within a Vim session.

Protip: To open help texts into a full buffer, `:h map | only` or to open them in a separate tab `:tab h map`.

### Recursive Map
First, we're going to talk about *recursive* map commands. A *recursive*
command will transform one result to another result, if there is another
binding to that key. An example can be found at the `.vimrc` below.

Here are the basic *recursive* map commands.

* `map`  - command to transform the operation of typed keys within *ALL* modes

You can prepend the first letter of the desired mode to `map`.

* `nmap` - transform the operation of typed keys within *Normal*
  mode
* `imap` - transform the operations of typed keys within
  *Insert* mode
* `vmap` - transform the operations of typed keys within
  *Visual* mode

For example, if I had this within my `.vimrc`:

```
" ~/.vimrc
"
" Note: double quotes signifies comments

nmap gg G
imap n N

" Time for a little recursive map
imap d D
imap D wat
```
Since `gg` is mapped to `G` within *Normal* mode, I'll be sent to the
bottom of the file if I type `gg`, instead of to the top.
Moreover, while in *Insert* mode, every character `n` that I type will turn into `N`.
Lastly, because of the recursive map, typing `d` in *Insert* mode will return `D` which in turn will
transform to `wat`.

Thankfully, there's a *non-recursive* map.

### Non-recursive Map

Enter the .vimrc
------
