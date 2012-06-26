module Brewser
  class FermentationSchedule < Brewser::Model
    belongs_to :recipe
    
    has n, :fermentation_steps
    
    def self.json_create(o)
      data=o['data']
      return if data.nil?
      a = self.new
      data['fermentation_steps'].each do |step|
        a.fermentation_steps.push JSON.parse(step)
      end unless data['fermentation_steps'].nil?

      return a
    end
    
    def to_json(*a)
      {
        'json_class'   => "Brewser::FermentationSchedule",
        'data'         => {
          'fermentation_steps' => fermentation_steps }
      }.to_json(*a)
    end
    
  end
end