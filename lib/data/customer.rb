#Class that describes a customer, each having a name, credit card and address.
#Extending the class for different data is rather trivial.
class Customer
  include Comparable
  attr_reader :name, :card_no, :address, :id
  def initialize(name, card_no, address, id)
    @name, @card_no, @address, @id = name, card_no, address, id
  end

  #Compares two customers. For use when sorting alphabetically by customer name.
  def <=>(other)
    self.to_s <=> other.to_s
  end

  #Returns the name of the customer.
  def to_s
    return @name
  end
end
