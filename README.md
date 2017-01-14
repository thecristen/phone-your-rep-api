# Phone Your Rep API

WIP.
The companion to [the Phone Your Rep frontend](https://github.com/Flaque/phone-your-rep/tree/gh-pages).

# Installation

Be sure to use Ruby 2.3.3.

```
rbenv install 2.3.3 or rvm install 2.3.3
brew install postgres
brew install postgis
```

Or download the Heroku PostgreSQL app and forego the brew postgres and postgis install

```
gem install rails --no-ri --no-rdoc
gem install bundler
bundle install
bundle exec rake db:create
bundle exec rake:gis:setup
bundle exec rake db:migrate
ruby lib/shapefiles.rb

rails s
```

This is deployed on Heroku. Some useful commands.

```
heroku run rake db:migrate
heroku run rake db:seed
```
