require_relative "../db/domain_color_index.rb"
class Colerizer
  class << self
    LANGUAGES = ["ruby", "javascript", "js", "java script", "typescript",
                 "swift", "python", "rust", "c", "c++", "c#", "java",
                 "haskell"].freeze
    TOPICS = %w[security math algorithms linux].freeze
    FRAMEWORKS = ["rails", "react", "react native", "unity"].freeze
    ALIAS = {
      javascript: %w[js javascript],
      react_native: ["rn"],
      cpp: ["c++"],
      cs: ["c#"],
    }.freeze

    def print_color_for_language_topic_framework(string)
      word_indicies_to_colorize = []
      string.downcase.split(" ").each_with_index do |word, i|
        if LANGUAGES.include?(word) || TOPICS.include?(word) ||
           FRAMEWORKS.include?(word)
          word_indicies_to_colorize << i
        end
      end
      puts color_words_from_indicies(string, word_indicies_to_colorize)
    end

    def link_style(string)
      Rainbow(string).italic
    end

    def author_style(string)
      Rainbow(string).bold.italic
    end

    def comment_break_style(string)
      Rainbow(string).bold
    end

  private

    def color_words_from_indicies(string, index_array)
      return string if index_array.empty?

      i = 0
      string.split(/ /).each_with_index.map do |word, j|
        if index_array[i] == j
          i += 1
          color_word_on_domain(word)
        else
          word
        end
      end.join(" ")
    end

    def color_word_on_domain(word)
      color = "white"
      word_alias = change_to_alias(word.downcase)
      DOMAIN_COLORS.each do |_key, value|
        color = value[word_alias.to_sym] if value.key?(word_alias.to_sym)
      end
      Rainbow(word).send(color)
    end

    def change_to_alias(word)
      ALIAS.each do |key, value|
        word = key.to_s if value.include?(word)
      end
      word
    end
  end
end
