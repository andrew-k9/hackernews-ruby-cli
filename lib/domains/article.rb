class Article
  attr_reader :post_id, :external_link, :title, :comments_link,
              :post_author, :points, :comment_count

  WEBSITE = "https://news.ycombinator.com".freeze

  # TODO: rename `external_lin k` to external link and comments_link
  #  - just naming it `external_link` is confusing in `Article`
  def initialize(post_id:, external_link:, title:, comments_link:)
    @post_id = post_id
    @external_link = external_link
    @title = title
    @comments_link = comments_link
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
    "#{@title} (#{domain(@external_link)})\n by #{@post_author} | points: #{
      @points} | comments:#{@comment_count}\n Link: #{@external_link}"
  end

private

  def top_level(string)
    /.+\.com|.+\.net|.+\.gov|.+\.org|.+\.edu|.+\.io/.match(string)
  end

  def http_split(string)
    string.split(%r{\/\/|www\.}).last
  end

  def domain(string)
    top_level(http_split(string))
  end
end
