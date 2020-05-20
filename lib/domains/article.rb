class Article
  attr_reader :post_id, :article_link, :title, :comment_link,
              :post_author, :points, :comment_count

  def initialize(post_id:, article_link:, title:, comment_link:)
    @post_id = post_id
    @article_link = article_link
    @title = title
    @comment_link = comment_link
  end

  # adds remaining accessors
  def add_subtext(post_author:, points:, comment_count:)
    @post_author = post_author
    @points = points
    @comment_count = comment_count
  end

  # returns a single article in short form
  def short_article_info
    "#{@title}\n  comments: #{@comment_count}"
  end

  # returns all info on a single article
  def long_article_info
    top_level = /.+\.com|.+\.net|.+\.gov|.+\.org|.+\.edu|.+\.io/
    http_split = %r{\/\/|www\.}
    domain = top_level.match(@article_link.split(http_split).last)
    "#{@title} (#{domain})\n by #{@post_author} | points: #{
      @points} | comments:#{@comment_count}\n Link: #{@article_link}"
  end
end
