module Brewser
  class MashSchedule < Brewser::Model  
    belongs_to :recipe
    
    property :name, String, :required => true
    property :description, String
    property :grain_temp, Temperature
    property :sparge_temp, Temperature
    
    has n, :mash_steps
    property :current_index, Integer, :default => 0
    
    def next_index
      return self.current_index += 1
    end
  end
end