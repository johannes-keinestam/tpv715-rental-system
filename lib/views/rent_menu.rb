require_relative "../data/order_handler"
require_relative "../data/product_handler"
require_relative "../data/customer"
require_relative "welcome_menu"
require_relative "messenger"

#Menu which lets the user rent products.
module RentMenu
  #Shows the rent menu in the console
  def RentMenu.show
    system "cls"

    #Gets list of product categories in selection, for showing on screen.
    @product_categories = (ProductHandler::get_selection).keys

    puts "============================================================"
    puts "Rent:"
    @product_categories.each_index { |x| puts "    #{x+1}. #{@product_categories[x]}" }
    puts "    None" if @product_categories.empty?
    puts "    0. Cancel"
    puts "============================================================"
    puts "What do you want to rent?"

    get_choice
  end

  #Gets a choice (of which product to rent) from the user, and then places the order.
  def RentMenu.get_choice
    product_no = gets.to_i

    #Rents the chosen product.
    if product_no != 0 and not @product_categories[product_no-1].nil?
      puts "(#{@product_categories[product_no-1]})"
      get_details
      OrderHandler::rent(@product_categories[product_no-1], @rental_customer)
      self.show
    elsif product_no == 0
      WelcomeMenu::show
    else
      Messenger::show_error("Not valid menu choice")
      self.show
    end
  end

  #Gets the name of the user. In it's own method so it can be shown again if need be.
  def RentMenu.get_details
    puts "Your name:"
    rental_name = gets.chomp

    #Checks if customer entry already exists
    customer_entry = OrderHandler::get_customer(rental_name)
    unless customer_entry.nil?
      puts "Name: #{customer_entry.name}"
      puts "Address: #{customer_entry.address}"
      puts "Card number: #{customer_entry.card_no}"
      puts "Is this you? (Y/N)"
      choice = gets.chomp
      if choice.casecmp("Y") == 0
        @rental_customer = customer_entry
        return
      end
    end
    #if not, asks for additional information.
    puts "Your address: (ex. 123 Main Street, 90210 CA)"
    rental_add = gets.chomp
    #Makes sure the card number has the right format.
    rental_card = ""
    while rental_card.match(/\A\d{4}-\d{4}-\d{4}-\d{4}\z/).nil?
      puts "Your ATM card number: (ex. 1234-1234-1234-1234)"
      rental_card = gets.chomp
    end
    @rental_customer = Customer.new(rental_name, rental_card, rental_add, OrderHandler::get_available_customer_id)
  end
end
