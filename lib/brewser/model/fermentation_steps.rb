module Brewser
  class FermentationStep < Model
    belongs_to :fermentation_schedule
    
    property :name, String
    property :purpose, String, :set => ['primary', 'secondary', 'tertiary', 'conditioning']
  
    property :index, Integer
    property :time, TimeInDays
    property :temperature, Temperature
    
    def self.json_create(o)
      data=o['data']
      return if data.nil?
      a = self.new
      a.name = data['name']
      a.purpose = data['purpose']
      a.index = data['index']
      a.time = data['time']
      a.temperature = data['temperature']

      return a
    end
    
    def to_json(*a)
      {
        'json_class'   => "Brewser::FermentationStep",
        'data'         => {
          'name' => name, 'purpose' => purpose,
          'index' => index, 
          'time' => time, 'temperature' => temperature }
      }.to_json(*a)
    end
    
  end
end