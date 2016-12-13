# Phone Your Rep API

WIP.
The companion to [the Phone Your Rep frontend](https://github.com/Flaque/phone-your-rep/tree/gh-pages).

# Installation details

#### For this development branch to work on your local machine, you will need to clone the latest development branch (v-2-0-0) of the [get-your-rep gem](https://github.com/msimonborg/get-your-rep/tree/v-2-0-0) and follow the development installation instructions. Then edit your Gemfile:
```
# Use GetYourRep to get rep info for address from Google API
gem 'get-your-rep', '~> 2.0', path: '~/<YOUR_PATH_TO_THE_GEM_DIRECTORY>/'
```
#### Then continue with normal installation
```
rvm use 2.3.3
gem install rails --no-ri --no-rdoc
gem install bundler
bundle install
```

This is deployed on Heroku. Some useful commands.

```
heroku run rake db:migrate
heroku run rake db:seed
```
