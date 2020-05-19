# Blueprint for the webpage
# Store all page instances
class NewsPage
  attr_accessor :posts

  def initialize(page_url:, posts:)
    @posts = posts
    @page_url = page_url
  end

end
