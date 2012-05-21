module Brewser
  class Batch < Model
    property :brewed_on, Date
    property :batch_identifier, String
    property :brewer, String
    property :assistant_brewer, String
    property :description, String, :length => 65535

    has 1, :recipe
    validates_presence_of :recipe
    
    has 1, :system

    property :batch_status, String, :set => ["Planning", "Preparing", "Brewing", "Primary", "Secondary", 
      "Lagering", "Conditioning", "Serving", "Dispatched"]
    property :sparge_method, String, :set => ["Batch", "Fly", "No Sparge"]
    property :oxygenation_method, String, :set => ["Shake", "Splash", "Air Injection", "Oxygen Injection"]
    
    property :measured_og, Float
    property :measured_fg, Float
    property :computed_abv, Float
    
    property :computed_extract_efficiency, Float
    property :computed_brewhouse_efficiency, Float
  end

end