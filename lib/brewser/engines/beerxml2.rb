class BeerXML2 < Brewser::Engine
  
  require 'nokogiri'
  
  class << self

    def acceptable?(q)
     Nokogiri::XML(q){|config| config.noblanks }.remove_namespaces!.xpath("//version").inner_text.to_i == 2 ? true : false
     # @TODO Add XSD Validation here
    end

    def deserialize(string_or_io)
      parse_xml(string_or_io)
    end
    
    def serialize(brewser_model)
    end

    def parse_xml(string_or_io)
      raise NotImplemented, "BeerXML2 support is not implemented yet"
    end
  
  end
  
end

