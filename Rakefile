require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the data_manager plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "linode"
    gemspec.summary = "a Ruby wrapper for the Linode API"
    gemspec.description = "This is a wrapper around Linode's automation facilities."
    gemspec.email = "rick@rickbradley.com"
    gemspec.homepage = "http://github.com/rick/linode"
    gemspec.authors = ["Rick Bradley"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

