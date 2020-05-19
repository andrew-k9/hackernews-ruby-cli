class Cli
  # get and format user input, change layer if needed
  # return - user input line to indicate the layer
  def format_input
    @layer.times { print ">" }
    print " "
    input = gets.chomp.downcase
    if input == "!" && @layer > 1
      @layer -= 1
      format_input
    else
      input
    end
  end

  # string for error message of the incorrect input value
  # @params - input: String
  # returns - formatted error message string
  def error_message(input)
    "Unknown command `#{input}` in layer #{@layer}. Type `help` if stuck"
  end

  def invalid_number_error(number, bound)
    "number too high: #{number + 1} is there when #{bound} is max"
  end

  # rubocop complained so I wrote this more... interestingly
  def help
    puts "When in > (layer 1)\n" + "  `news`  - go to new messages"
    puts "  `front` - go to today's top posts"
    puts "  `ask`   - got to the question board"
    puts "  `show`  - go to the show section"
    puts "When in >> (layer 2)\n" + "  `n`          - view info on post n"
    puts "  `comments n` - open the comments of the post"
    puts "When in any layer\n" + "`help` - display this menu"
    puts "`!`  - go to previous layer\n" + "`quit` - exit program"
  end

  # deals with other cases
  def other_input(input)
    case input
    when "quit"
      "quit"
    when "help"
      help
      "help"
    else
      puts error_message(input)
      "error"
    end
  end

  def number?(string)
    /^(\d+)/.match(string).to_s != ""
  end
end
