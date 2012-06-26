module Brewser
  class Recipe < Model
    belongs_to :batch
    
    property :date_created, Date
    property :name, String, :required => true
    property :description, String, :length => 65535

    property :type, String, :set => ['Ale', 'Lager', 'Wheat', 'Cider', 'Mead', 'Hybrid']
    property :method, String, :set => ['Extract', 'Partial Mash', 'All Grain'], :required => true
    
    has 1, :style
    validates_presence_of :style
    
    property :brewer, String
    property :recipe_volume, Volume, :required => true
    property :boil_volume, Volume, :required => true
    property :boil_time, Time, :required => true
    property :recipe_efficiency, Float
    validates_presence_of :recipe_efficiency, :if => proc { |t| t.method != 'Extract' }

    has n, :hops
    has n, :fermentables
    has n, :additives
    has n, :yeasts
    
    has 1, :mash_schedule
    has 1, :fermentation_schedule
    has 1, :water_profile

    property :asst_brewer, String
    property :taste_notes, String, :length => 65535
    property :taste_rating, Float
    
    property :estimated_og, Float
    property :estimated_fg, Float
    property :estimated_color, Float
    property :estimated_ibu, Float
    property :estimated_abv, Float
    
    property :source, String, :length => 65535
    property :url, String, :length => 65535
        
    property :carbonation_level, Float
  
    validates_presence_of :mash_schedule, :if => proc { |t| t.method != 'Extract' }
    
    def to_json(*a)
      {
        'json_class'   => "Brewser::Recipe",
        'data'         => {
          'name' => name, 
          'description' => description, 
          'type' => type,
          'method' => method,
          'brewer' => brewer,
          'style' => style,
          'recipe_volume' => recipe_volume, 
          'boil_volume' => boil_volume,
          'boil_time' => boil_time, 
          'recipe_efficiency' => recipe_efficiency, 
          'hops' => hops, 'fermentables' => fermentables, 
          'additives' => additives, 'yeasts' => yeasts,
          'mash_schedule' => mash_schedule, 'fermentation_schedule' => fermentation_schedule, 
          'water_profile' => water_profile,
          'estimated_og' => estimated_og, 'estimated_fg' => estimated_fg, 
          'estimated_color' => estimated_color, 'estimated_ibu' => estimated_ibu, 
          'estimated_abv' => estimated_abv, 'carbonation_level' => carbonation_level, 
          'source' => source, 'url' => url }
      }.to_json(*a)
    end
    
    def self.json_create(o)
      data=o['data']
      a = self.new
      a.name = data['name']
      a.description = data['description']
      a.brewer = data['brewer']
      a.method = data['method']
      a.type = data['type']
      a.style = data['style']
      a.mash_schedule = data['mash_schedule']
      a.fermentation_schedule = data['fermentation_schedule']
      a.water_profile = data['water_profile']
      data['fermentables'].each do |fermentable|
        a.fermentables.push JSON.parse(fermentable)
      end unless data['fermentables'].nil?
      data['hops'].each do |hop|
        a.hops.push JSON.parse(hop)
      end unless data['hops'].nil?
      data['additives'].each do |additive|
        a.additives.push JSON.parse(additive)
      end unless data['additives'].nil?
      data['yeasts'].each do |yeast|
        a.yeasts.push JSON.parse(yeast)
      end unless data['yeasts'].nil?
      a.recipe_volume = data['recipe_volume']
      a.boil_volume = data['boil_volume']
      a.boil_time = data['boil_time']
      a.recipe_efficiency = data['recipe_efficiency']
      a.estimated_og = data['estimated_og']
      a.estimated_fg = data['estimated_fg']
      a.estimated_color = data['estimated_color']
      a.estimated_ibu = data['estimated_ibu']
      a.estimated_abv = data['estimated_abv']
      a.carbonation_level = data['carbonation_level']
      a.source = data['source']
      a.url = data['url']

      return a
    end
      
  end

end