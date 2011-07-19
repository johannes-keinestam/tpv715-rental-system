#Describes an order of one product placed in the system. This class calculates
#and keeps track of the total price of the order when it is returned.
class Order
  attr_reader :product, :customer, :start_time, :stop_time

  #Creates a new order for the specified customer.
  def initialize(product, customer)
    @product = product
    @customer = customer
    @active = false
  end

  #Returns true if the customer still has the product, false otherwise.
  def is_active?
    return @active
  end

  #(De)activates an order. Registers time automatically.
  def set_active(bool)
    if (bool == true)
      @active = true
      @start_time = Time.now
      @product.rent
    else
      @price = nil
      @active = false
      @stop_time = Time.now
      @product.return_product
    end
  end

  #Calculates a final price for the order using the registred time stamps of the
  #start and the end of the rental time. If order is active, returns current price
  #(not used in program).
  def get_price
    #Only calculate final price once, thus product price changes will not
    #affect price of an already finished order.
    if @price.nil?
      if @active
        hours = ((@start_time-Time.now)/3600).to_i
      else
        hours = ((@start_time-@stop_time)/3600).to_i
      end
      @price = @product.get_price(hours)
    end
    return @price
  end

  #Returns a string presenting an active order. Used in "Return menu"
  def to_s
    return "#{@product}, rented by #{@customer} at #{@start_time}"
  end
end
		