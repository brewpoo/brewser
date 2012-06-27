module Brewser
  class MashSchedule < Brewser::Model  
    belongs_to :recipe
    
    property :name, String, :required => true
    property :description, String
    property :grain_temp, Temperature
    property :sparge_temp, Temperature
    
    has n, :mash_steps
    
    def self.json_create(o)
      return nil if o.blank?
      a = self.new
      a.name = o['name']
      a.description = o['description']
      a.grain_temp = o['grain_temperature'].u unless o['grain_temperature'].blank?
      a.sparge_temp = o['sparge_temperature'].u unless o['sparge_temperature'].blank?
      o['mash_steps'].each do |step|
        a.mash_steps.push step
      end unless o['mash_steps'].nil?

      return a
    end
    
    def as_json(options={})
      {
        JSON.create_id => "Brewser::MashSchedule",
          'name' => name, 'description' => description, 
          'grain_temperature' => grain_temp.to_s, 'sparge_temperature' => sparge_temp.to_s,
          'mash_steps' => mash_steps.to_a
      }
    end 
       
  end
end