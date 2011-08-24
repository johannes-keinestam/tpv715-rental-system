require_relative "article"

#Describes a surfboard in the rental store. Extends Article. See article.rb for
#further documentation.
class Surfboard < Article
  
  def initialize(name, id)
    @rented = false
    @name = name
    @id = id
  end
end