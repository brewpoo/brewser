module Brewser
  class FermentationStep < Model
    belongs_to :fermentation_schedule
    
    property :name, String
    property :purpose, String, :set => ['primary', 'secondary', 'tertiary', 'conditioning']
  
    property :index, Integer
    property :time, TimeInDays
    property :temperature, Temperature
  end
end