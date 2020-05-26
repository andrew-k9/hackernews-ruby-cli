require "io/console"

class IoManager
  class << self
    BREAKER = "------------------------------------------".freeze

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

    def goodbye
      puts "Thank you for running the program, goodbye!"
    end

    # outputs the man page to console
    def man
      puts File.open("./db/man.txt").read
    rescue => e
      puts "Unable to find file, error: #{e.message}"
    end

    # rubocop complained so I wrote this more... interestingly
    def help
      puts "When in > (layer 1)\n  `newest`  - go to new messages"
      puts "  `front` - go to the front page\n  `ask`   - got to ask page"
      puts "  `show`  - go to the show section"
      puts "When in >> (layer 2)\n  `n`          - view info on post n"
      puts "  `comments n` - open the comments of the post"
      puts "When in any layer\n`help` - display this menu"
      puts "`!`  - go to previous layer\n`quit` - exit program"
      puts ""
    end

    def print_article_array(array)
      puts BREAKER
      array.each do |element|
        Colerizer.print_color_for_language_topic_framework(element)
        puts ""
      end
      puts BREAKER
    end

    def print_comment_array(array)
      columns = IO.console.winsize[1] * 3 / 4
      if array[0] == "No comments!"
        puts array[0] + "\n"
        return
      end
      array.each do |comment|
        puts format_string_for_window_size(comment, columns)
        puts ""
      end
    end

    def print_single_article(article_string)
      puts "\n" + BREAKER
      Colerizer.print_color_for_language_topic_framework(article_string)
      puts BREAKER + "\n\n"
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

  private

    # TODO: try with inject
    def format_string_for_window_size(string, columns, formatted_string = "")
      string.split(/ /).inject(0) do |sum, word|
        if conditional?(sum, columns, word)
          formatted_string += "\n#{word} "
          # adding in an extra character `\n`
          sum = word.length + 1
        else
          formatted_string += "#{word} "
        end
        # adding in a character every time regardless
        sum += word.length + 1
      end
      formatted_string + Colerizer.comment_break_style(("-" * columns).to_s)
    end

    def conditional?(sum, columns, word)
      sum >= columns || sum + word.length >= columns
    end
  end
end
