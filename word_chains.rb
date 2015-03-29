require 'set'

class WordChainer

  def initialize(dictionary_file_name)
    @dictionary = Set.new(File.readlines(dictionary_file_name).map(&:chomp))
  end

  def adjacent_words(word)
    @dictionary.select do |word_check|
      one_off?(word, word_check)
    end
  end

  def one_off?(base_word, word)
    return false unless word.length == base_word.length
    count = 0
    word.length.times do |idx|
      count += 1 unless word[idx] == base_word[idx]
    end
    count == 1
  end


  def run(source, target)
    @current_words = [source]
    @all_seen_words = [source]

    until @current_words.empty?
      new_current_words = []

      @current_words.each do |word|
        adjacent_words(word).each do |adjacent_word|
          next if @all_seen_words.include?(adjacent_word)
          new_current_words << adjacent_word
          @all_seen_words << adjacent_word
        end
      end

      puts new_current_words
      @current_words = new_current_words
    end
  end



end
