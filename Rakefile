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
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_dependency "rsolr", ">= 0.12.1"
    gem.add_dependency "eventmachine", ">= 0.12.10"
    gem.add_dependency "em-http-request", ">= 0.2.6"
    
    gem.files = FileList['lib/**/*.rb', 'LICENSE', 'README.rdoc', 'VERSION']
    gem.test_files = ['spec/*', 'Rakefile', 'solr/example/**/*']
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  # Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rsolr-async #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end