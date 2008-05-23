require "rubygems"
require "rake/testtask"
require "rake/gempackagetask"
require 'rake/rdoctask'
require 'rake/contrib/sshpublisher'
require File.dirname(__FILE__) + "/lib/synthesis/task"

task :default => :test

desc "Run all tests"
task :test => %w[test:core test:mocha test:spec]

desc "Run core tests"
Rake::TestTask.new('test:core') do |t|
  t.pattern = 'test/synthesis/*_test.rb'
end

desc "Run Mocha adapter tests"
Rake::TestTask.new('test:mocha') do |t|
  t.pattern = 'test/synthesis/adapter/mocha/*_test.rb'
end

desc "Run RSpec adapter tests"
Rake::TestTask.new('test:spec') do |t|
  t.pattern = 'test/synthesis/adapter/rspec/*_test.rb'
end

Synthesis::Task.new('synthesis:test:expectations') do |t|
  t.adapter = :expectations
  t.pattern = 'test_project/expectations/test/*_test.rb'
end

Synthesis::Task.new('synthesis:test:rspec') do |t|
  t.adapter = :rspec
  t.pattern = 'test_project/rspec/*_spec.rb'
end

Synthesis::Task.new do |t|
  t.pattern = 'test_project/mocha/test/*_test.rb'
  t.ignored = %w[Array Hash]
  # t.out = File.new('synthesis.test.txt', 'a')
end

desc 'Generate RDoc'
Rake::RDocTask.new do |task|
  task.main = 'README'
  task.title = 'synthesis'
  task.rdoc_dir = 'doc'
  task.options << "--line-numbers" << "--inline-source"
  task.rdoc_files.include('README', 'lib/**/*.rb')
end

desc "Upload RDoc to RubyForge"
task :publish_rdoc do
  Rake::Task[:rdoc].invoke
  Rake::SshDirPublisher.new("gmalamid@rubyforge.org", "/var/www/gforge-projects/synthesis", "doc").upload
end

gem_spec = Gem::Specification.new do |s|
  s.name = 'synthesis'
  s.version = '0.0.15'
  s.platform = Gem::Platform::RUBY
  s.rubyforge_project = "synthesis"
  s.summary, s.description = 'A tool for Synthesized Testing'
  s.authors = 'Stuart Caborn, George Malamidis'
  s.email = 'george@nutrun.com'
  s.homepage = 'http://synthesis.rubyforge.org'
  s.has_rdoc = true
  s.rdoc_options += ['--quiet', '--title', 'Synthesis', '--main', 'README', '--inline-source']
  s.extra_rdoc_files = ['README', 'COPYING']
  excluded = FileList['etc/*']
  # s.test_files = FileList['test/**/*_test.rb']
  s.files = FileList['**/*.rb', 'COPYING', 'README', 'Rakefile'] - excluded
end

Rake::GemPackageTask.new(gem_spec) do |t|
  t.need_zip = false
  t.need_tar = false
end

desc "Remove rdoc and package artefacts"
task :clean => %w[clobber_package clobber_rdoc]