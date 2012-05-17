module Brewser
  
  class FermentatinoStep < Model
    property :name, String, :required => true
    property :purpose, String, :set => ['primary', 'secondary', 'tertiary', 'conditioning'], :required => true
  
    property :index, Serial
    property :time, TimeInDays
    property :temperature, Temperature
  end
  
end