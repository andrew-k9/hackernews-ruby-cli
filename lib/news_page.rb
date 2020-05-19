# Blueprint for the webpage
# Store all page instances
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
    len = @posts.length
    @posts[start..stop].each_with_index.map do |post, i|
      "#{i + 1}: #{post[:title]}\n" +
      "  #{post[:comment_count] == 0 ? "None" : post[:comment_count]} coment(s)\n"
    end
  end
end
