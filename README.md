[![Ceasefire Now](https://badge.techforpalestine.org/default)](https://techforpalestine.org/learn-more)

# StateReference Window

![Rails Tests](https://github.com/nstory/wokewindows/workflows/Rails%20Tests/badge.svg)

This is the code base for the [StateReference Window](https://window.statereference.com/) (formerly known as "Woke Windows").

This is a [Ruby on Rails](https://rubyonrails.org/) project. For general information regarding Ruby on Rails development, I highly suggest the official [Ruby on Rails Guides](https://guides.rubyonrails.org/).

## Setting Up for Development
I suggest using [rbenv](https://github.com/rbenv/rbenv) to download and run the correct ruby version for the project based on the `.ruby-version` file.

I use [nvm](https://github.com/nvm-sh/nvm) to download and run the correct node.js version for the project based on the `.nvmrc` file.

You will need a local [PostgreSQL Server](https://www.postgresql.org/) to run the application.

Follow these steps to install interpreters, dependencies, etc.

```
cd wokewindows
rbenv install -s    # install ruby version in .ruby-version if not already installed
gem install bundler # gems are managed with bundle
bundle              # install gems for project
nvm use             # use nodejs version specified in .nvmrc
npm install -g yarn # install yarn using npm (lol)
yarn                # install JS libs
```

We use docker-compose to run the database for the app. Type `docker compose up` to start
the database. You will need to set the variables POSTGRES_PASSWORD and POSTGRES_PORT
in the `.env` file in the project directory.

See "Import Production Database into Dev" section below to create the database table.

Start the app in the standard rails way: `bundle exec rails s`

## Import Production Database into Dev
Download the "dev" backup of the production database (contains all production data except the users table):
https://wokewindows-data.s3.amazonaws.com/wokewindows_db.sql.gz

Import the data using the load_db_backup.sh script:
`./scripts/load_db_backup.sh wokewindows_db.sql.gz`

## Test Suite
Running the test suite should be as simple as: `bundle exec rspec`

You will need to have a test database `cops_test` in your local PostgreSQL database (the load_db_backup.sh scripts will create this when it runs `rails db:reset`).

The system tests use Chrome in headless mode; they should automatically find any Chrome install on your system.

## Deploy to Production
```
./kamal.sh setup
```

## LICENSE
This project is released under the MIT License.
