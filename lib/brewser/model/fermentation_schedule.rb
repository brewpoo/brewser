module Brewser
  class FermentationSchedule < Brewser::Model
    belongs_to :recipe
    
    has n, :fermentation_steps
  end
end