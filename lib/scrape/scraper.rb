# Scrapes the webpage using nokogiri
# Don't output to the user
class Scraper
  WEBSITE = "https://news.ycombinator.com".freeze
  class << self
    # scrape website for aricles on a given page
    # @params - news_url: String
    # returns hash of formatted posts
    def scrape_posts(news_url)
      html = Nokogiri::HTML(HTTParty.get(news_url).body)
      posts = []
      # `subtexts` is an array of all the gray text under the article links
      # they match up 1-1 with the number of `.athing`s, so the `i` var in
      # the w/ index block matches that article's  subtext
      subtexts = html.css(".subtext")
      html.css(".athing").each_with_index do |post, i|
        post_values = scrape_posts_helper(post)
        scrape_posts_helper_subtexts(post_values, subtexts[i])
        posts << post_values
      end
      NewsPage.new(page_link: news_url, posts: posts)
    end

    # scrape website for aricles on a given page
    # @params - news_url: String
    # returns hash of formatted posts
    def scrape_comments(comment_url)
      html = Nokogiri::HTML(HTTParty.get(comment_url).body)
      top_comments = []
      comments = html.css(".athing.comtr").select do |comment|
        comment.css(".ind img").last.attributes["width"].value == "0"
      end
      comments.each do |comment|
        top_comments << scrape_comments_helper(comment)
      end
      { page_link: comment_url, top_comments: top_comments }
    end

  # Private methods for helpers to the corresponding methods
  private

    def scrape_comments_helper(comment)
      comment_hash = {}
      comment_hash[:author] = comment.css(".hnuser").text
      comment_hash[:age] = comment.css(".age").text
      comment_hash[:body] = comment.css(".comment .c00").text
      comment_hash
    end

    def scrape_posts_helper(post)
      post_id = post.attributes["id"].value
      Article.new(
        post_id: post_id,
        article_link: post.css(".title a")[0].attributes["href"].value,
        title: post.css(".storylink").text,
        comment_link: WEBSITE + "/item?id=#{post_id}"
      )
    end

    def scrape_posts_helper_subtexts(post_values, subtext)
      only_number = /^(\d+)/
      number = subtext.css("a").last.children.text
      count = number == "discuss" ? 0 : only_number.match(number).to_s
      post_values.add_subtext(
        post_author: subtext.css(".hnuser").text,
        points: only_number.match(subtext.css(".score").text).to_s,
        comment_count: count
      )
    end
  end
end
