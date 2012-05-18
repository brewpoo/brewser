require 'brewser/ruby-units'
require 'brewser/json-validation'
require 'brewser/model/base'
require 'brewser/exceptions'
require 'brewser/engines'

module Brewser
  
  class << self
  
    # Returns the potential engine to process the given string
    def identify(string_or_io)
      return BrewSON if BrewSON.acceptable?(string_or_io)
      return BeerXML2 if BeerXML2.acceptable?(string_or_io)
      return BeerXML if BeerXML.acceptable?(string_or_io)
      return ProMashRec if ProMash.acceptable?(string_or_io)
      return ProMashTxt if ProMashTxt.acceptable?(string_or_io)
      raise "Brewson: unable to identify content"
    end
    
    # Executes the engine matching the given string
    def parse(string_or_io)
      if engine=self.identify(string_or_io)
        engine.send(:deserialize, string_or_io)
      else
        return nil
      end
    end
    
  end
  
end
