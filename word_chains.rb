# require 'byebug'

class WordChainer
  
  def initialize(dictionary)
    @dictionary = File.read(dictionary).split(' ')
    raise "Please give 2 command line arguments" if ARGV.size < 2
    start_word = ARGV.shift
    @end_word = ARGV.shift
    @current_words = [start_word]
    @all_seen_words = Hash[start_word, nil]
  end
  
  def run
    until @current_words.empty?
      new_current_words = []
      @current_words.each do |current_word|
        new_words = adjacent_words(current_word)
        new_words.each { |word| @all_seen_words[word] = current_word }
        if new_words.include?(@end_word)
          print "\n\nBuild path:"
          p build_path(@end_word)
          return
        end
        new_current_words.concat(new_words)
      end
      print "\n\nNew current words:"
      new_current_words.each { |word| print "#{word} " }
      @current_words = new_current_words
    end
  end
  
  def adjacent_words(word)
    len = word.size
    words = @dictionary.dup
    words.select! { |el| el.size == len}
    word = word.split('') #turn into arr
    result = []
    words.each do |el|
      el = el.split('')
      (0...len).each do |i|
        if word.take(i) == el.take(i) && word.drop(i + 1) == el.drop(i + 1) && word != el
          new_word = el.join('')
          result << new_word unless @all_seen_words.include?(new_word)
        end
      end
    end
    result
  end
  
  def build_path(target)
    return [target] if @all_seen_words[target] == nil
    (build_path(@all_seen_words[target])).concat([target])
  end
  
end

chainer = WordChainer.new("dictionary.txt")
chainer.run