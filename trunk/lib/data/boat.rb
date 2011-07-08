require_relative "article"

#Describes a boat in the rental store. Extends Article.
class Boat < Article
  def initialize(idNo)
    @rented = false
    @price_h = 100
    @idNo = idNo
  end

  #Returns the name of the boat incl. ID number
  def to_s
    return "Boat #{@idNo}"
  end
end