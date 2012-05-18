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
        (outer>outer.node_name.singularize).map do |inner|
          ("BeerXML::#{inner.node_name.downcase.camelcase}".constantize).from_xml(inner)
        end
     rescue
       raise "Brewser: BeerXML encountered an issue and can not continue"
      end
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
  xml_reader :form
  
  xml_reader :display_amount
  xml_reader :uncast_amount, :from => "AMOUNT"
  
  xml_reader :display_time
  xml_reader :uncast_time
  
  xml_reader :added_when, :from => "USE"
  
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
  
  def amount
    display_amount.u || "#{uncast_amount} kg".u
  end
  
  def time
    display_time.u || "#{uncast_time} min".u
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
  xml_reader :uncast_amount
  
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
  
  def amount
    display_amount.u || "#{uncast_amount} kg".u
  end
  
  def potential
    uncast_potential.to_f || (1.046*(yield_percent/100))    
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
    
  xml_reader :added_when, :from => "USE"
  xml_reader :use_for
  
  xml_reader :display_time
  xml_reader :uncast_time, :from => "TIME"
  
  xml_reader :description, :from => "NOTES"
  
  def amount
    return display_amount.u unless display_amount.blank?
    units = weight? ? "kg" : "l"
    return amount_scalar.u * units.u
  end
  
  def time
    display_time.u || "#{time} min".u
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
    
  def amount
    return display_amount.u unless display_amount.blank?
    units = weight? ? "kg" : "l"
    return amount_scalar.u * units.u
  end
  
  def min_temperature
    disp_min_temp.u || "#{uncast_min_temperature} dC".u
  end
  
  def max_temperature
    disp_max_temp.u || "#{uncast_max_temperature} dC".u
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
  
  xml_reader :ramp_time
  xml_reader(:rest_time, :from => "STEP_TIME") { |x| "#{x} min".u }
  
  xml_reader :uncast_rest_temperature, :from => "STEP_TEMP"
  
  xml_reader :water_to_grain_ratio, :from => "WATER_GRAIN_RATIO", :as => Float
  
  xml_reader :uncast_infusion_volume, :from => "INFUSE_AMOUNT"
  xml_reader :display_infuse_amt
  
  xml_reader :uncast_infusion_temperature, :from => "INFUSE_TEMP" 
  
  def infusion_volume
    display_infuse_amt.u || "#{uncast_incustion_volume} ".u
  end
  
  def infusion_temperature
    uncast_infusion_temperature.u
  end
  
  def rest_temperature
    "#{uncast_rest_temperature} dC".u
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
  
  def grain_temp
    display_grain_temp.u || "#{uncaset_grain_temp} dC".u
  end
  
  def sparge_temp
    display_sparge_temp.u || "#{uncast_sparge_temp} dC".u
  end
end

class BeerXML::FermentationStep < Brewser::FermentationStep
  include ROXML
  
  xml_name "RECIPE"
  xml_convention :upcase
  xml_reader :primary_age
  xml_reader :primary_temp
  xml_reader :secondary_age
  xml_reader :secondary_temp
  xml_reader :tertiary_age
  xml_reader :teritary_temp
  xml_reader :age
  xml_reader :temp
  
end

class BeerXML::FermentationSchedule < Brewser::FermentationSchedule
  include ROXML
  
  xml_name "RECIPE" # Fermentation data is stored at the recipe level in v1
  xml_convention :upcase
  xml_attr :fermentation_steps, :as => [BeerXML::FermentationStep]
  
end

class BeerXML::WaterProfile < Brewser::WaterProfile
  include ROXML
  
  xml_name "WATER"
  xml_reader :name, :from => "NAME"
  xml_reader(:calcium, :from => "CALCIUM") {|x| x.to_f }
  xml_reader(:magnesium, :from => "MAGNESIUM") {|x| x.to_f }
  xml_reader(:sodium, :from => "SODIUM") {|x| x.to_f }
  xml_reader(:chloride, :from => "CHLORIDE") {|x| x.to_f }
  xml_reader(:sulfates, :from => "SULFATES") {|x| x.to_f }
  xml_reader(:bicarbonate, :from => "BICARBONATE") {|x| x.to_f }
  xml_reader(:alkalinuty, :from => "ALKALINITY") {|x| x.to_f }
  xml_reader(:ph, :from => "PH") {|x| x.to_f }
  xml_reader :description, :from => "NOTES"
end


class BeerXML::Style < Brewser::Style
  include ROXML
  
  xml_name "STYLE"
  xml_reader :name, :from => "NAME"
  xml_reader :category, :from => "CATEGORY"
  xml_reader :category_number, :from => "CATEGORY_NUMBER"
  xml_reader :style_letter, :from => "STYLE_LETTER"
  xml_reader :style_guide, :from => "STYLE_GUIDE"
  xml_reader :type, :from => "TYPE"
  xml_reader :og_min, :from => "OG_MIN"
  xml_reader :og_max, :from => "OG_MAX"
  xml_reader :fg_min, :from => "FG_MIN"
  xml_reader :fg_max, :from => "FG_MAX"
  xml_reader :ibu_min, :from => "IBU_MIN"
  xml_reader :ibu_max, :from => "IBU_MAX"
  xml_reader :color_min, :from => "COLOR_MIN"
  xml_reader :color_max, :from => "COLOR_MAX"
  
  xml_reader :carb_min, :from => "CARB_MIN"
  xml_reader :carb_max, :from => "CARB_MAX"
  xml_reader :abv_min, :from => "ABV_MIN"
  xml_reader :abv_max, :from => "ABC_MAX"
  
  xml_reader :notes, :from => "NOTES"
  xml_reader :profile, :from => "PROFILE"
  xml_reader :ingredients, :from => "INGREDIENTS"
  xml_reader :examples, :from => "EXAMPLES"
end

class BeerXML::Recipe < Brewser::Recipe
  include ROXML
  
  xml_name "RECIPE"
  xml_reader :date_created, :from => "DATE"
  xml_reader :name, :from => "NAME"
  xml_reader :type, :from => "TYPE"
  xml_reader :style, :as => BeerXML::Style
  
  xml_attr :mash_schedule, :as => BeerXML::MashSchedule
  xml_attr :fermentation_schedule, :as => BeerXML::FermentationSchedule
  xml_attr :water_profile, :as => BeerXML::WaterProfile, :in => "WATERS"
  
  xml_reader :brewer, :from => "BREWER"
  xml_reader :assistant, :from => "ASST_BREWER"
  
  xml_reader :recipe_volume, :from => "BATCH_SIZE", :as => Float
  xml_reader :boil_volume, :from => "BOIL_SIZE", :as => Float
  xml_reader :boil_time, :from => "BOIL_TIME", :as => Integer
  xml_reader :recipe_efficiency, :from => "RECIPE_EFFICIENCY", :as => Float
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
end

