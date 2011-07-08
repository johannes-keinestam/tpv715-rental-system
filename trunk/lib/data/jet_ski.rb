require_relative "article"

#Describes a jet ski in the rental store. Extends Article.
class JetSki < Article
  def initialize(idNo)
    @rented = false
    @price_hr = 70
    @price_base = 50
    @idNo = idNo
  end

  #Returns the name of the jet ski incl. ID number
  def to_s
    return "Jet Ski #{@idNo}"
  end
end