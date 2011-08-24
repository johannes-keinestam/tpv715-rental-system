require_relative "article"

#Describes diving gear kit in the rental store. Extends Article. See article.rb for
#further documentation.
class DivingGear < Article
  
  def initialize(name, id)
    @rented = false
    @name = name
    @id = id
  end

  #Products whose string representation shouldn't be identical to the class name
  #define this class method, ex. DivingGear should be the more descriptive Diving Gear kit.
  def self.to_s
    return "Diving Gear kit"
  end
end