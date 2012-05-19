require "spec_helper"

describe "BeerXML tests" do

  context "BeerXML v1" do
    
    before :each do
      @recipe = Brewser.parse(read_file('beerxmlv1/recipes')).first
    end
    
    it "should deserialize the base recipe data" do
      @recipe.name.should == "Burton Ale"
      @recipe.brewer.should == "Brad Smith"
      @recipe.type.should == "All Grain"
      
      @recipe.recipe_volume.class.should == Unit
      @recipe.recipe_volume.kind.should == :volume
      @recipe.recipe_volume.scalar_in('gal').should be_within(0.01).of(5)
      
      @recipe.boil_volume.class.should == Unit
      @recipe.boil_volume.kind.should == :volume
      @recipe.boil_volume.scalar_in('gal').should be_within(0.01).of(5.5)
      
      @recipe.boil_time.class.should == Unit
      @recipe.boil_time.kind.should == :time
      @recipe.boil_time.should == "60 min".u
      
      @recipe.recipe_efficiency == 75.0
      
      @recipe.estimated_og.should == 1.056
      @recipe.estimated_fg.should == 1.015
      @recipe.estimated_color.should == 7.0
      @recipe.estimated_ibu.should == 32.4
      @recipe.estimated_abv.should == 5.3
    end
    
    it "should deserialize the hop data" do
      @recipe.hops.count.should == 4
      h=@recipe.hops[1]
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
      @recipe.fermentables.count.should == 3
      f=@recipe.fermentables[0]
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
      f.recommend_mash.should == false
      f.max_in_batch.should == 100.0
      f.ibu_gal_per_lb.should == 0.0
    end
    
    it "should deserialize the additive data" do
      @recipe.additives.count.should == 2
      a=@recipe.additives[0]
      a.name.should == "Irish Moss"
      a.type.should == "Fining"
      a.description.should_not be_nil
      a.added_when.should == "Boil"
      a.amount.should == "0.25 tsp".u
      a.time.should == "10 min".u
    end
    
    it "should deserialize the yeast data" do
      @recipe.yeasts.count.should == 1
      y=@recipe.yeasts.first
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
      m=@recipe.mash_schedule
      m.name.should == "Single Infusion, Full Body"
      m.grain_temp.should == "72 dF".u
      m.sparge_temp.should == "168 dF".u
    end
    
    it "should deserialize the mash step data" do
      m=@recipe.mash_schedule
      m.mash_steps.count.should == 2
      s=m.mash_steps.first
      s.name.should == "Mash In"
      s.type.should == "Infusion"
      s.description.should_not be_nil
      s.rest_time.should == "45 min".u
      s.rest_temperature.should == "70 dC".u
      s.infusion_volume.should == "11.25 qt".u
      s.infusion_temperature.should == "170.5 dF".u
      s.water_to_grain_ratio.should == 1.25
    end

    it "should deserialize the water profile data" do
      w=@recipe.water_profile
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
      s=@recipe.style
      s.name.should == "English Pale Ale"
      s.category.should == "Bitter & English Pale Ale"
      s.style_letter.should == "A"
      s.style_guide.should == "BJCP 1999"
      s.type.should == "Ale"
      s.notes.should_not be_nil
      s.profile.should_not be_nil
      s.ingredients.should_not be_nil
      s.examples.should_not be_nil
      s.og_min.should == 1.043
      s.og_max.should == 1.060
      s.fg_min.should == 1.010
      s.fg_max.should == 1.020
      s.ibu_min.should == 20.0
      s.ibu_max.should == 40.0
      s.color_min.should == 6.0
      s.color_max.should == 12.0
      s.carb_min.should == 1.5
      s.carb_max.should == 2.4
      s.abv_min.should == 4.5
      s.abv_max.should == 5.5
    end
  end
end
