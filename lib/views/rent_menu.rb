require_relative "../data/data_container"
require_relative "../data/customer"
require_relative "welcome_menu"
require_relative "messenger"

#Menu which lets the user rent products.
module RentMenu
  #Shows the rent menu in the console
  def RentMenu.show
    system "cls"

    #Gets list of product categories in selection, for showing on screen.
    @product_categories = (DataContainer::get_selection).keys

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

    #Rents the chosen product (only one now).
    if product_no != 0 or @product_categories[product_no-1].nil?
      get_details
      DataContainer::rent(@product_categories[product_no-1], @rental_customer)
      WelcomeMenu::show
    elsif product_no == 0
      WelcomeMenu::show
    else
      Messenger::show_error("Not valid menu choice")
      show
    end
  end

  #Gets the name of the user. In it's own method so it can be shown again if need be.
  def RentMenu.get_details
    puts "Your name:"
    rental_name = gets.chomp

    #Checks if customer entry already exists
    customer_entry = DataContainer::get_customer(@rental_name)
    unless customer_entry.nil?
      puts "Name: #{customer_entry.name}"
      puts "Address: #{customer_entry.address}"
      puts "Card number: #{customer_entry.card_no}"
      puts "Is this you? (Y/N)"
      choice = gets.chomp
      if choice.casecmp("Y")
        @rental_customer = customer_entry
      end
    else
      puts "Your address:"
      rental_add = gets.chomp
      puts "Your ATM card number:"
      rental_card = gets.chomp
      @rental_customer = Customer.new(rental_name, rental_card, rental_add)
    end
  end
end
