module Brewser
  class FermentationSchedule < Brewser::Model
    belongs_to :recipe
    
    has n, :fermentation_steps
    
    def self.json_create(o)
      a = self.new
      o['fermentation_steps'].each do |step|
        a.fermentation_steps.push step
      end unless o['fermentation_steps'].nil?

      return a
    end
    
    def as_json(options={})
      {
        JSON.create_id => "Brewser::FermentationSchedule",
        'fermentation_steps' => fermentation_steps.to_a
      }
    end
    
  end
end