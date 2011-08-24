require_relative "listings_menu"
require_relative "financial_menu"
require_relative "welcome_menu"
require_relative "../data/database_handler"

module SaveMenu
  #Shows main menu for saving information to file
  def SaveMenu.show
    system "cls"

    puts "============================================================"
    puts "Save information:"
    puts "    1. Selection and financials"
    puts "    2. Customers and addresses"
    puts "    0. Return"
    puts "============================================================"
    puts "What do you want to do?"

    get_choice
  end

  #Gets the user's choice (of which submenu to display).
  def SaveMenu.get_choice
    choice = gets.chomp

    #Handles the input from the user. Easily extendable for later.
    case choice
      when "1" then show_save_selection
      when "2" then show_save_customers
      when "0" then WelcomeMenu::show
      else SaveMenu.show
    end
  end

  #Returns an available file name for the specified string, incl. txt extension
  #(i.e. if name = "testfile" and testfile.txt already exists it returns
  #testfile 2.txt or continues if that is unavailable as well, otherwise just
  #testfile.txt).
  def SaveMenu.get_file_name(name)
    file_name = name
    i = 1
    while File.exists?(file_name+".txt")
      i += 1
      file_name = name+" #{i}"
    end
    return file_name + ".txt"
  end

  #Shows the file saving progress for information about financials, selection
  #and prices.
  def SaveMenu.show_save_selection
    system "cls"

    #saves file in run path
    log_name = SaveMenu.get_file_name("rbws-statistics-#{Date.today.to_s}")
    puts "Outputing to file: \n#{File.expand_path(log_name)}..."

    #gets all needed info from database. only other part of the application than
    #DatabaseHandler that handles database queries, because it works so heavily
    #and specifically with the database.
    db = DatabaseHandler::get_database
    order_data = db.execute("SELECT * FROM orders")
    product_data = db.execute("SELECT name, id FROM selection")
    price_data = db.execute("SELECT * FROM prices")

    #opens file for writing
    output_file = File.open(log_name, "w")

    output_file.write("STATISTICS FROM RUBY BEACH WATER SPORTS RENTAL SYSTEM")

    #writes orders to file
    output_file.write("\n\n1. FINANCIALS\n\n")
    output_file.write("1.1. ORDERS\n\n")
    order_data.each { |order| output_file.write("    #{ProductHandler::get_product(order[0])}\n    #{OrderHandler::get_customer(order[1])}\n    $#{order[4].nil? ? 0 : order[4]}\n\n") }

    #writes incomes to file
    output_file.write("\n\n1.2. INCOME\n\n")
    paid_orders = order_data.select { |order| not order[3].nil? }
    monthly_income = Hash.new
    paid_orders.each do |order|
      stop_time = Time.at(order[3])
      month = "#{Date::MONTHNAMES[stop_time.month]} #{stop_time.year}"
      unless monthly_income.has_key?(month)
        monthly_income[month] = 0
      end
      monthly_income[month] += order[4]
    end
    monthly_income.each { |month,income| output_file.write("    #{month}\n    $#{income}\n\n") }

    #writes price list to file
    output_file.write("\n\n2. PRICE LIST\n\n")
    price_data.each { |price| output_file.write("    #{price[0]}\n    Base price: $#{price[1]}\n    Hourly price: $#{price[2]}\n    Daily price: $#{price[3]}\n\n" ) }

    #writes selection list to file
    output_file.write("\n\n3. SELECTION\n\n")
    product_data.each { |product| output_file.write("    #{product[0]} (ID: #{product[1]})\n") }

    output_file.close
    
    puts "\nDONE!"
    puts "Press any key to return."
    gets
    WelcomeMenu::show
  end

  #Shows file saving progress for customer registry.
  def SaveMenu.show_save_customers
    system "cls"

    #saves file in run path
    log_name = SaveMenu.get_file_name("rbws-customers-#{Date.today.to_s}")
    puts "Outputing to file: \n#{File.expand_path(log_name)}..."

    #gets customer info from database
    db = DatabaseHandler::get_database
    customer_data = db.execute("SELECT name, address FROM customers")

    #opens file for writing
    output_file = File.open(log_name, "w")

    #writes customer registry
    output_file.write("CUSTOMER DATA FROM RUBY BEACH WATER SPORTS RENTAL SYSTEM\n\n")
    customer_data.each { |customer| output_file.write("    #{customer[0]}\n    #{customer[1]}\n\n") }

    output_file.close
    
    puts "\nDONE!"
    puts "Press any key to return."
    gets
    WelcomeMenu::show
  end
end
