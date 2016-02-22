# Teaspoon includes some support files, but you can use anything from your own support path too.
# require support/jasmine-jquery-1.7.0
# require support/jasmine-jquery-2.0.0
# require support/jasmine-jquery-2.1.0
# require support/sinon
# require support/your-support-file
#
# PhantomJS (Teaspoons default driver) doesn't have support for Function.prototype.bind, which has caused confusion.
# Use this polyfill to avoid the confusion.
#= require support/phantomjs-shims
#
#= require player
#= require game
#= require game_state
