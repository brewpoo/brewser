module Brewser
    
  class Model
    require 'dm-core'
    require 'dm-validations'
    require 'active_support/inflector'
    
    include DataMapper::Resource
    require "#{File.dirname(__FILE__)}/properties"
    include Properties
    
    DataMapper.setup(:default, "abstract::")

    #
    #
    # Setup model and add to class
    #
  
    @models = {}
    @collections = {}
    
    class << self
      attr_accessor :models, :collections
    end
  
    # Returns the singular name of the model
    def self.node_name
      name.split('::').last.underscore
    end

    # Returns the plural name of the model
    def self.collection_name
      node_name.pluralize
    end

    # Adds the models singular and plural names to class attributes
    def self.inherited(klass)
      super
      # @models[klass.node_name] = klass
      # @collections[klass.collection_name] = klass
    end

    def as_brewson
      BrewSON.serialize(self)
    end
    
    def as_beerxml
      BeerXML2.serialize(self)
    end
    
    %w(additive fermentable fermentation_schedule fermentation_steps hop mash_schedule mash_steps recipe style water_profile yeast).
       each { |f| require "#{File.dirname(__FILE__)}/#{f}" }
  end
    
end