# this is my favorite way to require ever
begin
  require 'rspec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'rspec'
end

begin
  require 'mocha/api'
rescue LoadError
  require 'rubygems'
  gem 'mocha'
  require 'mocha/api'
end

require 'httparty'

RSpec.configure do |config|
  config.mock_with :mocha
end

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
