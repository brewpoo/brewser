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
      data=o['data']
      a = self.new
      a.name = data['name']
      a.origin = data['origin']
      a.description = data['description']
      a.type = data['type']
      a.alpha_acids = data['alpha_acids']
      a.beta_acids = data['beta_acids']
      a.added_when = data['added_when']
      a.time = data['time']
      a.amount = data['amount']
      a.form = data['form']
      a.storageability = data['storageability']
      a.substitutes = data['substitutes']
      a.humulene = data['humulene']
      a.caryophyllene = data['caryophyllene']
      a.cohumulone = data['cohumulone']
      a.myrcene = data['myrcene']
      a.farnsene = data['farnsene']
      a.total_oil = data['total_oil']
      
      return a
    end
    
    def to_json(*a)
      {
        'json_class'   => "Brewser::Hop",
        'data'         => {
          'name' => name, 
          'origin' => origin,
          'description' => description, 
          'type' => type, 
          'alpha_acids' => alpha_acids, 
          'beta_acids' => beta_acids, 
          'added_when' => added_when, 
          'time' => time, 'amount' => amount, 
          'form' => form, 'storageability' => storageability, 
          'substitutes' => substitutes, 
          'humulene' => humulene, 'caryophyllene' => caryophyllene,
          'cohumulone' => cohumulone, 'myrcene' => myrcene, 
          'farnsene' => farnsene, 'total_oil' => total_oil }
      }.to_json(*a)
    end
      
  end
end