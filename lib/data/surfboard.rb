require_relative "article"

#Describes a surfboard in the rental store. Extends Article.
class Surfboard < Article
  @price_hr = 10
  @price_base = 15
  @price_day = 100
  
  def initialize(idNo)
    @rented = false
    @idNo = idNo
  end

  #Returns the name of the surfboard incl. ID number
  def to_s
    return "Surfboard #{@idNo}"
  end
end