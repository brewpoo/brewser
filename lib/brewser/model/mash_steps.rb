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
    
    property :infusion_volume, Volume
    property :infusion_temperature, Temperature
    
    property :rest_temperature, Temperature, :required => true
    property :rest_time, Time, :required => true
    
    validates_presence_of :infusion_volume, :if => proc { |t| t.type == 'Infusion' }
    validates_presence_of :infusion_temperature, :if => proc { |t| t.type == 'Infusion' }
    
  end
  
end
