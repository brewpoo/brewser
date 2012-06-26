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
      data=o['data']
      return if data.nil?
      a = self.new
      a.name = data['name']
      a.description = data['description']
      a.calcium = data['calcium']
      a.sodium = data['sodium']
      a.magnesium = data['magnesium']
      a.chloride = data['chloride']
      a.sulfates = data['sulfates']
      a.bicarbonate = data['bicarbonate']
      a.alkalinity = data['alkalinity']
      a.ph = data['ph']
      
      return a
    end
    
    def to_json(*a)
      {
        'json_class'   => "Brewser::WaterProfile",
        'data'         => { 
          'name' => name, 'description' => description,
          'calcium' => calcium, 'magnesium' => magnesium,
          'sodium' => sodium, 'chloride' => chloride,
          'sulfates' => sulfates, 'bicarbonate' => bicarbonate,
          'alkalinity' => alkalinity, 'ph' => ph }
      }.to_json(*a)
    end

  end
end