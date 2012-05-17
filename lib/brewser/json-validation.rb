require 'multi_json'

class String
  def valid_json?
    begin
      MultiJson.decode(self)
      return true
    rescue Exception => e
      return false
    end
  end
end