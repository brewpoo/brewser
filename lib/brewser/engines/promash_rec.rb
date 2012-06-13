class ProMashRec < Brewser::Engine
  
  class << self
    
    def acceptable?(q)
      return true
    end
  
    def deserialize(io)
      object = ProMashRec::Recipe.new
      object.from_promash(io)
      return object
    end
    
  end
  
  module ::Loader
    
    require 'bindata'
    
    class RecEntry < BinData::Record
      endian :little
    end
  
    class Hop < RecEntry
      string :name, :length => 55, :trim_padding => true
      float :alpha_acids
      float :beta_acids
      int8 :noble
      float :cohumulone
      float :myrcene
      float :humulene
      float :caryphylene
      int8 :type
      int8 :form
      float :storage_factor
      string :taste_notes, :length => 155, :trim_padding => true
      string :origin, :length => 55, :trim_padding => true
      string :best_for, :length => 155, :trim_padding => true
      string :substitutes, :length => 155, :trim_padding => true
      skip length: 10
      float :storage_temp_c
      float :actual_alpha_acids
      int8 :flag
      float :amount
      int16 :time
      float :ibus
    end
    
    class Fermentable < RecEntry
      string :name, :length => 110, :trim_padding => true
      string :origin, :length => 55, :trim_padding => true
      int8 :type
      int8 :form
      float :potential
      float :color
      float :moisture_content
      float :max_in_batch
      float :diastatic_power
      float :percent_protein
      float :percent_tsn
      string :uses, :length => 155, :trim_padding => true
      string :comments, :length => 155, :trim_padding => true
      skip length: 8
      float :dry_basis_fg
      float :dry_basis_cg
      float :amount
      float :extract
    end
    
    class Additive < RecEntry
      string :name, :length => 55, :trim_padding => true
      int8 :type
      int16 :time
      skip length: 2
      int8 :added_when
      int8 :time_in
      int8 :amount_unit
      skip length: 4
      string :uses, :length => 255, :trim_padding => true
      string :comments, :length => 255, :trim_padding => true
      float :amount
      skip length: 8
    end
    
    class Yeast < RecEntry
      string :name, :length => 55, :trim_padding => true
      string :supplier, :length => 55, :trim_padding => true
      string :catalog, :length => 26, :trim_padding => true
      string :flavor_note, :length => 155, :trim_padding => true
      string :comment, :length => 155, :trim_padding => true
      skip length: 9
      int32 :aa_high
      int32 :aa_low
      float :optimum_temp
      skip length: 6
    end
    
    class WaterProfile < RecEntry
      string :name, :length => 27, :trim_padding => true
      float :calcium
      float :magnesium
      float :sodium
      float :unknown
      float :sulfate
      float :chloride
      float :bicarbonate
      float :ph
      string :comments, :length => 155, :trim_padding => true
      skip length: 8
    end
    
    class MashStep < RecEntry
    end
    
    class MashSchedule < RecEntry
      skip length: 9 # Probably indicates complex mash sch, etc
      int32 :acid_rest_temp
      int32 :acid_rest_time
      int32 :protein_rest_temp
      int32 :protein_rest_time
      int32 :int_rest_temp
      int32 :int_rest_time
      int32 :sac_rest_temp
      int32 :sac_rest_time
      int32 :mash_out_temp
      int32 :mash_out_time
      int32 :sparge_temp
      int32 :sparge_time
      float :mash_volume
      skip length: 1
    end
    
    class Style < RecEntry
      string :category, :length => 55, :trim_padding => true
      string :sub_category, :length => 55, :trim_padding => true
      int8 :_type
      float :min_og
      float :max_og
      float :min_fg
      float :max_fg
      float :min_abv
      float :max_abv
      float :min_ibu
      float :max_ibu
      float :min_color
      float :max_color
      string :color_note, :length => 155, :trim_padding => true
      string :malt_note, :length => 155, :trim_padding => true
      string :hop_note, :length => 155, :trim_padding => true
      string :yeast_note, :length => 155, :trim_padding => true
      string :examples, :length => 255, :trim_padding => true
      int16 :category_number
      string :sub_category_letter, :length => 2, :trim_padding => true
      int8 :_guideline
    end
    
    class Recipe < RecEntry
      string :title, :length => 85, :trim_padding => true
      int32 :_hops_count
      int32 :_fermentables_count
      int32 :_additives_count
      float :recipe_volume
      float :boil_volume
      float :estimated_og
      float :estimated_ibu
      float :recipe_efficiency
      int32 :boil_time
      int32 :_recipe_type
      int8 :_brew_method
      style :style
      array :hops, :type => :hop, :initial_length => :_hops_count
      array :fermentables, :type => :fermentable, :initial_length => :_fermentables_count
      array :additives, :type => :additive, :initial_length => :_additives_count
      yeast :yeast
      water_profile :water_profile
      mash_schedule :mash_schedule
      string :notes, :length => 4028, :trim_padding => true
      string :awards, :lengh => 4028, :trim_padding => true
    end
  end
  
end


class ProMashRec::Hop < Brewser::Hop

  @@hop_types = {0 => "Both", 1 => "Bittering", 2 => "Aroma"}
  @@hop_forms = {1 => "Whole", 3 => "Whole",  21 => "Pellet", 23 => "Pellet", 11 => "Plug"}
  
  # Pellet 21, 23
  def from_promash(hop,time)
    self.name = hop.name.split("\x00")[0]
    self.origin = hop.origin.split("\x00")[0]
    self.alpha_acids = hop.alpha_acids
    self.beta_acids = hop.beta_acids
    self.type = @@hop_types[hop.type]
    self.form = @@hop_forms[hop.form]
    self.amount = "#{hop.amount} oz".u
    self.time = "#{hop.time} min".u
    self.storageability = hop.storage_factor
    self.humulene = hop.humulene
    self.caryophyllene = hop.caryphylene
    self.cohumulone = hop.cohumulone
    self.myrcene = hop.myrcene
    if hop.time.to_i >= 0 and hop.time.to_i <= time
      self.added_when = "Boil"
    elsif hop.time.to_i == time+1
      self.added_when = "FWH"
    elsif hop.time.to_i == time+2
      self.added_when = "Mash"
    else
      self.added_when = "Dry"
    end
    
    return self
  end

end

class ProMashRec::Fermentable < Brewser::Fermentable

  @@ferm_types = {0 => { 0 => "Grain", 1 => "Dry Extract", 2 => "Sugar", 3 => "Adjunct"},
                  1 => { 0 => "Grain", 1 => "Extract", 2 => "Sugar", 3 => "Adjunct"}}

  def from_promash(ferm)
    self.name = ferm.name.split("\x00")[0]
    self.origin = ferm.origin.split("\x00")[0]
    self.type = @@ferm_types[ferm.form][ferm.type]
    self.potential = ferm.potential.round(3)
    self.color = ferm.color
    self.amount = "#{ferm.amount} lbs".u
    self.diastatic_power = ferm.diastatic_power
    self.max_in_batch = ferm.max_in_batch
    self.moisture = ferm.moisture_content
    
    return self
  end

end

class ProMashRec::Additive < Brewser::Additive
  
  @@additive_types = { 0 => "Spice", 1 => "Fruit", 2 => "Flavor", 3 => "Other", 4 => "Fining", 5 => "Herb" }
  @@added_whens = { 0 => "Boil", 1 => "Primary", 2 => "Mash" }
  @@additive_unit = { 0 => "oz", 1 => "g", 2 => "lb", 3 => "tsp", 4 => "tbsp", 5 => "cups", 6 => "each" }
  @@additive_time = { 0 => "days", 1 => "min" }
  
  def from_promash(add)
    self.name = add.name.split("\x00")[0]
    self.type = @@additive_types[add.type]
    self.added_when = @@added_whens[add.added_when]
    self.time = "#{add.time} #{@@additive_time[add.time_in]}".u
    self.amount = "#{add.amount} #{@@additive_unit[add.amount_unit]}".u
    self.use_for = add.uses
    
    return self
  end

end

class ProMashRec::Yeast < Brewser::Yeast

  def from_promash(y)
    self.name = y.name.split("\x00")[0]
    self.supplier = y.supplier
    self.catalog = y.catalog
    self.attenuation = (y.aa_high + y.aa_low)/2
    self.min_temperature = self.max_temperature = "#{y.optimum_temp} dF".u
    self.description = y.comment
    self.amount = "1 each".u
    
    return self
  end

end

class ProMashRec::MashStep < Brewser::MashStep
  
  # Only supporting "simple" mash schedule
end

class ProMashRec::MashSchedule < Brewser::MashSchedule
  
  def from_promash(mash)
    # TODO finish this
    return nil
  end
  
end

class ProMashRec::FermentationStep < Brewser::FermentationStep
  # Not support in ProMash REC files
end

class ProMashRec::FermentationSchedule < Brewser::FermentationSchedule 
  # Not supported in ProMash REC files
end

class ProMashRec::WaterProfile < Brewser::WaterProfile

  def from_promash(water)
    self.name = water.name.split("\x00")[0]
    self.calcium = water.calcium
    self.magnesium = water.magnesium
    self.sodium = water.sodium
    self.chloride = water.chloride
    self.sulfates = water.sulfate
    self.bicarbonate = water.bicarbonate
    self.ph = water.ph.round(2)
    
    return self
  end

end

class ProMashRec::Style < Brewser::Style

  @@style_guides = { 0 => "AHA", 1 => "BJCP" }
  @@style_types = { 0 => "Ale", 1 => "Lager", 2 => "Cider", 3 => "Mead", 5 => "Hybrid"}
  
  def from_promash(style)
    self.name = style.sub_category.split("\x00")[0]
    self.category = style.category.split("\x00")[0]
    self.category_number = style.category_number
    self.style_letter = style.sub_category_letter
    self.style_guide = @@style_guides[style._guideline]
    self.type = @@style_types[style._type]
    self.og_min = style.min_og
    self.og_max = style.max_og
    self.fg_min = style.min_fg
    self.fg_max = style.max_fg
    self.ibu_min = style.min_ibu
    self.ibu_max = style.max_ibu
    self.color_min = style.min_color
    self.color_max = style.max_color
    self.examples = style.examples
    
    return self
  end

end

class ProMashRec::Recipe < Brewser::Recipe
  
  @@recipe_types = { 0 => "Other", 15 => "Lager", 25 => "Hybrid", 30 => "Ale" }
  @@brew_methods = { 0 => "All Grain", 1 => "Partial Mash", 2 => "Extract" }
  
  def from_promash(data)
    rec = Loader::Recipe.read(data)
    self.name = rec.title.split("\x00")[0]
    self.method = @@brew_methods[rec._brew_method]
    self.recipe_volume = "#{rec.recipe_volume} gal".u
    self.boil_volume = "#{rec.boil_volume} gal".u
    self.boil_time = "#{rec.boil_time} min".u
    self.estimated_og = (1+rec.estimated_og/1000).round(3)
    self.estimated_ibu = rec.estimated_ibu.round(1)
    self.recipe_efficiency = rec.recipe_efficiency*100
    self.style = ProMashRec::Style.new.from_promash(rec.style)
    rec.hops.each do |hop|
      self.hops.push ProMashRec::Hop.new.from_promash(hop,rec.boil_time.to_i)
    end
    rec.fermentables.each do |fermentable|
      self.fermentables.push ProMashRec::Fermentable.new.from_promash(fermentable)
    end
    rec.additives.each do |additive|
      self.additives.push ProMashRec::Additive.new.from_promash(additive)
    end
    self.yeasts.push ProMashRec::Yeast.new.from_promash(rec.yeast)
    self.water_profile = ProMashRec::WaterProfile.new.from_promash(rec.water_profile)
    self.mash_schedule = ProMashRec::MashSchedule.new.from_promash(rec.mash_schedule)
    self.description = rec.notes
    self.type = self.style.type
    
    return self
  end

end
