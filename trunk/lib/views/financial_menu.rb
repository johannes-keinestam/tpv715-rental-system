require_relative "welcome_menu"
require_relative "../data/data_container"
require "Date"

module FinancialMenu
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
      else WelcomeMenu.show
    end
  end

  def FinancialMenu.show_prices
    system "cls"

    product_categories = (DataContainer::get_selection).keys.flatten

    name_length = product_categories.sort { |a,b| a.to_s.length <=> b.to_s.length }
    table_length_name = name_length.last.to_s.length+5
    bprice_length = product_categories.sort { |a,b| a.price_base.to_s.length <=> b.price_base.to_s.length }
    table_length_bprice = bprice_length.last.price_base.to_s.length+5
    hprice_length = product_categories.sort { |a,b| a.price_hr.to_s.length <=> b.price_hr.to_s.length }
    table_length_hprice = hprice_length.last.price_hr.to_s.length+5
    dprice_length = product_categories.sort { |a,b| a.price_day.to_s.length <=> b.price_day.to_s.length }
    table_length_dprice = dprice_length.last.price_day.to_s.length+5

    table_format = "    %-#{table_length_name}s %#{table_length_bprice}s %#{table_length_hprice}s %#{table_length_dprice}s"

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

  def FinancialMenu.show_edit_prices
    system "cls"

    product_categories = (DataContainer::get_selection).keys.flatten

    puts "============================================================"
    puts "Edit prices:"
    product_categories.each_index { |i| puts "    #{i+1}. #{product_categories[i].to_s}" }
    puts "    0. Return"
    puts "============================================================"
    puts "What prices do you want to edit?"

    choice = gets.to_i
    if choice > 0 and choice <= product_categories.length
      system "cls"
      product = product_categories[choice-1]
      puts "Input a new price for each type.\nThe price will not change if the input is invalid or empty.\n\n"

      puts "#{product}, base price:"
      b_price = gets.to_i
      b_price_old = product.price_base
      product.price_base = b_price if b_price > 0

      puts "#{product}, hourly price:"
      h_price = gets.to_i
      h_price_old = product.price_hr
      product.price_hr = h_price if h_price > 0

      puts "#{product}, daily price:"
      d_price = gets.to_i
      d_price_old = product.price_day
      product.price_day = d_price if d_price > 0

      puts "\nNEW PRICES, #{product.to_s.upcase}:"
      puts "Base $#{product.price_base} (old $#{b_price_old})"
      puts "Hourly $#{product.price_hr} (old $#{h_price_old})"
      puts "Daily $#{product.price_day} (old $#{d_price_old})"
      puts "========================================================"
      puts "PRESS ENTER TO RETURN"
      gets
      FinancialMenu::show
    else
      if choice == 0
        FinancialMenu::show
      else
        Messenger::show_error("Invalid menu choice") unless choice == 0
        show_edit_prices
      end
    end
  end

  def FinancialMenu.show_financials
    system "cls"

    #gets all paid orders.
    orders = (DataContainer::get_orders).values.flatten
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

    #shows menu
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
    puts "    --------------------------------------------------------"
    puts "============================================================"
    puts "Press Enter to return"

    gets
    FinancialMenu::show
  end

end
