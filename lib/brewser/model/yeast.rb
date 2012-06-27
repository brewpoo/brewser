module Brewser
  class Yeast < Model
    belongs_to :recipe
    
    property :name, String, :required => true
    property :description, String, :length => 65535
    
    property :type, String, :set => ['Ale', 'Lager', 'Wheat', 'Wine', 'Champagne'], :required => true

    property :supplier, String
    property :catalog, String
    
    property :min_temperature, Temperature
    property :max_temperature, Temperature
    property :flocculation, String, :set => ['Low', 'Medium', 'High', 'Very High']
    property :attenuation, Float
    property :best_for, String
    property :max_reuse, Integer
    
    # Recipes
    property :add_to_secondary?, Boolean
    property :form, String, :set => ['Liquid', 'Dry', 'Slant', 'Culture'], :required => true
    property :amount, WeightOrVolume, :required => true

    # These are applicable only in Batches
    property :times_cultured, Integer

    def self.json_create(o)
      a = self.new
      a.name = o['name']
      a.description = o['description']
      a.type = o['type']
      a.best_for = o['best_for']
      a.supplier = o['supplier']
      a.catalog = o['catalog']
      a.min_temperature = o['min_temperature'].u unless o['min_temperature'].blank?
      a.max_temperature = o['max_temperature'].u unless o['max_temperature'].blank?
      a.flocculation = o['flocculation']
      a.attenuation = o['attenuation']
      
      a.add_to_secondary = o['add_to_secondary']
      a.form = o['form']
      a.amount = o['amount'].u unless o['amount'].blank?
      a.max_reuse = o['max_reuse']
      a.times_cultured = o['times_cultured']
      
      return a
    end
    
    def as_json(options={})
      {
        JSON.create_id => "Brewser::Yeast",
        'name' => name, 
        'description' => description, 
        'type' => type,  'best_for' => best_for,
        'supplier' => supplier, 'catalog' => catalog,
        'min_temperature' => min_temperature.to_s, 'max_temperature' => max_temperature.to_s,
        'flocculation' => flocculation, 'attenuation' => attenuation,
        'add_to_secondary' => add_to_secondary?, 
        'form' => form, 'amount' => amount.to_s,
        'max_reuse' => max_reuse, 'times_cultured' => times_cultured
      }
    end
    
  end
end