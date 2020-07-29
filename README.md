# The Woke Windows Project

This is the code base for the [Woke Windows Project](https://www.wokewindows.org). Pull requests are most definitely welcome!

## Setting Up for Development
I suggest using [rbenv](https://github.com/rbenv/rbenv) to download and run the correct ruby version for the project based on the `.ruby-version` file.

I use [nvm](https://github.com/nvm-sh/nvm) to download and run the correct node.js version for the project based on the `.nvmrc` file.

Install dependencies by running `bundle` and `yarn`

You will need a local [PostgeSQL Server](https://www.postgresql.org/) to run the application.

... TODO: all the other steps

Start the app in the standard rails way: `bundle exec rails s`

## Import Production Database into Dev
Download a production SQL backup (TODO: make these publicly available), and run the script: `./scripts/load_db_backup.sh wokewindows_db_2020-07-29.sql.gz`

## Production Environment
Heroku.

## LICENSE
This project is released under the MIT License.
