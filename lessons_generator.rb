words_hash = {}
line_words_array = []
all_words_array = []

words_popularity_hash = {}

probabilities_hash = {}

wordcounts = []

randomizer_words_array = []
opening_words_array = []
#closing_words_array = []

# text_directory = ARGV[0]
# I originally had it so you could put in the dir through ARGV, but this only worked on Linux and not Windows for some reason
# Basically, for cross-platform standardization, just put all your lessons in a sub-directory

# Iterates over all the files, and logs which words are likely to follow which, and gets all the wordcounts
Dir.glob("*/*.txt") do |file_location|
  wordcount_tally = 0
  File.open(file_location, 'r') do |file|
    file.each_line do |line|
      line_words_array = line.split(" ")
      wordcount_tally += line_words_array.length
      if line_words_array.any?
        line_words_array.each_with_index do |word, word_index|
          if words_hash["#{word}"] && word_index < line_words_array.length-1
            words_popularity_hash["#{word}"] += 1
              words_hash["#{word}"] << line_words_array[word_index+1]
          elsif words_hash["#{word}"]
            words_popularity_hash["#{word}"] += 1
          elsif word_index < line_words_array.length-1
            words_hash["#{word}"] = [line_words_array[word_index+1]]
            words_popularity_hash["#{word}"] = 1
          end
          #Also stores opening words in their own special array, so the text can be opened appropriately
          opening_words_array << word if word_index == 0
          #I considered doing closing words the same way as opening words, but decided against it because it might be even weirder than Markov
          #closing_words_array << word if word_index == line_words_array.length-1
        end
      end
    end
  end
  wordcounts << wordcount_tally
end

words_hash.each do |word, following_words|
  # file.write("#{word}\t#{following_words}\n")
  following_words.each do |following_word|
    # float_holder = 1.to_f/following_words.length.to_f
    if probabilities_hash["#{word}"]
      if probabilities_hash["#{word}"]["#{following_word}"]
        probabilities_hash["#{word}"]["#{following_word}"] += 1
      else
        probabilities_hash["#{word}"]["#{following_word}"] = 1
      end
    else
      probabilities_hash["#{word}"] = {"#{following_word}" => 1}
    end
  end
    all_words_array << word
end

# Picks an opener from the opening words
random_word = opening_words_array.sample

word_count_average = wordcounts.reduce(:+).to_f / wordcounts.size
word_count_deviation = (word_count_average*0.1).round(0)

# Generates a word count based on the average word count of the documents, then adds or subtracts within a range of -10% and +10%
word_count = (word_count_average + rand(-word_count_deviation..word_count_deviation)).to_i

new_lesson = File.open("new_lesson.txt", 'w')

print "#{random_word.capitalize} "
new_lesson.write("#{random_word.capitalize} ")
counter = 0
word_count.times do
  counter += 1

  if probabilities_hash[random_word]
    probabilities_hash[random_word].each do |following_word, probability|
      probability.times do
        randomizer_words_array << following_word
      end
    end
    if counter == word_count
      # If it is the last word, strip out all punctuation that may/may not be there, and add a period, just to be safe
      random_word = "#{randomizer_words_array.sample.gsub(/[^\w\s\d]/, '')}."
    else
      random_word = randomizer_words_array.sample
    end
    print "#{random_word.chomp(')').chomp('(')} "
    new_lesson.write("#{random_word.chomp(')').chomp('(')} ")
    randomizer_words_array = []
  else
    puts "\n"
    random_word = opening_words_array.sample
    print "#{random_word.capitalize} "
    new_lesson.write("\n#{random_word.capitalize} ")
  end
end

print "\nThe ending of the words is ALMSIVI."
new_lesson.write("\nThe ending of the words is ALMSIVI.")

new_lesson.close