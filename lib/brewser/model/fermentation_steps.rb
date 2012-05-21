module Brewser
  class FermentationStep < Model
    belongs_to :fermentation_schedule
    
    property :name, String, :required => true
    property :purpose, String, :set => ['primary', 'secondary', 'tertiary', 'conditioning'], :required => true
  
    property :index, Serial
    property :time, TimeInDays
    property :temperature, Temperature
  end
end