# vagrant-webdev

Web development (LAMP, nodejs, grunt jekyll etc.) vagrant VM using "precise64" as base


## Basic configurations

Components and basic configurations can be configured on top of `run.sh` file

## Installing LAMP:

`http://localhost:8080`

### MySQL:

USER: root

PASS: vagrant

### Apache:

Document root: /var/www/ (which is system link of `/vagrant/www`)

user/group: vagrant/vagrant

### phpMyAdmin:

USER: root

PASS: vagrant


## Also installing:

git 1.8

composer

mongodb

node.js

yo

grunt-cli

bower

gulp

ruby 1.9.1

compass

sass

bundler

github-pages (with Jekyll)

## .dotfiles

Copied from `conf/bash/*`

============================================

 Git repo's are cloned from `conf/git/git.sh` and moved to `/var/www/` (which is system link of `/vagrant/www`)
