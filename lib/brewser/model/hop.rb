module Brewser
  class Hop < Model
    belongs_to :recipe
    
    property :name, String, :required => true
    property :description, String, :length => 65535
    
    property :type, String, :set => ['Bittering', 'Aroma', 'Both']
    property :alpha_acids, Float, :required => true
    property :beta_acids, Float
    property :added_when, String, :set => ['Boil', 'Dry', 'Mash', 'FWH', 'Aroma', 'Hop Back', 'Infuser'], :required => true
    property :time, Time
    property :amount, Weight   
    
    property :form, String, :set => ['Pellet', 'Plug', 'Whole']
    
    property :storageability, Float
    property :origin, String, :length => 512
    property :substitutes, String, :length => 512
    property :humulene, Float
    property :caryophyllene, Float
    property :cohumulone, Float
    property :myrcene, Float
    property :farnsene, Float
    property :total_oil, Float
    
    def self.json_create(o)
      a = self.new
      a.name = o['name']
      a.origin = o['origin']
      a.description = o['description']
      a.type = o['type']
      a.alpha_acids = o['alpha_acids']
      a.beta_acids = o['beta_acids']
      a.added_when = o['added_when']
      a.time = o['time'].u unless o['time'].blank?
      a.amount = o['amount'].u unless o['amount'].blank?
      a.form = o['form']
      a.storageability = o['storageability']
      a.substitutes = o['substitutes']
      a.humulene = o['humulene']
      a.caryophyllene = o['caryophyllene']
      a.cohumulone = o['cohumulone']
      a.myrcene = o['myrcene']
      a.farnsene = o['farnsene']
      a.total_oil = o['total_oil']
      
      return a
    end
    
    def as_json(options={})
      {
        JSON.create_id=> "Brewser::Hop",
        'name' => name, 
        'origin' => origin,
        'description' => description, 
        'type' => type, 
        'alpha_acids' => alpha_acids, 
        'beta_acids' => beta_acids, 
        'added_when' => added_when, 
        'time' => time.to_s, 'amount' => amount.to_s, 
        'form' => form, 'storageability' => storageability, 
        'substitutes' => substitutes, 
        'humulene' => humulene, 'caryophyllene' => caryophyllene,
        'cohumulone' => cohumulone, 'myrcene' => myrcene, 
        'farnsene' => farnsene, 'total_oil' => total_oil
      }
    end
      
  end
end