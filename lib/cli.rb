 # Agnostic of nokogiri
 # Invokes the `Scraper` class
 class Cli
  attr_accessor :layer, :current_page
  WEBSITE = "https://news.ycombinator.com".freeze

  def initialize
    @layer = 1
  end

  # main loop for the program
  def call
    puts "Running application, type `help` for help"
    input = get_input
    until input == "quit"
      if @layer == 1
        input = layer_one_input(input)
      else
        input = layer_two_input(input)
      end
    end
    binding.pry
  end

  # actions defined on the first layer of input, loads in articles or prints help message
  # @params - input: String
  # returns - user input to be used in the loop in `call`
  def layer_one_input(input)
    case input
    when "news"
      print_page("/news")
      @layer += 1
    when "front"
      print_page("/front")
      @layer += 1
    when "ask"
      print_page("/ask")
      @layer += 1
    when "show"
      print_page("/show")
      @layer += 1
    when "quit"
      return "quit"
    when "help"
      help
    else
      puts "Unknown command `#{input}`. Type `help` if help is needed"
    end
    get_input
  end

  def layer_two_input(input)
    input_array = input.split(" ")
    if input_array.length > 1
      # go to and display comment data
    else
      number = /^(\d+)/.match(input).to_s
      if number == ""
        # not a number
      else
        n = number.to_i - 1
        if n < @current_page.posts.length
          puts @current_page.format_article_data(n)
        else
          puts "number too high: #{n + 1} is there when #{@current_page.posts.length} is max"
        end
      end
    end
    get_input
  end


  # Prints the content of a page in order, sets the `@current_page`
  # @params - route: String
  def print_page(route)
    @current_page = NewsPage.new(Scraper.scrape_posts(WEBSITE + route))
    # for now, only 5 results
    puts @current_page.format_page_data(0, 5)
  end

  # get and format user input, change layer if needed
  # return - user input line to indicate the layer
  def get_input
    @layer.times { print ">" }
    print " "
    input = gets.chomp.downcase
    if input == "!" && @layer > 1
      @layer -= 1
      get_input
    else
      input
    end
  end

  def help
    puts "When in > (layer 1)"
    puts "  `news`  - go to new messages"
    puts "  `front` - go to today's top posts"
    puts "  `ask`   - got to the question board"
    puts "  `show`  - go to the show section"
    puts "When in >> (layer 2)"
    puts "  `n`          - view info on post n"
    puts "  `comments n` - open the comments of the post"
    puts "When in any layer"
    puts "`help` - display this menu"
    puts "`!`  - go to previous layer"
    puts "`quit` - exit program"
  end
 end
