module Brewser
    
  class Model
    require 'dm-core'
    require 'dm-validations'
    require 'active_support/inflector'
    
    include DataMapper::Resource
    require "#{File.dirname(__FILE__)}/units"
    include Units
    
    DataMapper.setup(:default, :adapter => 'in_memory')
    def self.default_repository_name;:default;end
    def self.auto_migrate_down!(rep);end
    def self.auto_migrate_up!(rep);end
    def self.auto_upgrade!(rep);end
        
    def deep_json
      h = {}
      instance_variables.each do |e|
        key = e[1..-1]
        next if ["roxml_references", "_persistence_state", "_key"].include? key
        o = instance_variable_get e.to_sym
        h[key] = (o.respond_to? :deep_json) ? o.deep_json : o;
      end
      h
    end
    
    def to_json *a
      deep_json.to_json *a
    end
    
    def as_brewson
      BrewSON.serialize(self)
    end
    
    def as_beerxml
      BeerXML2.serialize(self)
    end
    
    %w(additive batch fermentable fermentation_schedule fermentation_steps hop mash_schedule mash_steps recipe style water_profile yeast).
       each { |f| require "#{File.dirname(__FILE__)}/#{f}" }
  end
    
end