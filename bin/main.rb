require "./config/environment"

Cli.new.call
page_data = Scraper.scrape_posts "https://news.ycombinator.com/front"
comment_data = Scraper.scrape_comments "https://news.ycombinator.com/item?id=23208779"
binding.pry
