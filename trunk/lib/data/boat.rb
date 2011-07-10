require_relative "article"

#Describes a boat in the rental store. Extends Article.
class Boat < Article
  @price_hr = 100
  @price_base = 200
  @price_day = 1200
  
  def initialize(name)
    @rented = false
    @name = name
  end

  #Returns the name of the boat incl. ID number
  def to_s
    return "Boat: #{@name}"
  end
end