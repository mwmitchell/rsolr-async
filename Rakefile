require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rsolr-async"
    gem.summary = %Q{An EventMachine based connection adapter for RSolr}
    gem.description = %Q{Provides asynchronous connections to Solr}
    gem.email = "goodieboy@gmail.com"
    gem.homepage = "http://github.com/mwmitchell/rsolr-async"
    gem.authors = ["Matt Mitchell", "Mike Perham"]
    gem.add_development_dependency "rspec", ">= 2.3"
    gem.add_dependency "rsolr", ">= 1.0.7"
    gem.add_dependency "eventmachine", ">= 1.0.0.beta.4"
    gem.add_dependency "em-http-request", ">= 1.0.1"
    gem.add_dependency "webmock", ">= 1.8.0"
    
    gem.files = FileList['lib/**/*.rb', 'examples/**', 'LICENSE', 'README.rdoc', 'VERSION']
    gem.test_files = ['spec/*', 'Rakefile', 'solr/example/**/*']
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  # Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => [:spec]

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rsolr-async #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end