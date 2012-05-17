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
  
  it "should parse BeerXML v1" do
    Brewser.parse(read_file('beerxmlv1/recipes')).should_not be_nil
  end
  
  # it "should parse BeerXML v2" do
  #   Brewser.parse(read_file('beerxmlv2/belgian_white')).should_not be_nil
  # end
  
end

