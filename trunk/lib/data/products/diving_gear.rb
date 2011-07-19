require_relative "article"

#Describes diving gear kit in the rental store. Extends Article. See article.rb for
#further documentation.
class DivingGear < Article
  @price_hr = 50
  @price_base = 25
  @price_day = 400
  
  def initialize(idNo)
    @rented = false
    @idNo = idNo
  end

  #Returns the name of the product incl. ID number
  def to_s
    return "Diving Gear kit #{@idNo}"
  end

  #Products whose string representation shouldn't be identical to the class name
  #define this class method, ex. DivingGear should be the more descriptive Diving Gear kit.
  def self.to_s
    return "Diving Gear kit"
  end
end