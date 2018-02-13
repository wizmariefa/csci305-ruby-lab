
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
		while search != "q"
			puts("Enter a word [Enter 'q' to quit]:")
			search = $stdin.gets.chomp
			if (search != "q")
				print(create_title(search))
			end
			puts ""
		end
	end
		puts "Finished. Bigram model built.\n"
	#rescue
		#STDERR.puts "Could not open file"
		#exit
	end

def cleanup_title(songTitle)
	title = songTitle.gsub(/(.)+<SEP>/, "") # strips everything but title
	title = title.gsub(/(([\(\[\{\\\/\_\-\:\"\`\+\=\*]|(feat\.)).*)/, "") # strips non-song title items
	title = title.gsub(/[\?\¿\!\¡\.\;\&\@\%\#\|]/, "") # strips punctuation
	if title =~ (/[^\x00-\x7F]+/) # eliminates (most) non-english titles
		return nil
	end
	title = title.downcase
	return title
end

def addtoB(title)
	#title = "let's see what this is doing"
	stops = [" a ", " an ", " and ", " by ", " for ", " from ", " in ", " of ", " on ", " or ", " out ", " the ", " to ", " width "]
	for word in stops do
			title = title.gsub(word, "") # changes word to NOTHING!
		end

	title_words = title.split(" ") # splits title into various words

	while (title_words.length > 1)
		first_word = title_words[0] # saves the first word to title bigram
		next_wrd = title_words[1]
		title_words = title_words[1..-1]

		if ($bigrams.has_key?(first_word))
			# do nothing
		else
			$bigrams[first_word] = Hash.new
		end
				if ($bigrams[first_word].has_key?(next_wrd))
					$bigrams[first_word][next_wrd] = $bigrams[first_word][next_wrd] + 1
				else
				$bigrams[first_word].merge!(next_wrd => 1)
			end
		end
	end

def mcw(search)
		if !$bigrams.has_key?(search)
			most_common = nil

		else most_common = $bigrams[search].max_by{|word, number| number}[0] # search for max by # of maxes
		end

		return most_common
end

def create_title(word)
	current = word
	word_num = 1
	title = ""
	title += word
	while word_num !=20 # while we have less than 20 words...
			if ($bigrams.has_key?(current)) # if the word exists in the bigram
				if (mcw(current) == nil)
					# do nothing and exit
					word_num = 20
				else
					addition = mcw(current) # thing to add is mcw
					title += " "
					title += addition
					current = addition # set current to the new wordtitle += addition # add the mcw
					word_num += 1 # increment by one and then go throuh
				end
			else word_num = 20
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
