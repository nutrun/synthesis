require "rubygems"
require "rake/testtask"
require 'rake/rdoctask'
require 'rake/contrib/sshpublisher'
require File.dirname(__FILE__) + "/lib/synthesis/task"

load 'synthesis.gemspec'

task :default => [:test, "test_project:all"]

desc "Run all tests"
task :test => %w[test:core test:mocha test:spec]

desc "Run core tests"
Rake::TestTask.new('test:core') do |t|
  t.pattern = '{test/synthesis/,test/synthesis/formatter/}*_test.rb'
end

desc "Run Mocha adapter tests"
Rake::TestTask.new('test:mocha') do |t|
  t.pattern = 'test/synthesis/adapter/mocha/*_test.rb'
end

desc "Run RSpec adapter tests"
Rake::TestTask.new('test:spec') do |t|
  t.pattern = 'test/synthesis/adapter/rspec/*_test.rb'
end

# Synthesis test_project tasks

Synthesis::Task.new do |t|
  t.pattern = 'test_project/mocha/test/*_test.rb'
  t.ignored = [Array, Hash]
  # t.out = File.new('synthesis.test.txt', 'a')
end

Synthesis::Task.new('synthesis:test:graph') do |t|
  t.pattern = 'test_project/mocha/test/*_test.rb'
  t.formatter = :dot
end

Synthesis::Task.new('synthesis:spec') do |t|
  t.adapter = :rspec
  t.pattern = 'test_project/rspec/*_spec.rb'
end

Synthesis::Task.new('synthesis:spec:graph') do |t|
  t.adapter = :rspec
  t.pattern = 'test_project/rspec/*_spec.rb'
  t.formatter = :dot
end

namespace :test_project do
  task :all do
    STDOUT.puts `rake test_project:mocha`
    STDOUT.puts `rake test_project:rspec`
  end
  
  Rake::TestTask.new('mocha') do |t|
    t.pattern = 'test_project/mocha/**/*_test.rb'
  end
  
  Rake::TestTask.new('rspec') do |t|
    t.pattern = 'test_project/mocha/**/*_test.rb'
  end
end

desc 'Generate RDoc'
Rake::RDocTask.new do |task|
  task.main = 'README.rdoc'
  task.title = 'synthesis'
  task.rdoc_dir = 'doc'
  task.options << "--line-numbers" << "--inline-source"
  task.rdoc_files.include('README.rdoc', 'lib/**/*.rb')
end

desc "Upload RDoc to RubyForge"
task :publish_rdoc do
  Rake::Task[:rdoc].invoke
  Rake::SshDirPublisher.new("gmalamid@rubyforge.org", "/var/www/gforge-projects/synthesis", "doc").upload
end

task(:lf) {p Dir["lib/**/*rb"]}

task(:check_gemspec) do
  require 'rubygems/specification'
  data = File.read('synthesis.gemspec')
  spec = nil
  Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
  puts spec
end