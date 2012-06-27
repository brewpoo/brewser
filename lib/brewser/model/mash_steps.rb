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
      return nil if o.blank?
      a = self.new
      a.name = o['name']
      a.index = o['index']
      a.description = o['description']
      a.type = o['type']
      a.purpose = o['purpose']
      a.step_volume = o['step_volume']
      a.ramp_time = o['ramp_time']
      a.water_to_grain_ratio = o['water_to_grain_ratio']
      a.infusion_volume = o['infusion_volume']
      a.infusion_temperature = o['infusion_temperature']
      a.rest_temperature = o['rest_temperature']
      a.rest_time = o['rest_time']

      return a
    end
    
    def as_json(options={})
      {
        JSON.create_id => "Brewser::MashStep",
        'name' => name, 'index' => index, 'description' => description, 
        'type' => type, 'purpose' => purpose,
        'step_volume' => step_volume, 'ramp_time' => ramp_time,
        'infusion_volume' => infusion_volume, 'infusion_temperature' => infusion_temperature,
        'rest_temperature' => rest_temperature, 'rest_time' => rest_time,
        'water_to_grain_ratio' => water_to_grain_ratio 
      }
    end
    
  end
  
end
