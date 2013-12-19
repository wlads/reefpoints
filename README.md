# DockYard's ReefPoints Blog #

## Getting Setup ##

```bash
$ bundle install
```

## Getting Up & Running ##

```bash
$ bundle exec middleman

# or run the Rake task

$ rake preview
```

## Want to make your own post? ##

* Pull down the latest

```bash
$ git pull origin master
```

* Make a new branch

```bash
$ git checkout -b YOURNAME-your-topic-name
```

* Done writing? Now you can submit your PR...

```bash
$ git push origin YOURNAME-your-topic-name
```

* Now, submit your PR via GitHub. Done getting feedback? Merge your branch into `master`.

* Now publish your post to Reefpoints!

```bash
$ git checkout master
$ git pull origin master
$ rake publish
```

## Legal ##

[DockYard](http://dockyard.com), LLC &copy; 2013

[@dockyard](http://twitter.com/dockyard)

[Licensed under the MIT license](http://www.opensource.org/licenses/mit-license.php)
