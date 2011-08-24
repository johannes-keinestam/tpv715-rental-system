require_relative "article"

#Describes a jet ski in the rental store. Extends Article. See article.rb for
#further documentation.
class JetSki < Article
  
  def initialize(name, id)
    @rented = false
    @name = name
    @id = id
  end

  #Products whose string representation shouldn't be identical to the class name
  #define this class method, ex. JetSki should be spaced as Jet Ski.
  def self.to_s
    return "Jet Ski"
  end
end