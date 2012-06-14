require "spec_helper"

describe "ProMashTxt tests" do

  context "ProMashTxt" do
    
    before :each do
      @recipe = Brewser.parse(read_file('promash/VictoryIPA.txt'))
    end
    
    it "should deserialize the base recipe data" do
      @recipe.class.should == ProMashTxt::Recipe
      @recipe.name.should == "Victory IPA"
      @recipe.method.should == "All Grain"
      
      @recipe.recipe_volume.class.should == Unit
      @recipe.recipe_volume.kind.should == :volume
      @recipe.recipe_volume.scalar_in('gal').should be_within(0.01).of(6)
      
      @recipe.boil_volume.class.should == Unit
      @recipe.boil_volume.kind.should == :volume
      @recipe.boil_volume.scalar_in('gal').should be_within(0.01).of(6)
      
      @recipe.recipe_efficiency.should == 80.0
      
      @recipe.boil_time.class.should == Unit
      @recipe.boil_time.kind.should == :time
      @recipe.boil_time.should == "60 min".u
      
      @recipe.estimated_og.should == 1.059
      @recipe.estimated_color.should == 11.0
      @recipe.estimated_ibu.should == 53.5
    end
    
    it "should deserialize the hop data" do
         @recipe.hops.count.should == 4
         h=@recipe.hops[0]
         h.name.should == "Cascade"
         h.alpha_acids.should == 4.35
         h.amount.should === "3 oz".u
         h.added_when.should == "Boil"
         h.time.should === "60 min".u
         h.form.should == "Whole"
       end
    
    it "should deserialize the fermentable data" do
      @recipe.fermentables.count.should == 6
      f=@recipe.fermentables[0]
      f.name.should == "Pale Malt(2-row)"
      f.amount.should === "8 lb".u
      f.potential.should == 1.038
      f.color.should == 3.0
    end
    
    it "should deserialize the additive data" do
      @recipe.additives.count.should == 1
      a=@recipe.additives[0]
      a.name.should == "Irish Moss"
      a.type.should == "Fining"
      a.added_when.should == "Boil"
      a.amount.should == "1 tsp".u
      a.time.should == "15 min".u
    end
    
    it "should deserialize the water profile data" do
      w=@recipe.water_profile
      w.name.should == "Marin Tap Water"
      w.calcium.should == 12.0
      w.bicarbonate.should == 74.0
      w.sulfates.should == 17.0
      w.chloride.should == 13.0
      w.sodium.should == 15.0
      w.magnesium.should == 10.0
      w.ph.should == 8.31
    end

    it "should deserialize the style data" do
      s=@recipe.style
      s.name.should == "India Pale Ale"
      s.category.should == "India Pale Ale"
      s.style_letter.should == "0"
      s.style_guide.should == "AHA"
    end
  end
  

end
