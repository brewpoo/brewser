module Brewser
  class FermentationStep < Model
    belongs_to :fermentation_schedule
    
    property :name, String
    property :purpose, String, :set => ['primary', 'secondary', 'tertiary', 'conditioning']
  
    property :index, Integer
    property :time, TimeInDays
    property :temperature, Temperature
    
    def self.json_create(o)
      a = self.new
      a.name = o['name']
      a.purpose = o['purpose']
      a.index = o['index']
      a.time = o['time'].u unless o['time'].blank?
      a.temperature = o['temperature'].u unless o['temperature'].blank?

      return a
    end
    
    def as_json(options={})
      {
        JSON.create_id=> "Brewser::FermentationStep",
        'name' => name, 'purpose' => purpose,
        'index' => index, 
        'time' => time.to_s, 'temperature' => temperature.to_s
      }
    end
    
  end
end