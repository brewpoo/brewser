require 'ruby-units'

module Brewser::Model::Properties
  
  class Property < DataMapper::Property::Float
    def custom?
      true
    end

    def valid_unit_type?(value_kind)
      value_kind == kind_of
    end

    def primitive?(value)
      value.is_a?(Unit) && valid_unit_type?(value.kind)
    end

    def load(value)
      return if value.nil?
      if value.is_a?(Unit)
        raise(ArgumentError, "#{value.inspect} is not a #{kind_of}") unless value.kind == kind_of
        value
      else
        "#{value} #{base_unit}".u
      end
    end

    def dump(value)
      return if value.nil?
      value.scalar_in(base_unit).to_f
    end

    def typecast_to_primitive(value)
      load(value)
    end
  end

  # Represents a weight. Default scale is kilograms, since that's what
  # BeerXML uses. But can handle conversion/display of other units.
  class Weight < Property
    def kind_of
      :mass
    end
    def base_unit
      'kg'
    end
  end

  # A volume, in liters.
  class Volume < Property
    def kind_of
      :volume
    end
    def base_unit
      'l'
    end
  end

  # A temperature, in deg C.
  class Temperature < Property
    def kind_of
      :temperature
    end
    def base_unit
      'dC'
    end
  end

  # A time, in minutes.
  class Time < Property
    def kind_of
      :time
    end
    def base_unit
      'min'
    end
  end

  # Time, but in days.
  class TimeInDays < Time
    def base_unit
      'days'
    end
  end

end
