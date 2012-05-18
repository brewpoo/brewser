require "spec_helper"

describe "Basic spec" do
  
  it "should be able to identifiy json as BrewSON" do
    Brewser.identify('{"test":"json"}').should == BrewSON
  end
  
  it "should be able to identifiy xml as BeerXML" do
    Brewser.identify(read_file('beerxmlv1/recipes')).should == BeerXML
  end
  
  it "should be able to identifiy xml as BeerXML2" do
    Brewser.identify(read_file('beerxmlv2/belgian_white')).should == BeerXML2
  end
  
  it "should raise an error if it cannot identify content" do
    lambda { Brewser.identify("Some unknown content") }.should raise_error
  end
  
  context "BeerXML v1" do
    
    it "should extract multiple recipes" do
      recipes = Brewser.parse(read_file('beerxmlv1/recipes'))
      recipes.count.should == 4
      recipes.first.class.should == BeerXML::Recipe
    end
    
    it "should raise an error when encountered" do
      lambda { Brewser.parse(read_file('beerxmlv1/broken')) }.should raise_error
    end
  
  end  
end

