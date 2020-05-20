# Scrapes the webpage using nokogiri
# Don't output to the user
class Scraper
  WEBSITE = "https://news.ycombinator.com".freeze
  class << self
    def scrape_posts(news_url)
      html = Nokogiri::HTML(HTTParty.get(news_url).body)
      posts = []
      # `subtexts` is an array of all the gray text under the article links
      # they match up 1-1 with the number of `.athing`s, so the `i` var in
      # the w/ index block matches that article's  subtext

      subtexts = html.css(".subtext")
      html.css(".athing").each_with_index do |post, i|
        post_values = scrape_posts_helper(post, {})
        post_values = scrape_posts_helper_subtexts(subtexts[i], post_values)
        posts << post_values
      end
      { page_link: news_url, posts: posts }
    end

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

    def scrape_comments_helper(comment)
      comment_hash = {}
      comment_hash[:author] = comment.css(".hnuser").text
      comment_hash[:age] = comment.css(".age").text
      comment_hash[:body] = comment.css(".comment .c00").text
      comment_hash
    end

    # Comment.new(
    #   author: comment.css(".hnuser").text,
    #   age: comment.css(".age").text,
    #   body: comment.css(".comment .c00").text
    # )

    def scrape_posts_helper(post, post_values)
      post_values[:post_id] = post.attributes["id"].value
      post_values[:article_link] =
        post.css(".title a")[0].attributes["href"].value
      post_values[:title] = post.css(".storylink").text
      post_values[:comment_link] = WEBSITE + "/item?id=#{post_values[:post_id]}"
      post_values
    end

    def scrape_posts_helper_subtexts(subtext, post_values)
      only_number = /^(\d+)/
      post_values[:post_author] = subtext.css(".hnuser").text
      comment_number = subtext.css("a").last.children.text
      post_values[:points] =
        only_number.match(subtext.css(".score").text).to_s
      post_values[:comment_count] =
        comment_number == "discuss" ? 0 : only_number.match(comment_number).to_s
      post_values
    end
  end
end
