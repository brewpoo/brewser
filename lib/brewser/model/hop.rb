module Brewser
  class Hop < Model
    property :name, String, :required => true
    property :alpha, Float, :required => true
    property :amount, Weight, :required => true
    property :use, String, :set => ['Boil', 'Dry Hop', 'Mash', 'First Wort', 'Aroma'], :required => true
    property :time, Time, :required => true

    property :notes, String, :length => 65535
    property :type, String, :set => ['Bittering', 'Aroma', 'Both']
    property :form, String, :set => ['Pellet', 'Plug', 'Leaf']
    property :beta, Float
    property :hsi, Float
    property :origin, String, :length => 512
    property :substitutes, String, :length => 512
    property :humulene, String, :length => 512
    property :caryophyllene, String, :length => 512
    property :cohumulone, String, :length => 512
    property :myrcene, String, :length => 512

    # property :id, Serial
    # belongs_to :recipe, :required => false
  end
end