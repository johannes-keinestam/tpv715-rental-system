#Module for giving a message to the user. Can be called at any point, and the
#message will show up. Only shows messages if global variable MESSAGE_ON is true.
module Messenger
  def Messenger.show_message(text)
    if $MESSAGES_ON
      system "cls"
      puts "#{text}"
      puts "=============================================="
      puts "Press Enter to return."
      gets
    end
  end

  def Messenger.show_error(text)
    show_message("ERROR: #{text}") if $MESSAGES_ON
  end
end
