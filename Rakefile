require 'rubygems'
require 'rake'
require 'rake/testtask'

begin
  require 'rdoc/task'
rescue LoadError
  require 'rake/rdoctask'
end
require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

desc 'Test the linode library.'
RSpec::Core::RakeTask.new('spec') do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

desc 'Test the linode library.'
task :test => :spec

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "linode"
    gemspec.summary = "a Ruby wrapper for the Linode API"
    gemspec.description = "This is a wrapper around Linode's automation facilities."
    gemspec.email = "rick@rickbradley.com"
    gemspec.homepage = "http://github.com/rick/linode"
    gemspec.authors = ["Rick Bradley"]
    gemspec.add_dependency('httparty', '>= 0.4.4')
    gemspec.add_dependency('crack', '>= 0.3.1')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
end

