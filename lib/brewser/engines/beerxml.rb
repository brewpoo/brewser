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
  xml_attr :name, :from => "NAME"
  xml_attr :origin, :from => "ORIGIN"
  
  xml_attr :type, :from => "TYPE"
  xml_attr :form, :from => "FORM"
  xml_attr :amount, :from => "AMOUNT"
  
  xml_attr :use, :from => "USE"
  xml_attr :time, :from => "TIME"
  
  xml_attr :alpha, :from => "ALPHA", :as => Float
  xml_attr :beta, :from => "BETA", :as => Float
  xml_attr :humulene, :from => "HUMULENE", :as => Float
  xml_attr :caryophyllene, :from => "CARYOPHYLLENE", :as => Float
  xml_attr :cohumulone, :from => "COHUMULONE", :as => Float
  xml_attr :myrcene, :from => "MYRCENE", :as => Float
  xml_attr :hsi, :from => "HSI", :as => Float
  
  xml_attr :notes, :from => "NOTES"
  xml_attr :substitutes, :from => "SUBSTITUTES"
end

class BeerXML::Fermentable < Brewser::Fermentable
  include ROXML
  
  xml_name "FERMENTABLE"
  xml_attr :name, :from => "NAME"
  xml_attr :origin, :from => "ORIGIN"
  xml_attr :supplier, :from => "SUPPLIER"
  xml_attr :type, :from => "TYPE"

  xml_attr :amount, :from => "AMOUNT"
  xml_attr :yield, :from => "YIELD"
  xml_attr :color, :from => "COLOR"
  
  xml_attr :add_after_boil, :from => "ADD_AFTER_BOIL"
  xml_attr :recommend_mash, :from => "RECOMMEND_MASH"
  
  xml_attr :max_in_batch, :from => "MAX_IN_BATCH", :as => Float
  xml_attr(:diastic_power, :from => "DIASTATIC_POWER") {|x| x.to_f }
  xml_attr(:moisture, :from => "MOISTURE") {|x| x.to_f }
  xml_attr(:coarse_fine_diff, :from => "COARSE_FINE_DIFF") {|x| x.to_f }
  xml_attr(:protein, :from => "PROTEIN") {|x| x.to_f }
  xml_attr(:ibu_gal_per_lb, :from => "IBU_GAL_PER_LB") {|x| x.to_f }
  
  xml_attr :notes, :from => "NOTES"
end

class BeerXML::Additive < Brewser::Additive
  include ROXML
  
  xml_name "MISC"
  xml_attr :name, :from => "NAME"
  xml_attr :origin, :from => "ORIGIN"
  
  xml_attr :type, :from => "TYPE"
  xml_attr :form, :from => "FORM"
  
  xml_reader :amount_scalar, :from => "AMOUNT"
  xml_reader :weight?, :from => "AMOUNT_IS_WEIGHT"
    
  xml_attr :added_when, :from => "USE"
  xml_attr :use_for, :from => "USE_FOR"
  xml_attr :time, :from => "TIME"
  
  xml_attr :description, :from => "NOTES"
  
  def amount
    units = weight? ? "kg" : "l"
    return amount_scalar.u * units.u
  end
  
end

class BeerXML::Yeast < Brewser::Yeast
  include ROXML
  
  xml_name "YEAST"
  xml_attr :name, :from => "NAME"
  xml_attr :supplier, :from => "LABORATORY"
  xml_attr :product_id, :from => "PRODUCT_ID"
  
  xml_attr :type, :from => "TYPE"
  xml_attr :form, :from => "FORM"
  xml_reader :amount_scalar, :from => "AMOUNT"
  xml_reader :weight?, :from => "AMOUNT_IS_WEIGHT"
    
  xml_attr :min_temperature, :from => "MIN_TEMPERATURE"
  xml_attr :max_temperature, :from => "MAX_TEMPERATURE"
  
  xml_attr :flocculation, :from => "FLOCCULATION"
  xml_attr :attenuation, :from => "ATTENUATION", :as => Float
  xml_attr :best_for, :from => "BEST_FOR"
  xml_attr :add_to_secondary, :from => "ADD_TO_SECONDARY"

  xml_attr :time_cultured, :from => "TIMES_CULTURED"
  xml_attr :max_reuse, :from => "MAX_REUSE"

  xml_attr :description, :from => "NOTES"
    
  def amount
    units = weight? ? "kg" : "l"
    return amount_scalar.u * units.u
  end
  
end

class BeerXML::MashStep < Brewser::MashStep
  include ROXML
  
  xml_name "MASH_STEP"
  xml_attr :name, :from => "NAME"
  xml_attr :description, :from => "DESCRIPTION"
  
  xml_attr :purpose, :from => "PURPOSE"
  xml_attr :step_type, :from => "TYPE"
  
  xml_attr :step_time, :from => "STEP_TIME"
  xml_attr :rest_temperature, :from => "STEP_TEMP"
  
  xml_attr :notes, :from => "NOTES"
end

class BeerXML::MashSchedule < Brewser::MashSchedule
  include ROXML
  
  xml_name "MASH"
  xml_attr :name, :from => "NAME"
  xml_attr :notes, :from => "NOTES"
  xml_attr :mash_steps, :as => [BeerXML::MashStep], :in => "MASH_STEPS"
end

class BeerXML::FermentationStep < Brewser::FermentationStep
  include ROXML
  
  xml_name "MASH_STEP"
  xml_attr :name, :from => "NAME"
  xml_attr :description, :from => "DESCRIPTION"
  
  xml_attr :purpose, :from => "PURPOSE"
  xml_attr :step_type, :from => "TYPE"
  
  xml_attr :step_time, :from => "STEP_TIME"
  xml_attr :rest_temperature, :from => "STEP_TEMP"
  
  xml_attr :notes, :from => "NOTES"
end

class BeerXML::FermentationSchedule < Brewser::FermentationSchedule
  include ROXML
  
  xml_name "RECIPE" # Fermentation data is stored at the recipe level in v1
  
end

class BeerXML::WaterProfile < Brewser::WaterProfile
  include ROXML
  
  xml_name "WATER"
  xml_attr :name, :from => "NAME"
  xml_attr(:calcium, :from => "CALCIUM") {|x| x.to_f }
  xml_attr(:magnesium, :from => "MAGNESIUM") {|x| x.to_f }
  xml_attr(:sodium, :from => "SODIUM") {|x| x.to_f }
  xml_attr(:chloride, :from => "CHLORIDE") {|x| x.to_f }
  xml_attr(:sulfates, :from => "SULFATES") {|x| x.to_f }
  xml_attr(:bicarbonate, :from => "BICARBONATE") {|x| x.to_f }
  xml_attr(:alkalinuty, :from => "ALKALINITY") {|x| x.to_f }
  xml_attr(:ph, :from => "PH") {|x| x.to_f }
  xml_attr :notes, :from => "NOTES"
end


class BeerXML::Style < Brewser::Style
  include ROXML
  
  xml_name "STYLE"
  xml_attr :name, :from => "NAME"
  xml_attr :category, :from => "CATEGORY"
  xml_attr :category_number, :from => "CATEGORY_NUMBER"
  xml_attr :style_letter, :from => "STYLE_LETTER"
  xml_attr :style_guide, :from => "STYLE_GUIDE"
  xml_attr :type, :from => "TYPE"
  xml_attr :og_min, :from => "OG_MIN"
  xml_attr :og_max, :from => "OG_MAX"
  xml_attr :fg_min, :from => "FG_MIN"
  xml_attr :fg_max, :from => "FG_MAX"
  xml_attr :ibu_min, :from => "IBU_MIN"
  xml_attr :ibu_max, :from => "IBU_MAX"
  xml_attr :color_min, :from => "COLOR_MIN"
  xml_attr :color_max, :from => "COLOR_MAX"
  
  xml_attr :carb_min, :from => "CARB_MIN"
  xml_attr :carb_max, :from => "CARB_MAX"
  xml_attr :abv_min, :from => "ABV_MIN"
  xml_attr :abv_max, :from => "ABC_MAX"
  
  xml_attr :notes, :from => "NOTES"
  xml_attr :profile, :from => "PROFILE"
  xml_attr :ingredients, :from => "INGREDIENTS"
  xml_attr :examples, :from => "EXAMPLES"
end

class BeerXML::Recipe < Brewser::Recipe
  include ROXML
  
  xml_name "RECIPE"
  xml_attr :date_created, :from => "DATE"
  xml_attr :name, :from => "NAME"
  xml_attr :type, :from => "TYPE"
  xml_attr :style, :as => BeerXML::Style
  
  xml_attr :mash_schedule, :as => BeerXML::MashSchedule
  # xml_attr :fermentation_schedule, :as => BeerXML::FermentationSchedule
  xml_attr :water_profile, :as => BeerXML::WaterProfile, :in => "WATERS"
  
  xml_attr :brewer, :from => "BREWER"
  xml_attr :assistant, :from => "ASST_BREWER"
  
  xml_attr :recipe_volume, :from => "BATCH_SIZE", :as => Float
  xml_attr :boil_volume, :from => "BOIL_SIZE", :as => Float
  xml_attr :boil_time, :from => "BOIL_TIME", :as => Integer
  xml_attr :recipe_efficiency, :from => "RECIPE_EFFICIENCY", :as => Float
  xml_attr :carbonation_level, :from => "CARBONATION", :as => Float

  xml_attr(:estimated_og, :from => "EST_OG") {|x| x.to_f }
  xml_attr(:estimated_fg, :from => "EST_FG")  {|x| x.to_f }
  xml_attr(:estimated_color, :from => "EST_COLOR") {|x| x.to_f } 
  xml_attr(:estimated_ibus, :from => "IBU") {|x| x.to_f } 
  
  xml_attr :hops, :as => [BeerXML::Hop], :in => "HOPS"
  xml_attr :fermentables, :as => [BeerXML::Fermentable], :in => "FERMENTABLES"
  xml_attr :additives, :as => [BeerXML::Additive], :in => "MISCS"
  xml_attr :yeasts, :as => [BeerXML::Yeast], :in => "YEASTS"
  
  xml_attr :notes, :from => "NOTES"
end

