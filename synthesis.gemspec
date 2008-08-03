require 'rubygems'

GEMSPEC =Gem::Specification.new do |s|
  s.name = 'synthesis'
  s.version = '0.1.6'
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