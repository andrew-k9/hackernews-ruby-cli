require "./config/environment"

Cli.new.call
past = Scraper.scrape_posts "https://news.ycombinator.com/front"
#news = Scraper.scrape_posts "https://news.ycombinator.com/news"
#ask = Scraper.scrape_posts "https://news.ycombinator.com/ask"
#show = Scraper.scrape_posts "https://news.ycombinator.com/show"
#comment_data = Scraper.scrape_comments "https://news.ycombinator.com/item?id=23208779"
binding.pry
