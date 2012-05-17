module Brewser
  class FermentationSchedule < Brewser::Model
    has n, :fermentation_steps
  
    # property :id, Serial
    # belongs_to :recipe, :required => false
  end
end