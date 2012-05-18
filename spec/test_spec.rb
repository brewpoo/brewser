require "spec_helper"

describe "test spec" do
  
  it "should be able to identifiy json as BrewSON" do
    Brewser.identify('{"test":"json"}').should == BrewSON
  end
  
  it "should be able to identifiy xml as BeerXML" do
    Brewser.identify(read_file('beerxmlv1/recipes')).should == BeerXML
  end
  
  it "should be able to identifiy xml as BeerXML2" do
    Brewser.identify(read_file('beerxmlv2/belgian_white')).should == BeerXML2
  end
  
  context "BeerXML v1" do
    
    before :each do
      @recipe = Brewser.parse(read_file('beerxmlv1/recipes')).first
    end
    
    it "should extract BeerXML v1 recipes" do
      @recipe.class.should == BeerXML::Recipe
    end
  
  end
  
  # it "should parse BeerXML v2" do
  #   Brewser.parse(read_file('beerxmlv2/belgian_white')).should_not be_nil
  # end
  
end

