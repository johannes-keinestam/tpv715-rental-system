require_relative "article"

#Describes a jet ski in the rental store. Extends Article.
class JetSki < Article
  @price_hr = 70
  @price_base = 50
  @price_day = 700
  
  def initialize(idNo)
    @rented = false
    @idNo = idNo
  end

  #Returns the name of the jet ski incl. ID number
  def to_s
    return "Jet Ski #{@idNo}"
  end

  #Products whos string representation shouldn't be the class name define this
  #class method, ex. JetSki should be spaced as Jet Ski.
  def self.to_s
    return "Jet Ski"
  end
end