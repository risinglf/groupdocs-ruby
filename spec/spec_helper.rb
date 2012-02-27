# encoding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'simplecov'
SimpleCov.configure do
  add_filter('spec/')
  add_filter('vendor/')
end
SimpleCov.start

require 'groupdocs'
