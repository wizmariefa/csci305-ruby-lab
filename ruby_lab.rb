
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Marie Morin
# mariecolee1@gmail.com
#
###############################################################

$bigrams = Hash.new # The Bigram data structure
$name = "Marie Morin"

# function to process each line of a file and extract the song titles
def process_file(file_name)
	puts "Processing File.... "

	begin
		if RUBY_PLATFORM.downcase.include? 'mswin'
			file = File.open(file_name)
			unless file.eof?
				file.each_line do |line|
					# do something for each line (if using windows)
					# do not touch this! You have a Mac!
				end
			end
			file.close
		else
			IO.foreach(file_name, encoding: "utf-8") do |line|
				title = cleanup_title line
					if title != nil
						addtoB(title)
					end
			end
		end

		search = ""
#		while search != "q" # continues while user doesn't enter 1
#			puts("Enter a word [Enter 'q' to quit]:") # prompts for user input
#			search = $stdin.gets.chomp # get input from user
#			if (search != "q") # if they typed in q, we don't want to create a title
#				print(create_title(search)) # creates and prints title
#			end
#			puts "" # extra line for prettiness! ~
#		end
	end
		puts "Finished. Bigram model built.\n"
	rescue
		STDERR.puts "Could not open file"
		exit
	end

# This method "cleans up" the title. In here, we remove the preceding characters,
# the additional characters that don't make up song titles but are present, strip
# all punctuation, and remove titles with non-english characters.
def cleanup_title(songTitle)
	title = songTitle.gsub(/(.)+<SEP>/, "") # strips everything but title
	title = title.gsub(/(([\(\[\{\\\/\_\-\:\"\`\+\=\*]|(feat\.)).*)/, "") # strips non-song title items
	title = title.gsub(/[\?\¿\!\¡\.\;\&\@\%\#\|]/, "") # strips punctuation
	if title =~ (/[^\x00-\x7F]+/) # eliminates (most) non-english titles
		return nil
	end
	title = title.downcase # converts title to lowercase
	return title
end

# In this function, we add the title to the bigram. We do this by adding the first word
# and creating its own hash, and adding the words that come directly after to its own
# hash map. We do this for every word that appears in the title, adding only the word
# following directly after. This tripped me up at first, as i tried adding every word
# behind the current word for the entire sentence.
def addtoB(title)
	#title = "let's see what this is doing"
	stops = [" a ", " an ", " and ", " by ", " for ", " from ", " in ", " of ", " on ", " or ", " out ", " the ", " to ", " width "] # list of stop words
	for word in stops do # go through the stop words: if they exist in the sentence, we will...
			title = title.gsub(word, " ") # changes word to NOTHING! Well, a space I guess. but still.
		end

	title_words = title.split(" ") # splits title into various words

	while (title_words.length > 1)
		first_word = title_words[0] # saves the first word to title bigram
		next_wrd = title_words[1] # the next word in the title is the one we want to add
		title_words = title_words[1..-1] # chops off the first word and proceeds through

		if ($bigrams.has_key?(first_word)) # if we already have a key, we don't need a new hash
			# do nothing
		else
			$bigrams[first_word] = Hash.new # if word hasn't been encountered before, give it a new hash
		end
				if ($bigrams[first_word].has_key?(next_wrd)) # if the next word exists for the current word...
					$bigrams[first_word][next_wrd] = $bigrams[first_word][next_wrd] + 1 # then all we're doing is incrementing the count for that word by one.
				else
				$bigrams[first_word].merge!(next_wrd => 1) # otherwise, we will set the count of that word to one.
			end
		end
	end

# this function finds the most common following word, if the word exists in the
# bigram hash map. If not, it returns nil and breaks out of the title consruction
# while loop.
def mcw(search)
		if !$bigrams.has_key?(search) # if the search word doesn't exist in the bigram...
			most_common = nil # we're going to return nil.

		else most_common = $bigrams[search].max_by{|word, number| number}[0] # search for max by # of maxes
		end

		return most_common
end

# This function creates a song title beginning with a given word, based on the return
# values of the MCW function above. IT doesn't allow for titles longer than 20 words.
def create_title(word)
	current = word
	word_num = 1 # begin word number at one
	title = "" # title begins as empty
	title += word # add current word
	while word_num !=20 # while we have less than 20 words...
			if ($bigrams.has_key?(current)) # if the word exists in the bigram
				if (mcw(current) == nil)
					# do nothing and exit
					word_num = 20
				else
					addition = mcw(current) # thing to add is mcw
					title += " " # add space for readability
					title += addition # add addition to the title
					current = addition # set current to the new wordtitle += addition # add the mcw
					word_num += 1 # increment by one and then go throuh
				end
			else word_num = 20 # otherwise, we exit
			end
		end
		return title
end

# Executes the program
def main_loop()
	puts "CSCI 305 Ruby Lab submitted by #{$name}"

	if ARGV.length < 1
		puts "You must specify the file name as the argument."
		exit 4
	end

	# process the file
	process_file(ARGV[0])

	# Get user input
end

if __FILE__==$0
	main_loop()
end
