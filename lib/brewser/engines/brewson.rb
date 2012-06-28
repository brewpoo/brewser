class BrewSON < Brewser::Engine
  
  class << self
    
    def acceptable?(q)
      return q.valid_json?
    end
  
    def deserialize(string_or_io)
       begin
         JSON.parse(string_or_io)
      rescue
        raise Error, "BrewSON engine encountered an issue and can not continue"
       end
    end
    
    def serialize(brewser_model)
       begin
         JSON.generate(brewser_model)
      rescue
        raise Error, "BrewSON engine encountered an issue and can not continue"
       end
    end
    
  end
  
end


