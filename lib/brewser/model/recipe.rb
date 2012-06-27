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
    
    def as_json(options={})
      {
        JSON.create_id => "Brewser::Recipe",
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
        'hops' => hops.to_a, 'fermentables' => fermentables.to_a, 
        'additives' => additives.to_a, 'yeasts' => yeasts.to_a,
        'mash_schedule' => mash_schedule, 'fermentation_schedule' => fermentation_schedule, 
        'water_profile' => water_profile,
        'estimated_og' => estimated_og, 'estimated_fg' => estimated_fg, 
        'estimated_color' => estimated_color, 'estimated_ibu' => estimated_ibu, 
        'estimated_abv' => estimated_abv, 'carbonation_level' => carbonation_level, 
        'source' => source, 'url' => url
      }
    end
    
    def self.json_create(o)
      a = self.new
      a.name = o['name']
      a.description = o['description']
      a.brewer = o['brewer']
      a.method = o['method']
      a.type = o['type']
      a.style = o['style']
      a.mash_schedule = o['mash_schedule']
      a.fermentation_schedule = o['fermentation_schedule']
      a.water_profile = o['water_profile']
      o['fermentables'].each do |fermentable|
        a.fermentables.push fermentable
      end unless o['fermentables'].nil?
      o['hops'].each do |hop|
        a.hops.push hop
      end unless o['hops'].nil?
      o['additives'].each do |additive|
        a.additives.push additive
      end unless o['additives'].nil?
      o['yeasts'].each do |yeast|
        a.yeasts.push yeast
      end unless o['yeasts'].nil?
      a.recipe_volume = o['recipe_volume']
      a.boil_volume = o['boil_volume']
      a.boil_time = o['boil_time']
      a.recipe_efficiency = o['recipe_efficiency']
      a.estimated_og = o['estimated_og']
      a.estimated_fg = o['estimated_fg']
      a.estimated_color = o['estimated_color']
      a.estimated_ibu = o['estimated_ibu']
      a.estimated_abv = o['estimated_abv']
      a.carbonation_level = o['carbonation_level']
      a.source = o['source']
      a.url = o['url']

      return a
    end
      
  end

end