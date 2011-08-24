require_relative "welcome_menu"
require_relative "../data/order_handler"
require_relative "../data/product_handler"
require_relative "../data/database_handler"
require "Date"

#Menu which presents financial information to the user.
module FinancialMenu
  #Shows financial main menu in the console.
  def FinancialMenu.show
    system "cls"

    puts "============================================================"
    puts "Financials:"
    puts "    1. Price list"
    puts "    2. Edit prices"
    puts "    3. Financial summary"
    puts "    0. Return"
    puts "============================================================"
    puts "What do you want to do?"

    get_choice
  end

  #Gets the user's choice (of which submenu to display).
  def FinancialMenu.get_choice
    choice = gets.chomp

    #Handles the input from the user. Easily extendable for later.
    case choice
      when "1" then show_prices
      when "2" then show_edit_prices
      when "3" then show_financials
      when "0" then WelcomeMenu::show
      else FinancialMenu.show
    end
  end

  #Shows a table of product prices to the user.
  def FinancialMenu.show_prices
    system "cls"

    #Gets the types of products in the system.
    product_categories = (ProductHandler::get_selection).keys.flatten

    #Calculates the format of the table to display the data in
    name_length = product_categories.sort { |a,b| a.to_s.length <=> b.to_s.length }
    table_length_name = name_length.last.to_s.length+5
    bprice_length = product_categories.sort { |a,b| a.price_base.to_s.length <=> b.price_base.to_s.length }
    table_length_bprice = bprice_length.last.price_base.to_s.length+5
    hprice_length = product_categories.sort { |a,b| a.price_hr.to_s.length <=> b.price_hr.to_s.length }
    table_length_hprice = hprice_length.last.price_hr.to_s.length+5
    dprice_length = product_categories.sort { |a,b| a.price_day.to_s.length <=> b.price_day.to_s.length }
    table_length_dprice = dprice_length.last.price_day.to_s.length+5

    table_format = "    %-#{table_length_name}s %#{table_length_bprice}s %#{table_length_hprice}s %#{table_length_dprice}s"

    #Displays it in table.
    puts "============================================================"
    puts "Price list:\n\n"
    puts table_format % ["", "Base", "Hourly", "Daily"]
    puts table_format % ["Product", "Price", "Price", "Price"]
    puts "    --------------------------------------------------------"
    product_categories.each { |product| puts table_format %
      [product.to_s, "$"+product.price_base.to_s, "$"+product.price_hr.to_s, "$"+product.price_day.to_s] }
    puts "    --------------------------------------------------------"
    puts "\n"
    puts "============================================================"
    puts "Press Enter to return"

    gets
    FinancialMenu::show
  end

  #Shows submenu for product prices, and lets the user change the prices.
  def FinancialMenu.show_edit_prices
    system "cls"

    #Gets the types of products in the system.
    product_categories = (ProductHandler::get_selection).keys.flatten

    #Shows menu of products, letting the user choose which price to change.
    puts "============================================================"
    puts "Edit prices:"
    product_categories.each_index { |i| puts "    #{i+1}. #{product_categories[i].to_s}" }
    puts "    0. Return"
    puts "============================================================"
    puts "What prices do you want to edit?"

    choice = gets.to_i

    #If choice is valid, let's the user change the products prices.
    if choice > 0 and choice <= product_categories.length
      system "cls"
      product = product_categories[choice-1]
      puts "Changing prices for #{product}".upcase
      puts "=========================================================="
      puts "Input a new price for each type.\n" +
           "The price will not change if the input is invalid or empty.\n\n"

      #Sets price only if it is valid (i.e. positive integer)
      puts "Base price:"
      b_price = Integer(gets.chomp) rescue b_price = -1
      b_price_old = product.price_base
      product.price_base = b_price if b_price >= 0

      puts "Hourly price:"
      h_price = Integer(gets.chomp) rescue h_price = -1
      h_price_old = product.price_hr
      product.price_hr = h_price if h_price >= 0

      puts "Daily price:"
      d_price = Integer(gets.chomp) rescue d_price = -1
      d_price_old = product.price_day
      product.price_day = d_price if d_price >= 0

      puts "\nNEW PRICES, #{product.to_s.upcase}:"
      puts "Base $#{product.price_base} (old $#{b_price_old})"
      puts "Hourly $#{product.price_hr} (old $#{h_price_old})"
      puts "Daily $#{product.price_day} (old $#{d_price_old})"
      puts "=========================================================="
      puts "PRESS ENTER TO RETURN"

      DatabaseHandler::update_prices(product, product.price_base, product.price_hr, product.price_day)
      gets
      FinancialMenu::show
    else
      #Else, either go back or inform the user of invalid menu choice.
      if choice == 0
        FinancialMenu::show
      else
        Messenger::show_error("Invalid menu choice") unless choice == 0
        show_edit_prices
      end
    end
  end

  #Shows table of a summary of the financials (income, total and by month).
  def FinancialMenu.show_financials
    system "cls"

    #gets all paid orders.
    orders = OrderHandler::get_orders
    paid_orders = orders.select { |order| not order.is_active? }

    #calculates total price
    total_price = 0
    paid_orders.each { |order| total_price += order.get_price }

    #calculates how wide the table columns should be
    table_length_product = 0
    table_length_customer = 0
    table_length_price = 0
    paid_orders.each do |order|
      prod_length = order.product.to_s.length
      table_length_product = prod_length if prod_length > table_length_product

      cust_length = order.customer.to_s.length
      table_length_customer = cust_length if cust_length > table_length_customer

      price_length = order.get_price.to_s.length
      table_length_price = price_length if price_length > table_length_price
    end
    table_length_product += 5
    table_length_customer += 5
    table_length_price += 5

    #converts collected format data to format string
    table_format = "    %-#{table_length_product}s %-#{table_length_customer}s %#{table_length_price}s"

    #Creates monthly financial data
    monthly_list = Hash.new
    paid_orders.each do |order|
      month = "#{Date::MONTHNAMES[order.stop_time.month]} #{order.stop_time.year}"
      unless monthly_list.has_key?(month)
        monthly_list[month] = [0, 0]
      end
      monthly_list[month][0] += order.get_price
      monthly_list[month][1] += 1
    end

    #shows total, followed by monthly, income data
    puts "============================================================"
    puts "Financial summary:\n\n"
    puts table_format % ["Article", "Customer", "Income"]
    puts "    --------------------------------------------------------"
    paid_orders.each { |order| puts table_format %
      [order.product.to_s, order.customer.to_s, "$"+order.get_price.to_s] }
    puts "    --------------------------------------------------------"
    puts table_format % ["Total:", "", "$"+total_price.to_s]
    puts "\n"
    puts table_format % ["Month", "Rentals", "Income"]
    puts "    --------------------------------------------------------"
    monthly_list.each { |month,info| puts table_format %
      [month, info[1].to_s, "$"+info[0].to_s]}
    puts "    --------------------------------------------------------\n\n"
    puts "============================================================"
    puts "Press Enter to return"

    gets
    FinancialMenu::show
  end

end
