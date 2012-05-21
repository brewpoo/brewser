module Brewser
  class MashSchedule < Brewser::Model  
    belongs_to :recipe
    
    property :name, String, :required => true
    property :description, String
    property :grain_temp, Temperature
    property :sparge_temp, Temperature
    has n, :mash_steps
  end
end