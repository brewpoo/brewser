module Brewser
  class WaterProfile < Model
    include DataMapper::Resource

    property :name, String, :required => true

    property :calcium, Float, :required => true
    property :magnesium, Float, :required => true
    property :sodium, Float, :required => true
    property :chloride, Float, :required => true
    property :sulfates, Float, :required => true
    property :bicarbonate, Float
    property :alkalinity, Float
    property :ph, Float
  end
end