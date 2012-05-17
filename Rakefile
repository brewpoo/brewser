#!/usr/bin/env rake
require "bundler/gem_tasks"

task :default => 'spec'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = "-c -f d"
end
RSpec::Core::RakeTask.new(:rcov) do |t|
  t.rspec_opts = "-c -f d"
  t.rcov = true
  t.rcov_opts = ["--exclude", "spec,gems/,rubygems/"]
end

require 'yard'
YARD::Rake::YardocTask.new(:doc) do |t|
  version = Brewser::VERSION
  t.options = ["--title", "brewser #{version}", "--files", "LICENSE"]
end
