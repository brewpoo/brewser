class BrewSON < Brewser::Engine
  
  class << self
    
    def acceptable?(q)
      return q.valid_json?
    end
  
    def deserialize(string_or_io)
    end
    
    def serialize(brewser_model)
    end
    
  end
  
end


