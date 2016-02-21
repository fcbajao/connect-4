# Connect4

Basic implementation of the game [Connect Four](https://en.wikipedia.org/wiki/Connect_Four).

## Setting Up

Clone and install dependencies.

```
$ git clone https://github.com/fcbajao/connect-4.git
$ cd connect-4/
$ bundle install
$ npm install
```

Start your local server.

```
$ bundle exec rails s
```

## Running Tests

Run Cucumber and RSpec tests.

```
$ bundle exec rake spec cucumber
```

Run Jasmine tests through teaspoon.

```
$ bundle exec teaspoon
```

## Deploying to Heroku

Since the project uses Browserify, we'll have to add custom
buildpacks that run `bundle` and `npm install` on the target machine

```
$ heroku buildpacks:add https://github.com/heroku/heroku-buildpack-nodejs.git
$ heroku buildpacks:add https://github.com/heroku/heroku-buildpack-ruby.git
```

## Browser Support

Tested on the latest version of Firefox and Chrome.
