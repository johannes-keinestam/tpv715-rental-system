#Class that describes a customer, each having a name. Can be extended with
#other info, such as credit card and address. 
class Customer
  include Comparable
  attr_reader :name, :card_no, :address
  def initialize(name, card_no, address)
    @name, @card_no, @address = name, card_no, address
  end

  #Compares two customers. For use when sorting alphabetically by customer name.
  def <=>(other)
    self.to_s <=> other.to_s
  end

  def to_s
    return @name
  end
end
