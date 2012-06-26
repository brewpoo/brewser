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
      data=o['data']
      a = self.new
      a.name = data['name']
      a.description = data['description']
      a.type = data['type']
      a.added_when = data['added_when']
      a.time = data['time']
      a.amount = data['amount']
      a.use_for = data['use_for']

      return a
    end
    
    def to_json(*a)
      {
        'json_class'   => "Brewser::Additive",
        'data'         => {
          'name' => name, 
          'description' => description, 
          'type' => type, 
          'added_when' => added_when, 
          'time' => time, 'amount' => amount, 
          'use_for' => use_for }
      }.to_json(*a)
    end
    
  end
end