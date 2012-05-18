module Brewser
  class MashSchedule < Brewser::Model
    property :name, String, :required => true
    has n, :mash_steps
  end
end