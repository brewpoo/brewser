require "spec_helper"

describe "BrewSON spec" do
  
  before :each do
    @recipe = Brewser.parse(read_file('beerxmlv1/recipes.xml')).first
  end
  
  it "should generate JSON" do
    json = BrewSON.serialize(@recipe)
    json.valid_json?.should be_true
  end
  
  context "round trip" do
    
    before :each do
      json = @recipe.to_json
      @return = Brewser.parse(json)
    end
    
    it "should survive the round trip" do
      @return.class.should == Brewser::Recipe
      @return.name.should == "Burton Ale"
      @return.style.name.should == "English Pale Ale"
    end
    
    it "should deserialize the base recipe data" do
      @return.name.should == "Burton Ale"
      @return.brewer.should == "Brad Smith"
      @return.method.should == "All Grain"
      @return.type.should == "Ale"
      
      @return.recipe_volume.class.should == Unit
      @return.recipe_volume.kind.should == :volume
      @return.recipe_volume.scalar_in('gal').should be_within(0.01).of(5)
      
      @return.boil_volume.class.should == Unit
      @return.boil_volume.kind.should == :volume
      @return.boil_volume.scalar_in('gal').should be_within(0.01).of(5.5)
      
      @return.boil_time.class.should == Unit
      @return.boil_time.kind.should == :time
      @return.boil_time.should == "60 min".u
      
      @return.recipe_efficiency.should == 72.0
      
      @return.estimated_og.should == 1.056
      @return.estimated_fg.should == 1.015
      @return.estimated_color.should == 7.0
      @return.estimated_ibu.should == 32.4
      @return.estimated_abv.should == 5.3
    end
    
    it "should deserialize the hop data" do
      @return.hops.count.should == 4
      h=@return.hops[1]
      h.name.should == "Northern Brewer"
      h.origin.should == "Germany"
      h.alpha_acids.should == 7.5
      h.amount.should === "0.50 oz".u
      h.added_when.should == "Boil"
      h.time.should === "60 min".u
      h.description.should_not be_nil
      h.type.should == "Both"
      h.form.should == "Pellet"
      h.beta_acids.should == 4.0
      h.storageability.should == 35.0
    end
    
    it "should deserialize the fermentable data" do
      @return.fermentables.count.should == 3
      f=@return.fermentables[0]
      f.name.should == "Pale Malt (2 Row) UK"
      f.origin.should == "United Kingdom"
      f.type.should == "Grain"
      f.description.should_not be_nil
      f.amount.should === "8 lb".u
      f.potential.should == 1.036
      f.color.should == 2.5
      f.moisture.should == 4.0
      f.diastatic_power.should == 45.0
      f.protein.should == 10.1
      f.late_addition.should == false
      f.recommend_mash?.should == false
      f.max_in_batch.should == 100.0
      f.ibu_gal_per_lb.should == 0.0
    end
    
    it "should deserialize the additive data" do
      @return.additives.count.should == 2
      a=@return.additives[0]
      a.name.should == "Irish Moss"
      a.type.should == "Fining"
      a.description.should_not be_nil
      a.added_when.should == "Boil"
      a.amount.should == "0.25 tsp".u
      a.time.should == "10 min".u
    end
    
    it "should deserialize the yeast data" do
      @return.yeasts.count.should == 1
      y=@return.yeasts.first
      y.name.should == "Burton Ale"
      y.type.should == "Ale"
      y.form.should == "Liquid"
      y.supplier.should == "White Labs"
      y.catalog.should == "WLP023"
      y.description.should_not be_nil
      y.best_for.should_not be_nil
      y.min_temperature.should == "68 dF".u
      y.max_temperature.should == "73 dF".u
      y.amount.should == "35 ml".u
      y.add_to_secondary?.should == false
      y.flocculation.should == "Medium"
      y.attenuation.should == 72.0
      y.max_reuse.should == 5
      y.times_cultured.should == 0
    end
    
    it "should deserialize the mash schedule data" do
      m=@return.mash_schedule
      m.name.should == "Single Infusion, Full Body"
      m.grain_temp.should == "72 dF".u
      m.sparge_temp.should == "168 dF".u
    end
    
    it "should deserialize the mash step data" do
      m=@return.mash_schedule
      m.mash_steps.count.should == 2
      s=m.mash_steps[0]
      s.index.should == 1
      s.name.should == "Mash In"
      s.type.should == "Infusion"
      s.description.should_not be_nil
      s.rest_time.should == "45 min".u
      s.rest_temperature.should == "70 dC".u
      s.infusion_volume.should == "11.25 qt".u
      s.infusion_temperature.should == "170.5 dF".u
      s.water_to_grain_ratio.should == 1.25
    end
    
    it "should deserialize the fermentation step data" do
      f=@return.fermentation_schedule
      f.fermentation_steps.count.should == 3
      s=f.fermentation_steps[0]
      s.index.should == 1
      s.name.should == "Primary"
      s.time.should == "4 days".u
      s.temperature.should == "68 dF".u
    end

    it "should deserialize the water profile data" do
      w=@return.water_profile
      w.name.should == "Burton On Trent, UK"
      w.description.should == "Distinctive pale ales strongly hopped.  Very hard water accentuates the hops flavor.\nExample: Bass Ale"
      w.calcium.should == 295.0
      w.bicarbonate.should == 300.0
      w.sulfates.should == 725.0
      w.chloride.should == 25.0
      w.sodium.should == 55.0
      w.magnesium.should == 45.0
      w.ph.should ==8.0
    end

    it "should deserialize the style data" do
      s=@return.style
      s.name.should == "English Pale Ale"
      s.category.should == "Bitter & English Pale Ale"
      s.style_letter.should == "A"
      s.style_guide.should == "BJCP 1999"
      s.type.should == "Ale"
    end
  end
  
  context "should deserialize json file" do
    
    before :each do
      @recipe = Brewser.parse(read_file('brewson/belgian_white.json'))
    end
    
    it "should deserialize the base recipe data" do
      @recipe.name.should == "Jeffrey's Winter White"
      @recipe.brewer.should == "Nobody"
      @recipe.method.should == "All Grain"
      @recipe.type.should == "Ale"
      
      @recipe.recipe_volume.class.should == Unit
      @recipe.recipe_volume.kind.should == :volume
      @recipe.recipe_volume.should == "5 gal".u
      
      @recipe.boil_volume.class.should == Unit
      @recipe.boil_volume.kind.should == :volume
      @recipe.boil_volume.should == "5 gal".u
      
      @recipe.boil_time.class.should == Unit
      @recipe.boil_time.kind.should == :time
      @recipe.boil_time.should == "60 min".u
      
      @recipe.recipe_efficiency.should == 75.0
      
      @recipe.estimated_og.should == 1.049
      @recipe.estimated_ibu.should == 16.3
    end
    
  end
  
end