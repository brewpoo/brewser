module Brewser
  class MashSchedule < Brewser::Model
    property :name, String, :required => true
    property :description, String
    property :grain_temp, Temperature
    property :sparge_temp, Temperature
    has n, :mash_steps
  end
end