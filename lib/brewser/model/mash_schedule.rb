module Brewser
  class MashSchedule < Brewser::Model  
    belongs_to :recipe
    
    property :name, String, :required => true
    property :description, String
    property :grain_temp, Temperature
    property :sparge_temp, Temperature
    
    has n, :mash_steps
    
    def self.json_create(o)
      data=o['data']
      return if data.nil?
      a = self.new
      a.name = data['name']
      a.description = data['description']
      a.grain_temp = data['grain_temperature']
      a.sparge_temp = data['sparge_temperature']
      data['mash_steps'].each do |step|
        a.mash_steps.push JSON.parse(step)
      end unless data['mash_steps'].nil?

      return a
    end
    
    def to_json(*a)
      {
        'json_class'   => "Brewser::MashSchedule",
        'data'         => {
          'name' => name, 'description' => description, 
          'grain_temperature' => grain_temp, 'sparge_temperature' => sparge_temp,
          'mash_steps' => mash_steps }
      }.to_json(*a)
    end 
       
  end
end