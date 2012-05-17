module Brewser
  
  class Engine
    
    def self.acceptable?(q)
      return false
    end
  
    def self.deserialize(string_or_io)
      return nil
    end
    
  end

end

Dir.glob(File.dirname(__FILE__) + '/engines/*', &method(:require))
