class Comment
  # TODO: rename all instances of Comment to "top comments"
  attr_reader :author, :age, :body

  COMMENT_MAX = 250
  BREAKER = "-----------------------".freeze

  def initialize(author:, age:, body:)
    @author = author
    @age = age
    @body = body
  end

  # formats a single comment
  def format
    "#{@author} says:\n#{@body[0..COMMENT_MAX]}#{
      '...' if @body.length > COMMENT_MAX}\n#{BREAKER}"
  end
end
