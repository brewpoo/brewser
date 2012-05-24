module Brewser
  class Hop < Model
    belongs_to :recipe
    
    property :name, String, :required => true
    property :description, String, :length => 65535
    
    property :type, String, :set => ['Bittering', 'Aroma', 'Both']
    property :alpha_acids, Float, :required => true
    property :beta_acids, Float
    property :added_when, String, :set => ['Boil', 'Dry', 'Mash', 'FWH', 'Aroma', 'Hop Back', 'Infuser'], :required => true
    property :time, Time
    property :amount, Weight   
    
    property :form, String, :set => ['Pellet', 'Plug', 'Whole']
    
    property :storageability, Float
    property :origin, String, :length => 512
    property :substitutes, String, :length => 512
    property :humulene, Float
    property :caryophyllene, Float
    property :cohumulone, Float
    property :myrcene, Float
    property :farnsene, Float
    property :total_oil, Float
  end
end