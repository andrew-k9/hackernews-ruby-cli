# Blueprint for the webpage
class NewsPage
  attr_accessor :page_link, :posts

  def initialize(page_link:, posts:)
    @posts = posts
    @page_link = page_link
  end

  # formats every element in post from start index to stop index
  # @params - start: Int, stop: Int
  # returns a formatted array for screen output
  def format_page_data(start, stop)
    @posts[start..stop].each_with_index.map do |post, i|
      "#{i + 1}. #{post.short_article_info}"
    end
  end

  # formats one element in @posts
  # @params - index: Int
  # returns a formatted string for screen output
  def format_article(index)
    if index > @posts.length
      IoManager.invalid_number_error_string(index, @posts.length)
    else
      @posts[index].long_article_info
    end
  end

  # a page is updateable if the route isn't news and it isn't the current page
  def updateable?(new_route)
    good_routes = %w[newest front ask show]
    route = @page_link.split(".com").last
    route != new_route && good_routes.include?(new_route)
  end

  def valid_post?(index)
    index < @posts.length
  end
end
