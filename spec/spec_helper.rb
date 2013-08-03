require 'simplecov'

# SimpleCov.start do
#   add_filter "spec/"
# end

require 'rubygems'
require 'bundler'
Bundler.require

require 'brewser'
require 'rspec'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
  
  def filename(file)
    "samples/#{file}"
  end
  def read_file(file)
    File.read(filename(file))
  end
  def read_xml(file)
    Nokogiri::XML(read_file(file)){|config| config.noblanks }
  end
  
end
