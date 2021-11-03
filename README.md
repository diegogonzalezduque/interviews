# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 3.0.2

* System dependencies 
* node, yarn, bundler, bootstrap, sqlite

* Configuration
* bundle install
* rake db:migrate

After cloning the repository you should go to project directory and run the command:
```shell
$ bundle install
```
```shell
$ yarn install
```
Then you need to setup your database:
```shell
$ bundle exec rails db:setup
```
You can start this application by running:
```shell
$ bundle exec rails s
```
you can access de application via http://localhost:3000 while running in local environment

to run the worker for delayed jobs on local you should run:
You can start this application by running:
```shell
$ rake jobs:work
```

* ...
