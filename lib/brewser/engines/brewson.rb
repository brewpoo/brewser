class BrewSON < Brewser::Engine
  
  class << self
    
    def acceptable?(q)
      return q.valid_json?
    end
  
    def deserialize(string_or_io)
    end
    
    def serialize(brewser_model)
      brewser_model.deep_json
    end
    
  end
  
end


