class ProMashTxt < Brewser::Engine
  
  class << self
    
    def acceptable?(q)
      q.match("A ProMash Recipe Report") ? true : false
    end
  
    def deserialize(string)
      object = string.match("A ProMash Recipe Report") ? ProMashTxt::Recipe.new : ProMashTxt::Batch.new
      object.from_promash(string.split("\r\n").reject{|a|a==""})
      return object
    end
    
  end
  
end

#
class ProMashTxt::Hop < Brewser::Hop
  
  def from_promash(string)
    # String should look like this:
    # 3.00 oz.    Cascade                           Whole    4.35  46.6  60 min.
    self.amount = string[0..8].strip.u
    self.name = string[14..46].strip
    self.form = string[48..55].strip
    self.alpha_acids = string[56..61].strip.to_f
    time = string[69..77].strip
    case time
    when "Dry Hop"
      self.added_when = "Dry Hop"
    when "Mash H"
      self.added_when = "Mash"
    when "First WH"
      self.added_when = "First Wort"
    else
      self.added_when = "Boil"
      self.time = time.chop.u
    end
    return self
  end
  
end

class ProMashTxt::Fermentable < Brewser::Fermentable
  
  def from_promash(string)
    # String should look like this:
    #  12.5     1.50 lbs. Victory Malt                  America        1.034     25
    self.amount = string[8..17].strip.u
    self.name = string[20..48].strip
    self.potential = string[65..70].strip
    self.color = string[74..77].strip.to_f
    return self
  end
  
end

class ProMashTxt::Additive < Brewser::Additive

  def from_promash(string)
    # String should look like this:
    #  1.00 Tsp    Irish Moss                     Fining    15 Min.(boil) 
    self.amount = string[0..10].strip.downcase.u
    self.name = string[14..44].strip
    self.type = string[45..54].strip
    self.time = string[55..61].strip.downcase.gsub(".","").u
    self.added_when = string[63..66].capitalize
    return self
  end
  
end

class ProMashTxt::Yeast < Brewser::Yeast
  
  def from_promash(string)
    self.name = string || "Unspecified"
    return self
  end
  
end

class ProMashTxt::MashStep < Brewser::MashStep
  
end

class ProMashTxt::MashSchedule < Brewser::MashSchedule
  
end

class ProMashTxt::FermentationStep < Brewser::FermentationStep
    
end

class ProMashTxt::FermentationSchedule < Brewser::FermentationSchedule 
  
end

class ProMashTxt::WaterProfile < Brewser::WaterProfile
  def from_promash(array)
    self.name = /Profile:\s*(?<name>.*)/.match(array[0]){ |m| m[:name] } || "Unspecified"
    self.calcium = /(?<calcium>\S*)\sppm$/.match(array[2]){ |m| m[:calcium] }
    self.magnesium = /(?<magnesium>\S*)\sppm$/.match(array[3]){ |m| m[:magnesium] }
    self.sodium = /(?<sodium>\S*)\sppm$/.match(array[4]){ |m| m[:sodium] }
    self.sulfates = /(?<sulfate>\S*)\sppm$/.match(array[5]){ |m| m[:sulfate] }
    self.chloride = /(?<chloride>\S*)\sppm$/.match(array[6]){ |m| m[:chloride] }
    self.bicarbonate = /(?<bicarbonate>\S*)\sppm$/.match(array[7]){ |m| m[:bicarbonate] }
    self.ph = /(?<ph>\S*)$/.match(array[8]){ |m| m[:ph] }
    return self
  end

end

class ProMashTxt::Style < Brewser::Style

  def from_promash(array)
    if pointer = array.index("BJCP Style and Style Guidelines")
      self.style_guide = "BJCP"
    elsif pointer = array.index("AHA Style and Style Guidelines")
      self.style_guide = "AHA"
    else
      raise "ProMashTxt: Unable to find style guideline"
    end
    # Line @ pointer should look like this:
    # 06-B  American Pale Ales, American Amber Ale    
    match_data = /^(?<category_number>\d{2})-(?<style_letter>\w{1})\s*(?<category>(\w\s*)+)\,\s(?<name>(\w\s*)+)/.match(array[pointer+2])
    if match_data
      self.name = match_data[:name]
      self.category = match_data[:category]
      self.category_number = match_data[:category_number]
      self.style_letter = match_data[:style_letter]
    else
      raise "ProMashTxt: Unable to extract style details"
    end
    return self
  end
  
end

class ProMashTxt::Recipe < Brewser::Recipe

  def from_promash(array)
    self.name=array[0]
    self.style=ProMashTxt::Style.new.from_promash(array)
    # Recipe specifics should look like this:
    # Recipe Specifics
    # ----------------
    # Batch Size (Gal):         6.00    Wort Size (Gal):    6.00
    # Total Grain (Lbs):       12.00
    # Anticipated OG:          1.059    Plato:             14.52
    # Anticipated SRM:          11.0
    # Anticipated IBU:          53.5
    # Brewhouse Efficiency:       80 %
    # Wort Boil Time:             60    Minutes
    # Can't tell the difference between P/M and A/G so use A/G
    raise "ProMashTxt: Unable to find recipe specifics" unless pointer = array.index("Recipe Specifics")
    self.type = /Total Grain/.match(array[pointer+3]).nil? ? "Extract" : "All Grain"
    /Batch Size \((?<volume_unit>\w+)\):\s*(?<batch_size>\S*)\s*Wort Size \(\w*\):\s*(?<boil_size>\S*)/.match(array[pointer+2]) do |match|
      self.recipe_volume = "#{match[:batch_size]} #{match[:volume_unit].downcase}".u
      self.boil_volume = "#{match[:boil_size]} #{match[:volume_unit].downcase}".u
    end
    /Anticipated OG:\s*(?<anticipated_og>\S*)/.match(array[pointer+4]) do |match|
      self.estimated_og = match[:anticipated_og].to_f
    end
    /Anticipated SRM:\s*(?<anticipated_color>\S*)/.match(array[pointer+5]) do |match|
      self.estimated_color = match[:anticipated_color].to_f
    end
    /Anticipated IBU:\s*(?<anticipated_ibu>\S*)/.match(array[pointer+6]) do |match|
      self.estimated_ibu = match[:anticipated_ibu].to_f
    end
    if type == "All Grain"
      /Brewhouse Efficiency:\s*(?<recipe_efficiency>\S*)/.match(array[pointer+7]) do |match|
        self.recipe_efficiency = match[:recipe_efficiency].to_f
      end
      boil_time_pointer = pointer+8
    else
      boil_time_pointer = pointer+7
    end
    /Wort Boil Time:\s*(?<boil_time>\S*)/.match(array[boil_time_pointer]) do |match|
      self.boil_time = "#{match[:boil_time]} min".u
    end
    
    hops_start = array.index("Hops")+3
    hops_end = (array.index("Extras") || array.index("Yeast"))-1
    array[hops_start..hops_end].each do |hop|
      self.hops.push ProMashTxt::Hop.new.from_promash(hop)
    end
    
    fermentables_start = array.index("Grain/Extract/Sugar")+3
    fermentables_end = array.index("Hops")-2
    array[fermentables_start..fermentables_end].each do |fermentable|
      self.fermentables.push ProMashTxt::Fermentable.new.from_promash(fermentable)
    end
    
    unless array.index("Extras").nil?
      additives_start = array.index("Extras")+3
      additives_end = array.index("Yeast")-1
      array[additives_start..additives_end].each do |additive|
        self.additives.push ProMashTxt::Additive.new.from_promash(additive)
      end
    end
    
    self.yeasts.push ProMashTxt::Yeast.new.from_promash(array[array.index("Yeast")+2])
    self.water_profile = ProMashTxt::WaterProfile.new.from_promash(array[array.index("Water Profile")+2,array.index("Water Profile")+10])
    
    return self
  end
  
end