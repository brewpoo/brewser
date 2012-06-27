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
      a = self.new
      a.name = o['name']
      a.origin = o['origin']
      a.supplier = o['supplier']
      a.description = o['description']      
      a.type = o['type']
      a.potential = o['potential']
      a.color = o['color']
      a.amount = o['amount'].u unless o['amount'].blank?
      a.late_addition = o['added_late']
      a.coarse_fine_diff = o['coarse_fine_diff']
      a.moisture = o['moisture']
      a.diastatic_power = o['diastatic_power']
      a.protein = o['protein']
      a.max_in_batch = o['max_in_batch']
      a.origin = o['origin']
      a.recommend_mash = o['recommend_mash']
      a.ibu_gal_per_lb = o['ibu_gal_per_lb']

      return a
    end
    
    def as_json(options={})
      {
        JSON.create_id => "Brewser::Fermentable",
        'name' => name, 'origin' => origin, 
        'supplier' => supplier, 'description' => description,
        'type' => type, 'ppg' => ppg, 'potential' => potential, 
        'color' => color, 'amount' => amount.to_s, 'added_late' => late_addition?, 
        'coarse_fine_diff' => coarse_fine_diff, 'moisture' => moisture, 
        'diastatic_power' => diastatic_power, 'protein' => protein, 'max_in_batch' => max_in_batch, 
        'recommend_mash' => recommend_mash?, 'ibu_gal_per_lb' => ibu_gal_per_lb
      }
    end
      
  end
end