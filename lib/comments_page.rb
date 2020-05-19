# Blueprint for the webpage
class CommentsPage
  attr_accessor :page_link, :top_comments

  COMMENT_MAX = 250

  def initialize(page_link:, top_comments:)
    @page_link = page_link
    @top_comments = top_comments
  end

  # formats every element in post from start index to stop index
  # @params - start: Int, stop: Int
  # returns a formatted array for screen output
  def format_comment_page_data(start, stop)
    @top_comments[start..stop].each_with_index.map do |comment, i|
      "#{i + 1}: #{comment[:author]} says:\n
        #{comment[:body][0..COMMENT_MAX]}#{
          '...' if comment[:body].length > COMMENT_MAX}\n\n"
    end
  end
end
