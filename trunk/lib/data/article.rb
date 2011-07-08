#Describes a generic article for rent. Articles used in the program extend this
#class. Has no knowledge of the renter, only it's own data (ID, price and
#whether it's rented or not).
class Article
  attr_reader :idNo
  def initialize(idNo)
    @rented = false
    @price_hr = 0
    @price_base = 0
    @idNo = idNo
  end

  def rent
    @rented = true
  end

  def return_product
    @rented = false
  end

  def is_rented?
    return @rented
  end

  def get_price(hours)
    return (@price_hr*hours)+@price_base
  end
  
  def to_s
    return "Article #{@idNo}"
  end

end
