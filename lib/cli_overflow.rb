class Cli
  # string for error message of the incorrect input value
  # @params - input: String
  # returns - formatted error message string
  def error_message(input)
    "Unknown command `#{input}` in layer #{@layer}. Type `help` if stuck"
  end

  # string for error message for incorrect input
  # @params - number: Int, bound: Int
  # returns - formatted error message string
  def invalid_number_error(number, bound)
    "number too high: #{number + 1} is there when #{bound} is max"
  end

  # rubocop complained so I wrote this more... interestingly
  def help
    puts "When in > (layer 1)\n" + "  `newest`  - go to new messages"
    puts "  `front` - go to the front page"
    puts "  `ask`   - got to the question board"
    puts "  `show`  - go to the show section"
    puts "When in >> (layer 2)\n" + "  `n`          - view info on post n"
    puts "  `comments n` - open the comments of the post"
    puts "When in any layer\n" + "`help` - display this menu"
    puts "`!`  - go to previous layer\n" + "`quit` - exit program"
  end

  def number?(string)
    /^(\d+)/.match(string).to_s != ""
  end
end
