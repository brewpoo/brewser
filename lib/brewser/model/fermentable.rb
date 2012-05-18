module Brewser
  class Fermentable < Model
    property :name, String, :required => true
    property :type, String, :set => ['Grain', 'Sugar', 'Extract', 'Dry Extract', 'Adjunct'], :required => true
    property :amount, Weight, :required => true
    property :yield, Float, :required => true
    property :color, Float, :required => true

    property :add_after_boil, Boolean, :default => false
    property :origin, String, :length => 512
    property :supplier, String, :length => 512
    property :notes, String, :length => 65535
    property :coarse_fine_diff, Float
    property :moisture, Float
    property :diastatic_power, Float
    property :protein, Float
    property :max_in_batch, Float
    property :recommend_mash, Boolean
    property :ibu_gal_per_lb, Float
  end
end