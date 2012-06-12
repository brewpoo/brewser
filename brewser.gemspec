# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'brewser/version'

Gem::Specification.new do |s|
  s.name        = "brewser"
  s.version     = Brewser::VERSION.dup
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jon Lochner"]
  s.email       = ["jlochner@gmail.com"]
  s.homepage    = "https://github.com/brewpoo/brewser"
  s.summary     = %{Library for parsing and generating serialized brewing data}

  s.files         = Dir["MIT-LICENSE", "README.md", "lib/**/*"]
  s.test_files    = Dir["spec/**/*"]
  s.require_paths = ["lib"]

  s.add_dependency 'activesupport',        '>= 2.3.14'
  s.add_dependency 'multi_json',           '~> 1.0'
  s.add_dependency "ruby-units"
  s.add_dependency "nokogiri"
  s.add_dependency "roxml"
  s.add_dependency "bindata"
  s.add_dependency "builder"
  s.add_dependency "dm-core", "~> 1.2.0"
  s.add_dependency "dm-validations", "~> 1.2.0"
  
  s.rubyforge_project = s.name  
end
