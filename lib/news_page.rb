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

  # formats one element in @posts
  # @params - index: Int
  # returns a formatted string for screen output
  def format_article_data(index)
    str = ""
    post = posts[index]
    top_level = /.+\.com|.+\.gov|.+\.org|.+\.edu|.+\.io/
    http_split = /\/\/|www\./
    domain = top_level.match(post[:article_link].split(http_split).last)
    str += "#{post[:title]} (#{domain})\n"
    str += "by #{post[:post_author]} | points: #{post[:points]} | comments: #{post[:comment_count]}\n"
    str += "Link: #{post[:article_link][0..50]}#{"..." if post[:article_link].length > 50}"
  end
end
