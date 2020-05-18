require "./config/environment"

Cli.new.call
data = Scraper.scrape_posts "https://news.ycombinator.com/front"
binding.pry
