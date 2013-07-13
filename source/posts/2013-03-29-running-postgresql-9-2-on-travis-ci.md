---
layout: post
title: "Running PostgreSQL 9.2 on Travis-CI"
comments: true
author: Dan McClain
twitter: "_danmcclain"
github: danmcclain
legacy_category: ruby
social: true
summary: "Test your gem against the latest PostgreSQL version (or an older one)"
published: true
---

I spent most of yesterday trying to get PostgreSQL 9.2 running [Travis-CI](http://travis-ci.org).
After almost 30 attempts, I successfully tested [postgres\_ext](https://github.com/dockyard/postgres_ext) against PostgreSQL 9.2.

Here is the final `before_script` needed to install PostgreSQL 9.2.

```
before_script:
  - sudo /etc/init.d/postgresql stop
  - sudo cp /etc/postgresql/9.1/main/pg_hba.conf ./
  - sudo apt-get remove postgresql postgresql-9.1 -qq --purge
  - source /etc/lsb-release
  - echo "deb http://apt.postgresql.org/pub/repos/apt/ $DISTRIB_CODENAME-pgdg main" > pgdg.list
  - sudo mv pgdg.list /etc/apt/sources.list.d/
  - wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
  - sudo apt-get update
  - sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install postgresql-9.2 postgresql-contrib-9.2 -qq
  - sudo /etc/init.d/postgresql stop
  - sudo cp ./pg_hba.conf /etc/postgresql/9.2/main
  - sudo /etc/init.d/postgresql start
```

## Step by step explanation

### Out with the old
Currently, Travis-CI has PostgreSQL 9.1 installed with a passwordless `postgres` superuser role. We first stop the current user by calling
`sudo /etc/init.d/postgresql stop`. We also want to copy the current `pg_hba.conf`, since we can reuse it with PostgreSQL 9.2 to disable the need
for a password for the `postgres` role. We then remove the currently installed version via `sudo apt-get remove postgresql postgresql-9.1 -qq --purge`.

### Add the apt.postgresql.org repositories

[Postgresql.org](http://postgresql.org) maintains Debian and Ubuntu packages of the current PostgreSQL 8.3, 8.4, 9.0, 9.1 and 9.2 builds at
[apt.postgresql.org](http://apt.postgresql.org) ([more
information](https://wiki.postgresql.org/wiki/Apt)). Since Travis-CI
workers run Ubuntu, we can leverage these packages. We first load the
Ubuntu distribution environment variables via `source /etc/lsb-release`.
Using the `$DISTRIB_CODENAME` variable, we can set up the pgdg.list file
that we will add to the apt-get sources list directory. We do so with
the following command:

```text
echo "deb http://apt.postgresql.org/pub/repos/apt/ $DISTRIB_CODENAME-pgdg main" > pgdg.list
sudo mv pgdg.list /etc/apt/sources.list.d/
```

The last thing we have to do before we can start installing the 9.2 is
to import postgresql.org's apt key via

```text
wget --quiet -O - http://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | sudo apt-key add -
```

### In with the new

After we update our package listing via `sudo apt-get update`, we can
install `postgresql-9.2` and `postgresql-contrib-9.2` (needed for the
PostgreSQL extensions) via:

```text
sudo apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" install postgresql-9.2 postgresql-contrib-9.2 -qq
```

We need the `Dpkg::Options` to automatically resolve any configuration
file conflicts left behind by 9.1 (even though we purge the files, for
some reason the `/etc/init.d/postgresql` file gets left behind). Without
the `Dpkg::Options`, apt-get will raise a user prompt that will hang the
Travis-CI build.

At this point, we have a vanilla install of PostgreSQL 9.2, which will
prompt for a password for the `postgres` role. We then need to stop the
server, replace the 9.2 `pg_hba.conf` with the custom Travis-CI one we
copied earlier, then restart the server:

```text
sudo /etc/init.d/postgresql stop
sudo cp ./pg_hba.conf /etc/postgresql/9.2/main
sudo /etc/init.d/postgresql start
```

At this point, you can use any other `before_script` commands you were
previously using to create your database.

## Conclusion

After a decent amount of trial and error, I arrived at the above
`before_script` to install PostgreSQL 9.2. I am currently adding support
for [ranges](http://www.postgresql.org/docs/9.2/static/rangetypes.html)
to postgres_ext, which was added in 9.2. You should be able use this
`before_script` to add 9.2 to your Travis-CI builds.
