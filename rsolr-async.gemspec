# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rsolr-async}
  s.version = "0.2.0"
  s.authors = ["Matt Mitchell", "Mike Perham"]
  s.summary = %q{An EventMachine based connection adapter for RSolr}
  s.description = %q{Provides asynchronous connections to Solr}
  s.email = %q{goodieboy@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    "LICENSE",
    "README.rdoc",
    "VERSION",
    "examples/bulk_indexer.rb",
    "lib/rsolr-async.rb"
  ]
  s.homepage = %q{http://github.com/mwmitchell/rsolr-async}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.test_files = [
    "spec/rsolr-async_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "Rakefile"
  ]

  s.add_development_dependency(%q<rspec>, [">= 2.3"])
  s.add_development_dependency(%q<webmock>, [">= 1.8.0"])
  s.add_runtime_dependency(%q<rsolr>, [">= 1.0.7"])
  s.add_runtime_dependency(%q<eventmachine>, [">= 1.0.0.beta.1"])
  s.add_runtime_dependency(%q<em-http-request>, [">= 1.0.1"])
end

