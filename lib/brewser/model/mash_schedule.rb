module Brewser
  class MashSchedule < Brewser::Model
    property :name, String, :required => true
    has n, :mash_steps
  
    # property :id, Serial
    # belongs_to :recipe, :required => false
  end
end