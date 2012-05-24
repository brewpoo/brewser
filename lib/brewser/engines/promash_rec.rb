class ProMashRec < Brewser::Engine
  
  class << self
    
    def acceptable?(q)
      return false
    end
  
    def deserialize(string_or_io)
    end
    
  end
  
  module Loader
    
    require 'bindata'
    
    class Hop < BinData::Record
      endian :little
      string :test
    end
  end
  
end


class ProMashRec::Hop < Brewser::Hop
  
  def from_promash(data)
    return Loader::Hop.new(data)
  end
  
end

class ProMashRec::Fermentable < Brewser::Fermentable

  
end

class ProMashRec::Additive < Brewser::Additive

  
end

class ProMashRec::Yeast < Brewser::Yeast
  
  
end

class ProMashRec::MashStep < Brewser::MashStep
  
end

class ProMashRec::MashSchedule < Brewser::MashSchedule
  
end

class ProMashRec::FermentationStep < Brewser::FermentationStep
    
end

class ProMashRec::FermentationSchedule < Brewser::FermentationSchedule 
  
end

class ProMashRec::WaterProfile < Brewser::WaterProfile


end

class ProMashRec::Style < Brewser::Style

  
end

class ProMashRec::Recipe < Brewser::Recipe


end
