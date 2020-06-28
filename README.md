# The Woke Windows Project

This is the code base for the [Woke Windows Project](https://www.wokewindows.org) website.

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## REBUILD ALL DATABASES
```
bundle exec rails db:drop && bundle exec rails db:create && bundle exec rails db:migrate && RAILS_ENV=test bundle exec rails db:migrate && bundle exec rails db:seed:replant
```
