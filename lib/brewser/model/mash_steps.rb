module Brewser
  
  class MashStep < Model
    property :name, String, :required => true
    property :purpose, String, :set => ['acid_rest', 'protein_rest', 'saccharification_rest', 'mash_out'], :required => true
    
    property :index, Serial
    property :step_type, String, :set => ['direct', 'infusion', 'decoction']
    property :step_volume, Volume, :required => true
    property :step_time, Time, :required => true
    
    property :rest_temperature, Temperature, :required => true
    
    # property :id, Serial
    # belongs_to :mash_schedule
  end
  
end
