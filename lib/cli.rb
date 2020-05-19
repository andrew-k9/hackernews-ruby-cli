 # Agnostic of nokogiri
 # Invokes the `Scraper` class
 class Cli
  attr_accessor :layer, :current_page
  WEBSITE = "https://news.ycombinator.com".freeze

  def initialize
    @layer = 1
  end

  def call
    puts "Running application, type `help` for help"
    input = get_input
    until input == "quit"
      input = if @layer == 1
        layer_one_input(input)
      else
        layer_two_input(input)
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
  end


  # Prints the content of a page in order, sets the `@current_page`
  # @params - route: String
  def print_page(route)
    @current_page = NewsPage.new(Scraper.scrape_posts(WEBSITE + route))
    # for now, only 5 results
    puts @current_page.format_page_data(0, 5)
  end

  # returns user input line to indicate the layer
  def get_input
    @layer.times { print ">" }
    print " "
    gets.chomp.downcase
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
    puts "help - display this menu"
    puts "quit - exit program"
  end
 end
