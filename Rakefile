require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'spec/rake/spectask'

desc 'Default: run specs.'
task :default => :spec

desc 'Test the linode library.'
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
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
  end
  Jeweler::GemcutterTasks.new  
rescue LoadError
end

