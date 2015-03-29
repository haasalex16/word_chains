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
    @all_seen_words = {source => nil}
    puts "Building library...\n\n"

    until @current_words.empty? || @current_words.include?(target)
      explore_current_words
    end
    puts "Building path...\n\n"
    puts build_path(target)
  end

  def explore_current_words
    new_current_words = []

    @current_words.each do |current_word|

      adjacent_words(current_word).each do |adjacent_word|

        next if @all_seen_words.keys.include?(adjacent_word)
        new_current_words << adjacent_word
        @all_seen_words[adjacent_word] = current_word
      end
    end

    @current_words = new_current_words
  end

  def build_path(target)
    path = [target]
    next_step = target
    until @all_seen_words[next_step].nil?
      path << @all_seen_words[next_step]
      next_step = @all_seen_words[next_step]
    end

    path.length == 1 ? "No Path Found" : path
  end

end

if __FILE__ == $PROGRAM_NAME
  puts "Where do you want to start?"
  source = gets.chomp.downcase
  target = ""

  until target.length == source.length
    puts"Where do you want to end?"
    target = gets.chomp.downcase
    unless target.length == source.length
      puts "Please choose equal length words"
    end
  end

  chain = WordChainer.new('dictionary.txt')
  chain.run(source, target)

end
