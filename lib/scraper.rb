# Scrapes the webpage using nokogiri
# Don't output to the user
class Scraper
  WEBSITE = "https://news.ycombinator.com".freeze
  class << self
    def scrape_posts(news_url)
      html = Nokogiri::HTML(HTTParty.get(news_url))
      posts = []
      # `subtexts` is an array of all the gray text under the article links
      # they match up 1-1 with the number of `.athing`s, so the `i` var in
      # the w/ index block matches that article's  subtext
      subtexts = html.css(".subtext")
      only_number_regex = /^(\d+)/
      html.css(".athing").each_with_index do  |post, i|
        post_values = {}
        post_values[:post_id] = post.attributes["id"].value
        post_values[:article_link] = post.css(".title a")[0].attributes["href"].value
        post_values[:title] = post.css(".storylink").text
        post_values[:comment_link] = WEBSITE + "/item?id=#{post_values[:post_id]}"
        post_values[:post_author] = subtexts[i].css(".hnuser").text
        post_values[:points] = only_number_regex.match(subtexts[i].css(".score").text).to_s
        # at time of writing, the comments link is the last href in `subtext`
        comment_number = subtexts[i].css("a").last.children.text
        post_values[:comment_count] = comment_number == "discuss" ? 0 : only_number_regex.match(comment_number).to_s
        posts << post_values
      end
      posts
    end
  end
end
