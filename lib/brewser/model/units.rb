require 'ruby-units'

module Brewser::Model::Units
  
  class Units < DataMapper::Property::String
    
    # Declare this property as custom
    def custom?
      true
    end

    # Compare the values kind (mass, volume, etc) to the object classes kind_of
    #
    # @param [Unit] value value to be checked
    # @return [Boolean] returns true if value is of the correct kind
    def valid_kind?(value)
      value.kind == kind_of
    end

    # 
    def primitive?(value)
      value.is_a?(Unit) && valid_kind?(value)
    end

    def load(value)
      return if value.nil?
      if !value.u.unitless?
        raise(ArgumentError, "#{value.inspect} is not a #{kind_of}") unless value.u.kind == kind_of
        value.u
      else
        "#{value} #{base_unit}".u
      end
    end

    def dump(value)
      return if value.nil?
      value.u.to_s
    end

    def typecast_to_primitive(value)
      load(value)
    end
  end

  # Represents a weight. Default scale is kilograms, since that's what
  # BeerXML uses. But can handle conversion/display of other units.
  class Weight < Units
    def kind_of
      :mass
    end
    def base_unit
      'kg'
    end
  end

  # A volume, in liters.
  class Volume < Units
    def kind_of
      :volume
    end
    def base_unit
      'l'
    end
  end

  # A temperature, in deg C.
  class Temperature < Units
    def kind_of
      :temperature
    end
    def base_unit
      'dC'
    end
  end

  # A time, in minutes.
  class Time < Units
    def kind_of
      :time
    end
    def base_unit
      'min'
    end
  end

  # Time, but in days.
  class TimeInDays < Units
    def base_unit
      'days'
    end
  end

end
