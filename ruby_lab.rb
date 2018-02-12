
#!/usr/bin/ruby
###############################################################
#
# CSCI 305 - Ruby Programming Lab
#
# Marie Morin
# mariecolee1@gmail.com
#
###############################################################

$bigrams = Hash.new(0) # The Bigram data structure
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
		#puts"Please Enter a Word: "
		#search = gets.chomp
		mcw("computer")

		puts "Finished. Bigram model built.\n"
	#rescue
		#STDERR.puts "Could not open file"
		#exit 4
	end
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
	title_words = title.split(/\W+/) # splits title into various words
	first_word = title_words[0] # saves the first word to title bigram
	title_words = title_words[1..-1]

	if ($bigrams.has_key?(first_word))
		# do nothing
	else
		$bigrams[first_word] = Hash.new(0)
	end

	if (title_words.length > 0)
		title_words.each { |word|
		$bigrams[first_word].store(word, $bigrams[first_word][word]+1) # stores in bigram hash for each words
	}
	end


	$bigrams.each { |key, value|
				puts "#{key} : #{value}"
				print()
			}
	end

def mcw(search)
	#hash.max_by{ |key,value| value }
	search = "computer"
	#result = $bigrams[search].values.max
	result = $bigrams[search]
	puts "#{result}"
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
