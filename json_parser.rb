def tokenize(collect_strings)
	puts ", changed1 collect_strings = #{collect_strings}"
	collect_strings = collect_strings.gsub(',', ' , ')
	puts ", changed collect_strings = #{collect_strings}"
	collect_strings = collect_strings.gsub(':', ' : ')
	collect_strings = collect_strings.gsub('}', ' } ')
	collect_strings = collect_strings.gsub(']', ' ] ')
	collect_strings = collect_strings.gsub('{', ' { ')
	collect_strings = collect_strings.gsub(']', ' ] ')
	puts ", changed collect_strings = #{collect_strings}"
	collect_strings = collect_strings.gsub('"', ' ')
	puts "\" changed collect_strings = #{collect_strings}"
	puts"collect_strings"
	collect_strings = collect_strings.split(" ")
end

def error(message)
	puts "error_message = #{message}"
	exit
end

def parse_factory(tokens)
	#check for string
	str = parse_string(tokens)
	if !str
		return str
	end
	#check for object
	obj = parse_object(tokens)
	if !obj
		return obj
	end
	abort("This cannot be parsed")
end

#assume that the string is not alphanumeric and does not contain 
#underscopes
def parse_string(tokens)
	if tokens[0] == "\""
		puts "string matched"
		tokens = tokens[1..-1]
		index = tokens.index("\"")
		str = tokens[0..index-1]
		puts "result of parse_string"
		puts str, tokens[index+1..-1]
		return str, tokens[index+1..-1 ]
	else
		return nil
	end
end

puts "call parse_string(\"revanth\")"
parse_string("\"revanth\"cascascac")
# abort "what happened"

def parse_object(tokens)
	puts "in_parse_object tokens = #{tokens}"
	parsedObjects = []
	curr_token = tokens.shift
	
	if curr_token != '{'
		return nil
	elsif
		#parse the key
		key = parse_string(tokens.shift)
		puts "key = #{key}"
#		while tokens[0] != '}'
#			result = parse_string
#		end
	end
end





def print_num
	i = Array (1..100)
	(1..5).each do
		|j|
		puts "j = #{j}"
	end
	puts "numbers = #{i}"
end
filename = ARGV[0]
puts "filename = #{filename}"

file = open(filename, "r")
collect_strings = file.read
puts "collect_strings = #{collect_strings}"
puts "collect_strings.length = #{collect_strings.length}"
tokens = tokenize(collect_strings)
tokens = collect_strings
puts "tokens = #{tokens}"
#tokens.each_with_index do
#	|item, index|
#	puts "item[#{index}]  = #{item}"
#end

parse_object(tokens)

#print_num



