module Brewser
  
  class MashStep < Model
    belongs_to :mash_schedule
    
    property :index, Integer
    
    property :name, String, :required => true
    property :description, String, :length => 65535
    
    property :type, String, :set => ['Direct', 'Infusion', 'Decoction']
    property :purpose, String, :set => ['acid_rest', 'protein_rest', 'saccharification_rest', 'mash_out']
    
    property :step_volume, Volume
    property :ramp_time, Time
    property :water_to_grain_ratio, Float
    
    property :infusion_volume, Volume
    property :infusion_temperature, Temperature
    
    property :rest_temperature, Temperature, :required => true
    property :rest_time, Time, :required => true
    
    def self.json_create(o)
      data=o['data']
      return if data.nil?
      a = self.new
      a.name = data['name']
      a.index = data['index']
      a.description = data['description']
      a.type = data['type']
      a.purpose = data['purpose']
      a.step_volume = data['step_volume']
      a.ramp_time = data['ramp_time']
      a.water_to_grain_ratio = data['water_to_grain_ratio']
      a.infusion_volume = data['infusion_volume']
      a.infusion_temperature = data['infusion_temperature']
      a.rest_temperature = data['rest_temperature']
      a.rest_time = data['rest_time']

      return a
    end
    
    def to_json(*a)
      {
        'json_class'   => "Brewser::MashStep",
        'data'         => {
          'name' => name, 'index' => index, 'description' => description, 
          'type' => type, 'purpose' => purpose,
          'step_volume' => step_volume, 'ramp_time' => ramp_time,
          'infusion_volume' => infusion_volume, 'infusion_temperature' => infusion_temperature,
          'rest_temperature' => rest_temperature, 'rest_time' => rest_time,
          'water_to_grain_ratio' => water_to_grain_ratio }
      }.to_json(*a)
    end
    
  end
  
end
