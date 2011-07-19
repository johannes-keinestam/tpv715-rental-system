#Describes a generic article for rent. Articles used in the program extend this
#class. Has no knowledge of the renter, only it's own data (ID, price and
#whether it's rented or not).
class Article
  attr_reader :idNo, :price_hr, :price_base, :price_day
  #Class level instance variables for prices
  @price_hr = 0
  @price_base = 0
  @price_day = 0
  
  def initialize(idNo)
    @rented = false
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

  #Returns the price for the specified hours. If valid, uses the
  #daily price instead of hourly price.
  def get_price(hours)
    if hours < 24
      price = (self.class.price_hr*hours)+self.class.price_base
    else
      days = hours/24
      price = (self.class.price_day*days)+self.class.price_base
    end

    return price
  end
  
  def to_s
    return "Article #{@idNo}"
  end

  #Makes variables available on class level without letting
  #class variables screw up the clas heriarchy.
  class << self
    attr_accessor :price_base, :price_hr, :price_day
  end
end
