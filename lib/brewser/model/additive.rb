module Brewser
  class Additive < Model
    belongs_to :recipe
    
    property :name, String, :required => true
    property :description, String, :length => 65535
    property :type, String, :set => ['Spice', 'Fining', 'Water Agent', 'Herb', 'Flavor', 'Fruit', 'Other'], :required => true
    property :added_when, String, :set => ['Boil', 'Mash', 'Primary', 'Secondary', 'Packaging'], :required => true
    property :time, Time, :required => true
    property :amount, WeightOrVolume, :required => true

    property :use_for, String
    
    def self.json_create(o)
      a = self.new
      a.name = o['name']
      a.description = o['description']
      a.type = o['type']
      a.added_when = o['added_when']
      a.time = o['time'].u unless o['time'].blank?
      a.amount = o['amount'].u unless o['amount'].blank?
      a.use_for = o['use_for']

      return a
    end
    
    def as_json(options={})
      {
        JSON.create_id => "Brewser::Additive",
        'name' => name, 
        'description' => description, 
        'type' => type, 
        'added_when' => added_when, 
        'time' => time.to_s, 'amount' => amount.to_s, 
        'use_for' => use_for
      }
    end
    
  end
end