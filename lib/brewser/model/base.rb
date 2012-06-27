module Brewser
      
  class Model
    require 'dm-core'
    require 'dm-validations'
    require 'dm-serializer'

    require "msgpack"
    require 'active_support/inflector'
    
    include DataMapper::Resource
    require "#{File.dirname(__FILE__)}/units"
    include Units
    
    DataMapper.setup(:default, :adapter => 'in_memory')
    def self.default_repository_name;:default;end
    def self.auto_migrate_down!(rep);end
    def self.auto_migrate_up!(rep);end
    def self.auto_upgrade!(rep);end
    
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