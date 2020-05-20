# Scrapes the webpage using nokogiri
# Don't output to the user
class CommentScraper
  WEBSITE = "https://news.ycombinator.com".freeze
  class << self
    # scrape website for aricles on a given page
    # @params - news_url: String
    # returns hash of formatted posts
    def scrape_comments(comment_url)
      html = Nokogiri::HTML(HTTParty.get(comment_url).body)
      top_comments = []
      # selects all top-level comments that we're interested in
      comments = html.css(".athing.comtr").select do |comment|
        comment.css(".ind img").last.attributes["width"].value == "0"
      end
      comments.each do |comment|
        top_comments << scrape_comments_helper(comment)
      end
      CommentsPage.new(page_link: comment_url, top_comments: top_comments)
    end

  # Private methods for helpers to the corresponding methods
  private

    def scrape_comments_helper(comment)
      Comment.new(
        author: comment.css(".hnuser").text,
        age: comment.css(".age").text,
        body: comment.css(".comment .c00").text
      )
    end
  end
end
