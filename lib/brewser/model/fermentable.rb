module Brewser
  class Fermentable < Model
    belongs_to :recipe
    
    property :name, String, :required => true
    property :origin, String, :length => 512
    property :supplier, String, :length => 512
    property :description, String, :length => 65535
    
    property :type, String, :set => ['Grain', 'Sugar', 'Extract', 'Dry Extract', 'Adjunct'], :required => true
    property :yield_percent, Float
    property :potential, Float, :required => true
    property :ppg, Integer
    
    property :color, Float, :required => true

    property :amount, Weight, :required => true
    property :late_addition?, Boolean, :default => false
    
    property :coarse_fine_diff, Float
    property :moisture, Float
    property :diastatic_power, Float
    property :protein, Float
    property :max_in_batch, Float
    property :recommend_mash?, Boolean
    property :ibu_gal_per_lb, Float
    
    def ppg
      (potential-1)*1000
    end
      
  end
end