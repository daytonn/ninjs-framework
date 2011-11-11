require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "ninjs-framework"
  gem.homepage = "http://github.com/daytonn/ninjs-framework"
  gem.license = "MIT"
  gem.summary = %Q{ninjs-framework is a small JavaScript framework for building modular javascript applications}
  gem.description = %Q{ninjs-framework is the JavaScript framework component of the ninjs development framework. ninjs-framework is focus on helping you build extensible modular javascript applications, without using a classical inheritance pattern.}
  gem.email = "daytonn@gmail.com"
  gem.authors = ["Dayton Nolan"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'jasmine'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency "rspec", "~> 2.3.0"
  gem.add_development_dependency "bundler", "~> 1.0.0"
  gem.add_development_dependency "jeweler", "~> 1.5.2"
  gem.add_development_dependency "rcov", ">= 0"
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ninjs-ninjs-framework #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end

task :travis do
  ["rake jasmine:ci"].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    raise "#{cmd} failed!" unless $?.exitstatus == 0
  end
end

task :default => 'travis'