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
      return 0 if potential.blank?
      (potential-1)*1000
    end
    
    def self.json_create(o)
      data=o['data']
      a = self.new
      a.name = data['name']
      a.origin = data['origin']
      a.supplier = data['supplier']
      a.description = data['description']      
      a.type = data['type']
      a.potential = data['potential']
      a.color = data['color']
      a.amount = data['amount']
      a.late_addition = data['added_late']
      a.coarse_fine_diff = data['coarse_fine_diff']
      a.moisture = data['moisture']
      a.diastatic_power = data['diastatic_power']
      a.protein = data['protein']
      a.max_in_batch = data['max_in_batch']
      a.origin = data['origin']
      a.recommend_mash = data['recommend_mash']
      a.ibu_gal_per_lb = data['ibu_gal_per_lb']

      return a
    end
    
    def to_json(*a)
      {
        'json_class'   => "Brewser::Fermentable",
        'data'         => { 
          'name' => name, 'origin' => origin, 
          'supplier' => supplier, 'description' => description,
          'type' => type, 'ppg' => ppg, 'potential' => potential, 
          'color' => color, 'amount' => amount, 'added_late' => late_addition?, 
          'coarse_fine_diff' => coarse_fine_diff, 'moisture' => moisture, 
          'diastatic_power' => diastatic_power, 'protein' => protein, 'max_in_batch' => max_in_batch, 
          'recommend_mash' => recommend_mash?, 'ibu_gal_per_lb' => ibu_gal_per_lb }
      }.to_json(*a)
    end
      
  end
end