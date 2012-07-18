require 'ruby-units'

Unit.redefine!('tempC') do |celsius|
  celsius.aliases  = %w{degC dC C}
  celsius.display_name  = "dC"
end

Unit.redefine!('tempF') do |fahrenheit|
  fahrenheit.aliases  = %w{degF dF F}
  fahrenheit.display_name  = "dC"
end

Unit.redefine!('gram') do |gram|
  gram.aliases  = %w{g gm gram grams gramme grammes}
end

Unit.define('barrel') do |barrel|
  barrel.definition = Unit('31 gal')
  barrel.aliases    = %w{bbl bbls barrel barrels}
end

Unit.define('keg') do |keg|
  keg.definition  = Unit('1/2 barrel')
  keg.aliases     = %w{keg kegs}
end

# Add convienience method
class Unit
  # returns the scalar value convert to other units
  def scalar_in(other)
    to(other).scalar.to_f
  end
end