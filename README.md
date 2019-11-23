# Currency Exchange Application

In order to have this application running locally you will need to to the following :

* bundle install

* yarn install

Then

* rails server

`Locally, it needs a proper open exchange app_id, value which can either be set as a rails credential :open_exchange_app_id or simply adjust oxr.rb initializer.`

Caching is being made using redis, that needs to be installed locally as well.

The app is also available on https://currency-exchange-oex.herokuapp.com/ , try it out.

Unit tests can be executed using `rails test` while the linters for rubocop, stylelint and eslint can be executed using `bin/lint`
