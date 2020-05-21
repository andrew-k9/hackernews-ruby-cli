class IoManager
  class << self
    # works with Cli class to get input and change layers
    # @params- layer: Int
    def parse_layer_input(layer)
      layer.times { print ">" }
      print " "
      input = gets.chomp.downcase
      if input == "!" && layer > 1
        layer -= 1
        parse_layer_input(layer)
      else
        { input: input, layer: layer }
      end
    end

    def greeting
      puts "Running application, type `help` for help and `man` more info"
    end

    # outputs the man page to console
    def man
      puts File.open("./db/man.txt").read
    rescue => e
      puts "Unable to find file, error: #{e.message}"
    end

    # rubocop complained so I wrote this more... interestingly
    def help
      puts "When in > (layer 1)\n" + "  `newest`  - go to new messages"
      puts "  `front` - go to the front page\n" + "  `ask`   - got to ask page"
      puts "  `show`  - go to the show section"
      puts "When in >> (layer 2)\n" + "  `n`          - view info on post n"
      puts "  `comments n` - open the comments of the post"
      puts "When in any layer\n" + "`help` - display this menu"
      puts "`!`  - go to previous layer\n" + "`quit` - exit program"
    end

    def print_article_array(array)
      array.each do |element|
        Colerizer.print_color_for_language_topic_framework(element)
      end
    end

    def print_comment_array(array)
      puts array
    end

    def print_single_article(article_string)
      Colerizer.print_color_for_language_topic_framework(article_string)
    end

    # deals with input for all layers and bad input
    # @params - input: String
    # returns what was parsed
    def global_input_layer(input, layer)
      case input
      when "quit"
        "quit"
      when "help"
        help
      when "man"
        man
      else
        error_message(input, layer)
      end
    end

    # string for error message of the incorrect input value
    # @params - input: String
    # returns - formatted error message string
    def error_message(input, layer)
      puts "Unknown command `#{input}` in layer #{layer}. Type `help` if stuck"
    end

    # string for error message for incorrect input
    # @params - number: Int, bound: Int
    # returns - formatted error message string
    def invalid_number_error(number, bound)
      puts invalid_number_error_string(number, bound)
    end

    def invalid_number_error_string(number, bound)
      "number too high: #{number + 1} is there when #{bound} is max"
    end
  end
end
