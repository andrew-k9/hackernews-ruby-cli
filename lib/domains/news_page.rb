# Blueprint for the webpage
class NewsPage
  attr_accessor :page_link, :posts

  WEBSITE = "https://news.ycombinator.com".freeze

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
      "number too high: #{index + 1} is there when #{bound} is max"
    else
      @posts[index].long_article_info
    end
  end

  def updateable?(route)
    @page_link == WEBSITE + route && route != "/news"
  end

  def valid_post?(index)
    index < @posts.length
  end
end
