class Comment
  # TODO: rename all instances of Comment to "top comments"
  attr_reader :author, :age, :body

  COMMENT_MAX = 500

  def initialize(author:, age:, body:)
    @author = author
    @age = age
    @body = body
  end

  # formats a single comment
  def format
    body = @body[0..COMMENT_MAX]
    author = Colerizer.author_style(@author)
    "#{author} says:\n#{body}#{
      '...' if @body.length > COMMENT_MAX}\n"
  end
end
