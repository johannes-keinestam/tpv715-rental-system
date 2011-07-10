require_relative "welcome_menu"
require_relative "../data/data_container"

module FinancialMenu
  def FinancialMenu.show
    system "cls"

    puts "============================================================"
    puts "Financials:"
    puts "    1. Price list"
    puts "    2. Financial summary"
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
      when "2" then show_financials
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
    puts "============================================================"
    puts "Press Enter to return"

    gets
    FinancialMenu::show
  end

end
