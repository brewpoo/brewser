class BeerXML < Brewser::Engine
  
  require 'nokogiri'

  class << self
    
    # Simple test to see if this looks like XML
    def acceptable?(q)
      Nokogiri::XML(q){|config| config.noblanks }.root ? true : false
    end
    
    # Attempt to deserialize the data
    def deserialize(string_or_io)
      begin
        outer = Nokogiri::XML(string_or_io).root
        # We expect to find a plural of one of the models
        objects = (outer>outer.node_name.singularize).map do |inner|
          ("BeerXML::#{inner.node_name.downcase.camelcase}".constantize).from_xml(inner)
        end
        return cleanup(objects)
     # rescue
     #   raise "Brewser: BeerXML encountered an issue and can not continue"
      end
    end
    
    # Ugly hack to deal with BeerXML oddities
    def cleanup(brewser_objects)
      brewser_objects.each(&:cleanup)
    end
 
  end
end

require 'roxml'

#
#
# These models add the hooks to deserialize the data using ROXML
#  Brought in as a seperate model to allow multiple version of BeerXML
class BeerXML::Hop < Brewser::Hop
  include ROXML
  
  xml_name "HOP"
  xml_convention :upcase
  xml_reader :name
  xml_reader :origin
  xml_reader :description, :from => "NOTES"
  
  xml_reader :type
  xml_reader(:form) { |x| 
    x="Whole" if x=="Leaf"
    x
  }
  
  xml_reader :display_amount
  xml_reader :uncast_amount, :from => "AMOUNT"
  
  xml_reader :display_time
  xml_reader :uncast_time, :from => "TIME"
  
  xml_reader(:added_when, :from => "USE") { |x|
    x="Dry" if x=="Dry Hop"
    x="FWH" if x=="First Wort"
    x
    }
  
  xml_reader :alpha_acids, :from => "ALPHA", :as => Float
  xml_reader :beta_acids, :from => "BETA", :as => Float
  
  xml_reader :humulene, :as => Float
  xml_reader :caryophyllene, :as => Float
  xml_reader :cohumulone, :as => Float
  xml_reader :myrcene, :as => Float
  xml_reader :farnesene, :as => Float # Not explicitly included in BeerXML
  xml_reader :total_oil, :as => Float # Not explicitly included in BeerXML
  xml_reader :storageability, :from => "HSI", :as => Float
  
  xml_reader :substitutes
  
  def cleanup
    self.amount = display_amount.present? ? display_amount.u : "#{uncast_amount} kg".u
    self.time = display_time.present? ? display_time.u : "#{uncast_time} min".u
  end
  
end

class BeerXML::Fermentable < Brewser::Fermentable
  include ROXML
  
  xml_name "FERMENTABLE"
  xml_convention :upcase
  xml_reader :name
  xml_reader :origin
  xml_reader :supplier
  xml_reader :description, :from => "NOTES"
  xml_reader :type

  xml_reader :display_amount
  xml_reader :uncast_amount, :from => "AMOUNT"
  
  xml_reader :yield_percent, :from => "YIELD"
  xml_reader :uncast_potential, :from => "POTENTIAL"
  
  xml_reader :color
  
  xml_reader :late_addition?, :from => "ADD_AFTER_BOIL"
  xml_reader :recommend_mash?, :from => "RECOMMEND_MASH"
  
  xml_reader :max_in_batch, :as => Float
  xml_reader(:diastatic_power) {|x| x.to_f }
  xml_reader(:moisture) {|x| x.to_f }
  xml_reader(:coarse_fine_diff) {|x| x.to_f }
  xml_reader(:protein) {|x| x.to_f }
  xml_reader(:ibu_gal_per_lb) {|x| x.to_f }
  
  def cleanup
    self.amount = display_amount.present? ? display_amount.u : "#{uncast_amount} kg".u
    self.potential = uncast_potential.present? ? uncast_potential.to_f : 1+(46*(yield_percent/100))/1000
    self.ppg = (potential-1)*1000
  end
  
end

class BeerXML::Additive < Brewser::Additive
  include ROXML
  
  xml_name "MISC"
  xml_convention :upcase
  xml_reader :name
  xml_reader :origin
  
  xml_reader :type
  xml_reader :form
  
  xml_reader :display_amount
  xml_reader :amount_scalar, :from => "AMOUNT"
  
  xml_reader :weight?, :from => "AMOUNT_IS_WEIGHT"
    
  xml_reader(:added_when, :from => "USE") { |x|
    x="Packaging" if x == "Bottling"
    x
  }
  xml_reader :use_for
  
  xml_reader :display_time
  xml_reader :uncast_time, :from => "TIME"
  
  xml_reader :description, :from => "NOTES"
  
  def set_amount
    return display_amount.u unless display_amount.blank?
    units = weight? ? "kg" : "l"
    return amount_scalar.u * units.u
  end
  
  def cleanup
    self.amount = set_amount
    self.time = display_time.present? ? display_time.u : "#{time} min".u
  end
  
end

class BeerXML::Yeast < Brewser::Yeast
  include ROXML
  
  xml_name "YEAST"
  xml_convention :upcase
  xml_reader :name
  xml_reader :supplier, :from => "LABORATORY"
  xml_reader :catalog, :from => "PRODUCT_ID"
  
  xml_reader :type
  xml_reader :form
  
  xml_reader :display_amount
  xml_reader :amount_scalar, :from => "AMOUNT"
  xml_reader :weight?, :from => "AMOUNT_IS_WEIGHT"
    
  xml_reader :uncast_min_temperature, :from => "MIN_TEMPERATURE"
  xml_reader :disp_min_temp
  
  xml_reader :uncast_max_temperature, :from => "MAX_TEMPERATURE"
  xml_reader :disp_max_temp
  
  xml_reader :flocculation
  xml_reader :attenuation, :as => Float
  xml_reader :best_for
  xml_reader :add_to_secondary?, :from => "ADD_TO_SECONDARY"

  xml_reader :times_cultured
  xml_reader :max_reuse

  xml_reader :description, :from => "NOTES"
    
  def set_amount
    return display_amount.u unless display_amount.blank?
    units = weight? ? "kg" : "l"
    return amount_scalar.u * units.u
  end
  
  def cleanup
    self.amount = set_amount
    self.min_temperature = disp_min_temp.present? ? disp_min_temp.u : "#{uncast_min_temperature} dC".u
    self.max_temperature = disp_max_temp.present? ? disp_max_temp.u : "#{uncast_max_temperature} dC".u
  end
  
end

class BeerXML::MashStep < Brewser::MashStep
  include ROXML
  
  xml_name "MASH_STEP"
  xml_convention :upcase
  xml_reader :name
  xml_reader :description
  
  xml_reader :purpose
  xml_reader(:type) { |x| 
    x="Direct" if x=="Temperature"
    x
  }
 
  xml_reader(:ramp_time) { |x| "#{x} min".u }
  xml_reader(:rest_time, :from => "STEP_TIME") { |x| "#{x} min".u }
  
  xml_reader :uncast_rest_temperature, :from => "STEP_TEMP"
  
  xml_reader :water_to_grain_ratio, :from => "WATER_GRAIN_RATIO", :as => Float
  
  xml_reader :uncast_infusion_volume, :from => "INFUSE_AMOUNT"
  xml_reader :display_infuse_amt
  
  xml_reader :infusion_temperature, :from => "INFUSE_TEMP"
    
  property :step_volume, Volume
  property :ramp_time, Time
    
  property :rest_temperature, Temperature, :required => true
  property :rest_time, Time, :required => true
  
  def cleanup
    self.index = mash_schedule.mash_steps.index(self)+1
    self.infusion_volume = display_infuse_amt.present? ? display_infuse_amt.u : "#{uncast_infusion_volume} l".u unless !uncast_infusion_volume.present? or uncast_infusion_volume == 0
    if infusion_temperature.present?
      self.infusion_temperature
      self.infusion_temperature = infusion_temperature.unitless? ? infusion_temperature*"1 C".u : infusion_temperature
    end
    self.rest_temperature = "#{uncast_rest_temperature} dC".u
  end
  
end

class BeerXML::MashSchedule < Brewser::MashSchedule
  include ROXML
  
  xml_name "MASH"
  xml_convention :upcase
  xml_reader :name
  xml_reader :description, :from => "NOTES"
  
  xml_reader :display_grain_temp
  xml_reader :uncast_grain_temp, :from => "GRAIN_TEMP"
  
  xml_reader :display_sparge_temp
  xml_reader :uncast_sparge_temp, :from => "SPARGE_TEMP"
  
  xml_attr :mash_steps, :as => [BeerXML::MashStep], :in => "MASH_STEPS"
  
  def cleanup
    mash_steps.each do |m|
      m.cleanup
    end
    self.grain_temp = display_grain_temp.present? ? display_grain_temp.u : "#{uncast_grain_temp} dC".u
    self.sparge_temp = display_sparge_temp.present? ? display_sparge_temp.u : "#{uncast_sparge_temp} dC".u
  end
  
end

class BeerXML::FermentationStep < Brewser::FermentationStep
    
end

class BeerXML::FermentationSchedule < Brewser::FermentationSchedule 
  
end

class BeerXML::WaterProfile < Brewser::WaterProfile
  include ROXML
  
  xml_name "WATER"
  xml_convention :upcase
  xml_reader :name, :from => "NAME"
  xml_reader(:calcium, :from => "CALCIUM") {|x| x.to_f }
  xml_reader(:magnesium, :from => "MAGNESIUM") {|x| x.to_f }
  xml_reader(:sodium, :from => "SODIUM") {|x| x.to_f }
  xml_reader(:chloride, :from => "CHLORIDE") {|x| x.to_f }
  xml_reader(:sulfates, :from => "SULFATE") {|x| x.to_f }
  xml_reader(:bicarbonate, :from => "BICARBONATE") {|x| x.to_f }
  xml_reader(:alkalinity, :from => "ALKALINITY") {|x| x.to_f }
  xml_reader(:ph, :from => "PH") {|x| x.to_f }
  xml_reader :description, :from => "NOTES"
  
  def cleanup
    # nothing to do here
  end
end


class BeerXML::Style < Brewser::Style
  include ROXML
  
  xml_name "STYLE"
  xml_convention :upcase
  xml_reader :name
  xml_reader :category
  xml_reader :category_number
  xml_reader :style_letter
  xml_reader :style_guide
  xml_reader(:type) { |x| 
    x="Other" if x=="Wheat" or x=="Mixed" or x=="Hybrid"
    x
  }
  
  # Don't really need these:
  # xml_reader :og_min
  # xml_reader :og_max
  # xml_reader :fg_min
  # xml_reader :fg_max
  # xml_reader :ibu_min
  # xml_reader :ibu_max
  # xml_reader :color_min
  # xml_reader :color_max
  # 
  # xml_reader :carb_min
  # xml_reader :carb_max
  # xml_reader :abv_min
  # xml_reader :abv_max
  # 
  # xml_reader :notes
  # xml_reader :profile
  # xml_reader :ingredients
  # xml_reader :examples
  def cleanup
    # nothing to do here
  end
end

class BeerXML::Recipe < Brewser::Recipe
  include ROXML
  
  xml_name "RECIPE"
  xml_convention :upcase
  xml_reader :date_created, :from => "DATE"
  xml_reader :name
  xml_reader :method, :from => "TYPE"
  
  xml_attr :style, :as => BeerXML::Style
  xml_attr :mash_schedule, :as => BeerXML::MashSchedule
  xml_attr :water_profile, :as => BeerXML::WaterProfile, :in => "WATERS"
  
  xml_reader :brewer
  
  xml_reader :display_batch_size
  xml_reader :uncast_batch_size, :from => "BATCH_SIZE"
  
  xml_reader :display_boil_size
  xml_reader :uncast_boil_size, :from => "BOIL_SIZE"
  
  xml_reader(:boil_time) { |x| "#{x} min".u }
  
  xml_reader :recipe_efficiency, :from => "EFFICIENCY", :as => Float
  xml_reader :carbonation_level, :from => "CARBONATION", :as => Float

  xml_reader(:estimated_og, :from => "EST_OG") {|x| x.to_f }
  xml_reader(:estimated_fg, :from => "EST_FG")  {|x| x.to_f }
  xml_reader(:estimated_color, :from => "EST_COLOR") {|x| x.to_f } 
  xml_reader(:estimated_ibu, :from => "IBU") {|x| x.to_f } 
  xml_reader(:estimated_abv, :from => "EST_ABV") {|x| x.to_f } 
  
  
  xml_attr :hops, :as => [BeerXML::Hop], :in => "HOPS"
  xml_attr :fermentables, :as => [BeerXML::Fermentable], :in => "FERMENTABLES"
  xml_attr :additives, :as => [BeerXML::Additive], :in => "MISCS"
  xml_attr :yeasts, :as => [BeerXML::Yeast], :in => "YEASTS"
  
  xml_reader :description, :from => "NOTES"
  
  xml_reader :primary_age, :from => "PRIMARY_AGE"
  xml_reader :display_primary_temp
  xml_reader :uncast_primary_temp, :from => "PRIMARY_TEMP"
  
  xml_reader :secondary_age, :from => "SECONDARY_AGE"
  xml_reader :display_secondary_temp
  xml_reader :uncast_secondary_temp, :from => "SECONDARY_TEMP"
  
  xml_reader :tertiary_age, :from => "TERTIARY_AGE"
  xml_reader :display_tertiary_temp
  xml_reader :uncast_teritary_temp, :from => "TERTIARY_TEMP"
  
  xml_reader :age, :from => "AGE"
  xml_reader :display_temp, :from => "DISPLAY_AGE_TEMP"
  xml_reader :uncast_age_temp, :from => "TEMP"
  
  def cleanup
    self.recipe_volume = display_batch_size.present? ? display_batch_size.u : "#{uncast_batch_size} l".u 
    self.boil_volume = display_boil_size.present? ? display_boil_size.u : "#{uncast_boil_size} l".u
    self.type = style.type || "Other"
    mash_schedule.cleanup
    hops.each(&:cleanup)
    fermentables.each(&:cleanup)
    additives.each(&:cleanup)
    yeasts.each(&:cleanup)
    current_index = 1
    self.fermentation_schedule = BeerXML::FermentationSchedule.create
    ["primary_age","secondary_age","tertiary_age","age"].each do |stage|
      if self.send(stage).present? && self.send(stage).to_i > 0
        current_step = BeerXML::FermentationStep.new
        current_step.name = stage.split("_")[0].capitalize
        current_step.purpose = current_step.name
        current_step.purpose = "Conditioning" if current_step.purpose == "Age"
        current_step.index = current_index
        current_index += 1
        current_step.time = "#{self.send(stage)} days".u
        display = "display_#{stage.gsub("age","temp")}"
        uncast = "uncast_#{stage.gsub("age","temp")}"
        current_step.temperature = self.send(display).present? ? self.send(display).u : "#{self.send(uncast)} dC".u
        self.fermentation_schedule.fermentation_steps.push current_step
      end
    end
        
  end
end
