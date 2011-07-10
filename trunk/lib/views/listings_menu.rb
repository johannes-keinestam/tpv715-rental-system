require_relative "welcome_menu"
require_relative "../data/data_container"

module ListingsMenu
  def ListingsMenu.show
    system "cls"

    puts "============================================================"
    puts "Listings:"
    puts "    1. Selection"
    puts "    2. Customer registry"
    puts "    0. Return"
    puts "============================================================"
    puts "What do you want to do?"

    get_choice
  end

  #Gets the user's choice (of which submenu to display).
  def ListingsMenu.get_choice
    choice = gets.chomp

    #Handles the input from the user. Easily extendable for later.
    case choice
      when "1" then show_selection
      when "2" then show_customer_list
      else WelcomeMenu.show
    end
  end

  #Shows the selection menu in the console
  def ListingsMenu.show_selection
    system "cls"

    #Gets selection list, and list of registered orders
    @selection = DataContainer::get_selection
    @orders = DataContainer::get_orders

    #Puts non-rented products from selection, and rented products from order list
    #into array. This way it can display the rental data (customer, time).
    printable_selection = Array.new
    @selection.each_value do |product_category|
      product_category.each { |product| printable_selection.push("#{product}, available") unless product.is_rented? }
    end
    @orders.each_value do |customer|
      customer.each { |order| printable_selection.push(order.to_s) if order.is_active? }
    end

    #Sort: sorts alphabetically up until the first number (which is the id-number
    #of the product), which is sorted numerically instead. This prevents sorting
    #like: "Boat 1", "Boat 10", "Boat 11", "Boat 2"
    printable_selection.sort! do |a,b|
      if a.split(/\d+/)[0] == b.split(/\d+/)[0]
        a.scan(/\d+/)[0].to_i <=> b.scan(/\d+/)[0].to_i
      else
        a <=> b
      end
    end

    puts "============================================================"
    puts "Product selection:"
    printable_selection.each_index { |x| puts "    #{x+1}. #{printable_selection[x]}" }
    puts "============================================================"
    puts "Press Enter to return"

    gets
    ListingsMenu::show
  end

  #Shows the customer list menu in the console
  def ListingsMenu.show_customer_list
    system "cls"

    #Gets all customers from DataContainer
    @customers = (DataContainer::get_orders).keys.sort

    cust_length = @customers.sort { |a,b| a.name.length <=> b.name.length }
    table_length_customer = cust_length.last.name.length+5
    add_length = @customers.sort { |a,b| a.address.length <=> b.address.length }
    table_length_address = add_length.last.address.length+5

    table_format = "    %-#{table_length_customer}s %#{table_length_address}s"

    puts "============================================================"
    puts "Customer registry:\n\n"
    puts table_format % ["Customer", "Address"]
    puts "    --------------------------------------------------------"
    @customers.each { |customer| puts table_format %
      [customer.name, customer.address] }
    puts "    --------------------------------------------------------"
    puts table_format % ["Customers:", @customers.length.to_s]
    puts "\n"
    puts "============================================================"
    puts "Press Enter to return"

    gets
    ListingsMenu::show
  end
end
