# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "brewser"
  s.version     = Brewser::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jon Lochner"]
  s.email       = ["jlochner@gmail.com"]
  s.homepage    = "https://github.com/brewpoo/brewser"
  s.summary     = %{Library for parsing and generating serialized brewing data}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "ruby-units"
  s.add_dependency "nokogiri"#, "~> 1.4.4"
  s.add_dependency "dm-core", "~> 1.1.0"
  s.add_dependency "dm-validations", "~> 1.1.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 2.5"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "yard"
end
