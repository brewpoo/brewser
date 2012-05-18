module Brewser
  class Yeast < Model
    include DataMapper::Resource

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
    property :amount, String, :required => true

    # These are applicable only in Batches
    property :times_cultured, Integer

  end
end