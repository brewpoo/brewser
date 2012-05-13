require 'dm-core'
require 'dm-validations'
require 'nokogiri'
require 'ruby-units'
require 'json'

Unit.redefine!('celsius') do |celsius|
  celsius.aliases  = %w{degC dC celsius centigrade}
end

Unit.redefine!('fahrenheit') do |fahrenheit|
  fahrenheit.aliases  = %w{degF dF fahrenheit}
end

Unit.define('barrel') do |barrel|
  barrel.definition = Unit('31 gal')
  barrel.aliases    = %w{bbl bbls barrel barrels}
end

Unit.define('keg') do |keg|
  keg.definition  = Unit('1/2 barrel')
  keg.aliases     = %w{keg kegs}
end

# Add convienience method
class Unit
  # returns the scalar value convert to other units
  def scalar_in(other)
    to(other).scalar.to_f
  end
end

class String
  def valid_json?
    begin
      JSON.parse(self)
      return true
    rescue Exception => e
      return false
    end
  end
end

module Brewser
  def self.parse_xml(string_or_io)
    # Need to identify which version of BeerXML we are dealing with
    xml = Nokogiri::XML(string_or_io){|config| config.noblanks }.root
    results = Brewser.examine_xml(xml)
    case results[:version]
    when 1
      return Beerxml::Model.from_xml(xml)
    when 2
      # Strip the beer_xml node
      return Beerxml::Model2.from_xml(xml.children[1])
    else
      raise "Brewser: unidentifiable XML"
    end
  end

  def self.examine_xml(xml)
    namespace = xml.namespace.nil? ? nil : 'xmlns:'
    version = xml.xpath("//#{namespace}version").inner_text.to_i
    if version == 0 # Not found so must be version 1
      version = 1
      subject = xml.children[0].node_name.downcase
      count = xml.search("//#{subject.upcase}").size
      
    else
      subject = xml.xpath("//#{namespace}beer_xml").children[1].children[0].node_name
      count = xml.search("//#{namespace}#{subject}").size
    end
    # puts "Version: #{version} Namespace: #{namespace}"
    # puts "Subject: #{subject} Count: #{count}"
    return { :version => version, :subject => subject, :count => count }
  end
  
end

require 'beerxml/beerxml'


# This'll have to go eventually, but for now it's nice
DataMapper.setup(:default, "abstract::")
