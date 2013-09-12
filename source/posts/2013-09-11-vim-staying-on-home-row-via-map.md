---
layout: post
title: 'Vim: Staying on Home Row via Map'
comments: true
author: 'Doug Yun'
twitter: 'DougYun'
github: duggiefresh
social: true
summary: 'Map commands for quick escapes and saves'
published: true
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
* Saving the file required me, once again to leave home row, to hit `:w`
  and then the `Enter` or the `Return` key
* To continue on, I'd press `i` and type along
* Repeat, repeat, repeat...

See where I'm getting at?

Let's Talk About Map
-------------------
Before we review and
[copy-pasta](http://www.flickr.com/search/?q=pasta)
the portion of my `.vimrc`, let's briefly go over the very basics of the
pertinent map commands.
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
  *Visual* and *Select* mode

For example, if I had this within my `.vimrc`:

```
" ~/.vimrc
"
" Note: double quotes signifies comments

nmap 0 gg
imap n N

" Time for a little recursive map
imap d D
imap D wat
```
Since `0` is mapped to `gg` within *Normal* mode, I'll be sent to the
top of the file by pressing `0`.
Moreover, while in *Insert* mode, every character `n` that I type will turn into `N`.
Lastly, because of the recursive mapping, typing `d` in *Insert* mode
will return `wat`. You can think of it as something like: `d` => `D` =>
`wat`.

Thankfully, there's a *non-recursive* map.

### Non-recursive Map
*Non-recursive* map commands are signified by adding `nore` after the
 mode modifier.

* `nnoremap` - non-recursive map for *Normal* mode
* `inoremap` - non-recursive map for *Insert* mode
* `vnoremap` - non-recursive map for *Visual* and *Select* mode

```
" ~/.vimrc

inoremap c C
inoremap C nope
```
Now, in *Insert* mode, if we type `c`, we will return `C`; the transformation of
`c` to `nope` will not occur.

Enter the .vimrc
----------------
Now that we got the basics out of the way, here is an example of my
`.vimrc`.

```
" ~/.vimrc
" *** The Two Hand system ***
"
" <Cr> signifies the "return" key

inoremap ;a <Esc>
inoremap ;d <Esc>:update<Cr>
inoremap ;f <C-O>:update<Cr>
nnoremap ;f :update<CR>
```
I'm using `:update` here, which is "like `:write`, but only write when the buffer has been
modified."

Let's go over these mappings.

The first one, `inoremap ;a <Esc>` maps the *semi-colon* and *a* key
together when in *Insert* mode. By pressing `;` and then `a` immediately afterwards, we mimic
the functionality of the *Escape* key.

The second map, `inoremap ;d <Esc>:update<Cr>` maps the *semi-colon* and the *d* key.
Pressing `;` and then `d` immediately afterwards returns the sequence of:

* From *Insert* mode, escape to *Normal* mode
* Type `:` to get inside the *Command* mode, and type the `update`
  command
* Complete the sequence by "hitting" *Return*, thus saving the file

The third map command, `inoremap ;f <C-O>:update<Cr>`, allows us to
type `;` and then `f` to return:

* From *Insert* mode, escape out to *Normal* with `<C-O>`, which allows
  us to escape out for *ONE* command.
* Type `:` to get inside *Command* mode, and then type `udpate`. This is
  our one command for `<C-O>`
* "Hit" the *Return*, thus saving the file
* We're back in *Insert* mode, thanks to `<C-O>`

Finally, the `nnoremap ;f :update<CR>` mapping means by typing `;` and
then `f` in *Normal* mode, it will result in:

* Since, we're already in *Normal* mode, we get into *Command* mode by
  typing `:`
* Type the `update` command
* "Hit" the *Return* key, and save the file
* We remain in *Normal* mode

The snippet below restricts these commands to your right hand.

```
" ~/.vimrc
" *** The Right Hand system ***

inoremap ;l <Esc>
inoremap ;k <Esc>:update<Cr>
inoremap ;j <C-O>:update<Cr>
nnoremap ;j :update<CR>
```

As you can see, I kept `;` as a prefix to my map commands. This
conveniently keeps me at homerow. I've played with mapping everything
with my right hand, but it just didn't feel "right" (apologies for the
bad pun).

Overall, this snippet makes me happy and I believe this will make your
day as well. If there are some other tricks
concerning escaping and saving files, please let me know in the
comments! Thanks!
