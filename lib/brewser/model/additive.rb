module Brewser
  class Additive < Model
    belongs_to :recipe
    
    property :name, String, :required => true
    property :description, String, :length => 65535
    property :type, String, :set => ['Spice', 'Fining', 'Water Agent', 'Herb', 'Flavor', 'Other'], :required => true
    property :added_when, String, :set => ['Boil', 'Mash', 'Primary', 'Secondary', 'Bottling'], :required => true
    property :time, Time, :required => true
    property :amount, String, :required => true

    property :use_for, String
  end
end