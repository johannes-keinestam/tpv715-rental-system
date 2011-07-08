require_relative "article"

#Describes diving gear kit in the rental store. Extends Article.
class DivingGear < Article
  def initialize(idNo)
    @rented = false
    @price_hr = 50
    @price_base = 25
    @idNo = idNo
  end

  #Returns the name of the product incl. ID number
  def to_s
    return "Diving Gear kit #{@idNo}"
  end
end