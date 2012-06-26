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
      data=o['data']
      a = self.new
      a.name = data['name']
      a.description = data['description']
      a.type = data['type']
      a.best_for = data['best_for']
      a.supplier = data['supplier']
      a.catalog = data['catalog']
      a.min_temperature = data['min_temperature']
      a.max_temperature = data['max_temperature']
      a.flocculation = data['flocculation']
      a.attenuation = data['attenuation']
      
      a.add_to_secondary = data['add_to_secondary']
      a.form = data['form']
      a.amount = data['amount']
      a.max_reuse = data['max_reuse']
      a.times_cultured = data['times_cultured']
      
      return a
    end
    
    def to_json(*a)
      {
        'json_class'   => "Brewser::Yeast",
        'data'         => {
          'name' => name, 
          'description' => description, 
          'type' => type,  'best_for' => best_for,
          'supplier' => supplier, 'catalog' => catalog,
          'min_temperature' => min_temperature, 'max_temperature' => max_temperature,
          'flocculation' => flocculation, 'attenuation' => attenuation,
          'add_to_secondary' => add_to_secondary?, 
          'form' => form, 'amount' => amount,
          'max_reuse' => max_reuse, 'times_cultured' => times_cultured }
      }.to_json(*a)
    end
    
  end
end