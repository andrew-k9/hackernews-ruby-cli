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
      "#{i + 1}: #{post[:title]}\n #{
        post[:comment_count] == '0' ? 'None' : post[:comment_count]} coments\n"
    end
  end

  # formats one element in @posts
  # @params - index: Int
  # returns a formatted string for screen output
  def format_article_data(index)
    post = posts[index]
    top_level = /.+\.com|.+\.net|.+\.gov|.+\.org|.+\.edu|.+\.io/
    http_split = %r{\/\/|www\.}
    domain = top_level.match(post[:article_link].split(http_split).last)
    "#{post[:title]} (#{domain})\n by #{post[:post_author]} | points: #{
      post[:points]} | comments:#{post[:comment_count]}\nLink: #{
      post[:article_link][0..50]}#{'...' if post[:article_link].length > 50}"
  end
end
