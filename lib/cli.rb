# Agnostic of nokogiri
# Invokes the `Scraper` class
class Cli
  attr_accessor :layer, :current_page, :current_comments

  WEBSITE = "https://news.ycombinator.com".freeze

  def initialize
    @layer = 1
  end

  # main loop for the program
  def call
    # TODO: Add in more instructions about what each layer does
    puts "Running application, type `help` for help"
    input = format_input
    until input == "quit"
      input = @layer == 1 ? layer_one_input(input) : layer_two_input(input)
    end
    binding.pry
  end

  # actions defined on the first layer of input, loads in articles or prints help message
  # @params - input: String
  # returns - user input to be used in the loop in `call`
  def layer_one_input(input)
    case input
    when "news"
      sets_and_display_page("/news")
      @layer += 1
    when "front"
      sets_and_display_page("/front")
      @layer += 1
    when "ask"
      sets_and_display_page("/ask")
      @layer += 1
    when "show"
      sets_and_display_page("/show")
      @layer += 1
    when "quit"
      return "quit"
    when "help"
      help
    else
      puts error_message(input)
    end
    format_input
  end

  def layer_two_input(input)
    if input.include? "comment"
      number = input.split(" ").last
      if number?(number)
        sets_and_display_comments(@current_page.posts[number.to_i - 1][:comment_link])
      else
        puts error_message(input)
      end
    else
      if number?(input)
        n = input.to_i - 1
        if n < @current_page.posts.length
          puts @current_page.format_article_data(n)
        else
          puts "number too high: #{n + 1} is there when #{@current_page.posts.length} is max"
        end
      else
        puts error_message(input)
      end
    end
    format_input
  end

  def number?(string)
    /^(\d+)/.match(string).to_s != ""
  end

  # Prints the content of the comments in the highest points of the comment trees (if any)
  # @params - comment_url: String
  def sets_and_display_comments(comment_url)
    @current_comments = CommentsPage.new(Scraper.scrape_comments(comment_url))
    puts @current_comments.format_comment_page_data(0, 5)
  end

  # Prints the content of a page in order, sets the `@current_page`
  # @params - route: String
  def sets_and_display_page(route)
    # 'news' should always be up to date!
    unless !@current_page.nil? && @current_page.page_link == WEBSITE + route && route != "/news"
      @current_page = NewsPage.new(Scraper.scrape_posts(WEBSITE + route))
    end
    # for now, only 5 results
    puts @current_page.format_page_data(0, 5)
  end

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

  # displays error message of the incorrect input value
  # @params - input: String
  # returns - formatted error message string
  def error_message(input)
    "Unknown command `#{input}`. Type `help` if help is needed"
  end

  # rubocop complained so I wrote this more... interestingly
  def help
    puts "When in > (layer 1)\n" + "  `news`  - go to new messages"
    puts "  `front` - go to today's top posts"
    puts "  `ask`   - got to the question board"
    puts "  `show`  - go to the show section"
    puts "When in >> (layer 2)"
    puts "  `n`          - view info on post n"
    puts "  `comments n` - open the comments of the post"
    puts "When in any layer\n" + "`help` - display this menu"
    puts "`!`  - go to previous layer\n" + "`quit` - exit program"
  end
end
