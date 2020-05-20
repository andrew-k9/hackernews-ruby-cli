# Agnostic of nokogiri
# Invokes the `Scraper` class
class Cli
  attr_accessor :layer, :current_page, :current_comments

  WEBSITE = "https://news.ycombinator.com".freeze
  PAGES = %w[news front ask show].freeze

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
  end

  # actions defined on the first layer of input,
  # loads in articles or prints help message
  # @params - input: String
  # returns - user input to be used in the loop in `call`
  def layer_one_input(input)
    if PAGES.include?(input)
      sets_and_display_page("/#{input}")
      @layer += 1
    else
      input = other_input(input)
    end
    input == "quit" ? input : format_input
  end

  # actions defined on the second layer of input, displays info about
  # articles or comments
  # @params - input: String
  # returns - user input to be used in the loop in `call`
  def layer_two_input(input)
    if input.include?("comment")
      display_comments(input.split(" ").last, input)
    elsif number?(input)
      display_single_article(input.to_i - 1)
    else
      input = other_input(input)
    end
    input == "quit" ? input : format_input
  end

  # displays one article from a list of articles
  # @params - number: Int
  def display_single_article(number)
    if number < @current_page.posts.length
      puts @current_page.format_article_data(number)
    else
      puts "number too high: #{n + 1} is there when
        #{@current_page.posts.length} is max"
    end
  end

  # display the comments for the article `number`
  # @param - number: Int
  def display_comments(number, input)
    if number?(number)
      display_comments_length_logic(number.to_i, @current_page.posts.length)
    else
      puts error_message(input)
    end
  end

  # only here since rubocop was complaining
  # @params - number: Int, bound: Int
  def display_comments_length_logic(number, bound)
    if number > bound
      puts invalid_number_error(number, bound)
    else
      sets_and_display_comments(@current_page.posts[number - 1][:comment_link])
    end
  end

  # Prints the content of the comments in the highest points of the comment
  # trees if any
  # @params - comment_url: String
  def sets_and_display_comments(comment_url)
    @current_comments = CommentsPage.new(Scraper.scrape_comments(comment_url))
    puts @current_comments.format_comment_page_data(0, 5)
  end

  # Prints the content of a page in order, sets the `@current_page`
  # @params - route: String
  def sets_and_display_page(route)
    # 'news' should always be up to date!
    unless updateable?(route)
      @current_page = NewsPage.new(Scraper.scrape_posts(WEBSITE + route))
    end
    # for now, only 5 results
    puts @current_page.format_page_data(0, 5)
  end

  # another rubocop statement that needed to be extracted
  # @params - route: String
  # returns - bool if @current_page needs updating
  def updateable?(route)
    !@current_page.nil? &&
      @current_page.page_link == WEBSITE + route &&
      route != "/news"
  end
end
