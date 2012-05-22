module Brewser 
  class Style < Brewser::Model
    belongs_to :recipe
    
    property :name, String, :required => true
    property :category, String, :required => true
    property :category_number, String, :required => true
    property :style_letter, String, :required => true
    property :style_guide, String, :required => true
    property :type, String, :set => %w(Lager Ale Mead Wheat Mixed Cider)
    property :og_min, Float
    property :og_max, Float
    property :fg_min, Float
    property :fg_max, Float
    property :ibu_min, Float
    property :ibu_max, Float
    property :color_min, Float
    property :color_max, Float

    property :carb_min, Float
    property :carb_max, Float
    property :abv_min, Float
    property :abv_max, Float
    property :notes, String, :length => 65535
    property :profile, String, :length => 65535
    property :ingredients, String, :length => 65535
    property :examples, String, :length => 65535
  end
end
