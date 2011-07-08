require_relative "article"

#Describes a surfboard in the rental store. Extends Article.
class Surfboard < Article
  def initialize(idNo)
    @rented = false
    @price_hr = 10
    @price_base = 15
    @idNo = idNo
  end

  #Returns the name of the surfboard incl. ID number
  def to_s
    return "Surfboard #{@idNo}"
  end
end