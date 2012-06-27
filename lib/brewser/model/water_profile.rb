module Brewser
  class WaterProfile < Model    
    belongs_to :recipe
    
    property :name, String, :required => true
    property :description, String, :length => 65535
    
    property :calcium, Float, :required => true
    property :magnesium, Float, :required => true
    property :sodium, Float, :required => true
    property :chloride, Float, :required => true
    property :sulfates, Float, :required => true
    property :bicarbonate, Float
    property :alkalinity, Float
    property :ph, Float
    
    def self.json_create(o)
      a = self.new
      a.name = o['name']
      a.description = o['description']
      a.calcium = o['calcium']
      a.sodium = o['sodium']
      a.magnesium = o['magnesium']
      a.chloride = o['chloride']
      a.sulfates = o['sulfates']
      a.bicarbonate = o['bicarbonate']
      a.alkalinity = o['alkalinity']
      a.ph = o['ph']
      
      return a
    end
    
    def as_json(options={})
      {
        JSON.create_id => "Brewser::WaterProfile",
        'name' => name, 'description' => description,
        'calcium' => calcium, 'magnesium' => magnesium,
        'sodium' => sodium, 'chloride' => chloride,
        'sulfates' => sulfates, 'bicarbonate' => bicarbonate,
        'alkalinity' => alkalinity, 'ph' => ph
      }
    end

  end
end