---
layout: post
title: 'Introducing easydir.vim'
comments: true
author: 'Doug Yun'
twitter: 'dougyun'
github: duggiefresh
social: true
summary: 'A Vim plugin that allows you create directories and files at the same time!'
published: true
tags: vim, workflow
---

One of the things that I wish Vim had by default is the ability to create
directories and files at the same time. Last month at our local
[OpenHack meetup](http://openhack.github.io/), I had a conversation about
it with a fellow developer and we both concluded that it wouldn't be too
difficult to write something up.

Well, I'm happy to introduce [easydir.vim](https://github.com/dockyard/vim-easydir)!

It adds to the functionality of `:new`, `:edit`, `:write`, and more.

Here are some quick examples:

* Edit a new file inside of a previously nonexistent directory.

```
:e new_directory/new_file.txt

# Write some things to "new_file.txt" and save it.

:w

# The directory "new_directory/" and the file "new_file.txt"
# are saved!
```

* Open the new directory and file into a split window.

```
:sp another_directory/another_file.txt

# Write to "another_file.txt" and save the file.

:w

# another_directory/another_file.txt is saved!
```

* Super nested directories

```
:n thank/you/sir/may/i/have/another.txt

# Write some things to "another.txt" and save it.

:w
```

The directories and files will be saved under your current project's directory.

Thanks for checking it out and enjoy!
