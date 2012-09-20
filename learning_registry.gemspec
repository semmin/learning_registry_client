# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "learning_registry/version"

Gem::Specification.new do |s|
  s.name        = "learning_registry"
  s.version     = LearningRegistry::VERSION
  s.authors     = ["@status_200", "@phudgins"]
  s.email       = ["sbagreev@gmail.com", "pete.hudgins@employmentguide.com"]
  s.homepage    = ""
  s.summary     = %q{Learning Registry API client gem}
  s.description = %q{A set of simple models to interact with Learning Registry}

  s.rubyforge_project = "learning_registry"

  s.add_dependency(%q<rake>, ">= 0")
  s.add_dependency(%q<typhoeus>, '~> 0.3.3')
  s.add_dependency(%q<yajl-ruby>, ">= 0")
  s.add_dependency(%q<activemodel>)
  s.add_dependency(%q<nokogiri>)

  s.add_development_dependency('awesome_print')
  s.add_development_dependency('interactive_editor')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
