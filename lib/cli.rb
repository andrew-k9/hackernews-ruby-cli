# Agnostic of nokogiri
# Invokes the `Scraper` class
class Cli
  attr_accessor :layer, :current_page, :current_comments

  PAGES = %w[newest front ask show].freeze
  MAX_COLLECTION = 10

  def initialize
    @layer = 1
  end

  # main loop for the program
  def call
    IoManager.greeting
    input = format_input
    until input == "quit"
      input = @layer == 1 ? layer_one_input(input) : layer_two_input(input)
    end
    IoManager.goodbye
  end

private

  # get and format user input, change layer if needed
  # return - user input line to indicate the layer
  def format_input
    hash = IoManager.parse_layer_input(@layer)
    @layer = hash[:layer]
    hash[:input]
  end

  # actions defined on the first layer of input,
  # loads in articles or prints help message
  # @params - input: String
  # returns - user input to be used in the loop in `call`
  def layer_one_input(input)
    if PAGES.include?(input)
      update_current_page("/#{input}")
      IoManager.print_article_array(@current_page
        .format_page_data(0, MAX_COLLECTION - 1))
      @layer += 1
    else
      input = IoManager.global_input_layer(input, layer)
    end
    input == "quit" ? input : format_input
  end

  # actions defined on the second layer of input, displays info about
  # articles or comments
  # @params - input: String
  # returns - user input to be used in the loop in `call`
  def layer_two_input(input)
    if validate?(input)
      index = input.split(" ").last.to_i - 1
      display_comments_of_post(index)
    elsif number_and_less_than_max?(input)
      IoManager.print_single_article(@current_page
        .format_article(input.to_i - 1))
    else
      input = IoManager.global_input_layer(input, layer)
    end
    input == "quit" ? input : format_input
  end

  def number_and_less_than_max?(input)
    number?(input) && input.to_i.positive? && input.to_i <= MAX_COLLECTION
  end

  # puts the formatted comments for a given post
  # @params - post_index: Int
  def display_comments_of_post(post_index)
    post = @current_page.posts[post_index]
    if post.nil?
      IoManager.invalid_number_error(post_index, @current_page.posts.length)
    else
      update_current_comments(post.comments_link)
      IoManager.print_comment_array(@current_comments
        .format_all[0...MAX_COLLECTION])
    end
  end

  # one off to check if the input includes comment and the number is positive
  def validate?(input)
    number = input.split(" ").last.to_i
    input.include?("comment") && number.positive? && number <= MAX_COLLECTION
  end

  # Prints the content of the comments in the highest points of the comment
  # trees if any
  # @params - comment_url: String
  def update_current_comments(comment_url)
    @current_comments = CommentScraper.scrape_comments(comment_url)
  end

  # Prints the content of a page in order, sets the `@current_page`
  # @params - route: String
  def update_current_page(route)
    return if !@current_page.nil? && @current_page.updateable?(route)

    @current_page = ArticleScraper.scrape_posts(route)
  end

  def number?(string)
    /^(\d+)/.match(string).to_s != ""
  end
end
