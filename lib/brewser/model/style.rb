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
    
    def self.json_create(o)
      data=o['data']
      return if data.nil?
      a = self.new
      a.name = data['name']
      a.category = data['category']
      a.category_number = data['category_number']
      a.style_letter = data['style_letter']
      a.type = data['type']
      a.style_guide = data['style_guide']

      return a
    end
    
    def to_json(*a)
      {
        'json_class'   => "Brewser::Style",
        'data'         => {
          'name' => name, 'category' => category, 
          'category_number' => category_number, 'style_letter' => style_letter,
          'type' => type, 'style_guide' => style_guide }
      }.to_json(*a)
    end
    
  end
end
