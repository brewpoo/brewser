module Brewser
  class FermentationSchedule < Brewser::Model
    has n, :fermentation_steps
  end
end