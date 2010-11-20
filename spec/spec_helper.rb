# this is my favorite way to require ever
begin
  require 'spec'
rescue LoadError
  require 'rubygems'
  gem 'rspec'
  require 'rspec'
end

begin
  require 'mocha'
rescue LoadError
  require 'rubygems'
  gem 'mocha'
  require 'mocha'
end

Spec::Runner.configure do |config|
  config.mock_with :mocha
end

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
