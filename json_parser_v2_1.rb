
def parse_backslash(tokens)
	if tokens[0] == '\\'
		value = ""
		case tokens[1]
		when 'n'
			value = "\n"
		when '"'
			value = "\""
		when 't'
			value = "\t"
		when '\\'
			value = "\\"
		else
			abort("not added")
		end
		return value, tokens[2..-1]
	else
		abort("wrongly called\n")
	end
end



def parse_string(tokens)
	tokens = tokens.lstrip()
	if tokens[0] == '"'
		string = ""
		tokens = tokens[1..-1]
		while tokens[0] != '"' || tokens[0] != nil do
			index_backslash = tokens.index('\\')
			index_quote = tokens.index('"')
			if (index_backslash != nil) && (index_backslash < index_quote) 
				string += tokens[0..index_backslash-1]
				value, tokens = parse_backslash(tokens[index_backslash..-1])
				string += value
			elsif index_quote != nil
				string += tokens[0..index_quote-1]
				return string, tokens[index_quote+1..-1]
			else
				abort("closing braces mismatch")
			end
		end
		abort("closing braces mismatch")
	else
		return nil
	end

end



#= array of tokens
#checks if the first element is string 
#returns string and the remaining tokens

#def parse_string(tokens)	
#	puts "tokens = #{tokens}"
#	if tokens[0][0] == '"'
#		token = tokens.shift()
#		string = token.delete '"'
#		return string, tokens
#	else
#		return nil
#	end
#end

#testparser


#input = array of tokens
#checks if the first element is number 
#returns number and the remaining tokens
def parse_number(tokens)
	tokens = tokens.lstrip
	index_space = tokens.index(/[\s\t\n,\]]/)
	string = tokens[0..index_space-1]
	#puts "number in string = #{string}"
	if /^[+-]?[0-9]*\.?[0-9]+([eE][+-]?[0-9]+)?$/.match(string)
		tokens = tokens[index_space..-1]
		number = string.to_f
		return number, tokens
	else
		return nil
	end
end
	
#input = array of tokens
#checks if the first element is boolean true or false 
#returns boolean(true or false) and the remaining tokens
def parse_true_false(tokens)
	tokens = tokens.lstrip
	index_space = tokens.index(/[\s\t\n,\]]/)
	string = tokens[0..index_space-1]

	if string == 'true'
		return true, tokens[index_space..-1]
	elsif string == 'false'
		return false, tokens[indexspace..-1]
	else
		return nil
	end
end	
	
#input = array of tokens
#checks if the element is object
#returns tuple (object, remaining_tokens)
def parse_object(tokens) 
	tokens= tokens.lstrip
	if tokens[0] == '{'
		hash_object = Hash.new
		tokens = tokens[1..-1].lstrip
						
		while tokens[0] != nil
			result = parse_string(tokens)
			if result == nil
				abort("In a Hash Object Key needs to be string.\n")
			end
			key, tokens = result
			tokens = tokens.lstrip
			#puts "key, = #{key} tokens = #{tokens}"
			if tokens[0] != ':'
				abort("No colon after key in the hash object")
			end
			
			tokens = tokens[1..-1].lstrip
			value, tokens = parser_factory(tokens)
			hash_object[key] = value
			#puts "hash_object = #{hash_object}"
			tokens = tokens.lstrip

			if tokens[0] == ','
				tokens = tokens[1..-1]
			elsif tokens[0] == '}'
				tokens = tokens[1..-1]
				break
			else
				abort("wrong object given. You have wasted your engineering days!")
			end
		end
		return hash_object, tokens
	else
		return nil
	end
end

#input = array of tokens
#checks if the element is array
#returns tuple (array, remaining_tokens)
def parse_array(tokens)
	if tokens[0] == '['
		tokens = tokens[1..-1].lstrip
		array = Array.new
		#puts "in parse_array tokens = #{tokens}"
		while tokens[0] != nil
			value, tokens = parser_factory(tokens)
			array << value
			tokens = tokens.lstrip
			if tokens[0] == ','
				tokens = tokens[1..-1]
			elsif tokens[0] == ']'
				tokens = tokens[1..-1]
				break
			else
				abort("Wrong in array creation")
			end
		end
		return array, tokens
	else
		return nil
	end
end	

#input: accept the parser functions as the arguments(args)
# arguments that are passed are parse_object, parse_array, parse_string, parse_number, parse_true, parse_false, or nil
#output: returns the anonymous fuction
#anonynous fuction: This function takes tokens as the input and calls all the parser functions passed 
#to the parser.  This function returns 2 tuples 1) returned type b) remaining to be parsed

def parser_factory(tokens)
	#arr_parsers = [method(:parse_object), method(:parse_array), method(:parse_string), method(:parse_number), method(:parse_true_false)]
	arr_parsers = [method(:parse_object), method(:parse_array), method(:parse_string), method(:parse_number)]
		arr_parsers.each do
			|parser_func|
			#puts "callng parser_fuunc = #{parser_func}"
			collect_tuple = parser_func.call(tokens)
			if collect_tuple != nil
				return collect_tuple
			end
		end
		puts "tokens inside parser_factory not handled= #{tokens}"
		abort("what kind of json input have you given man. Do you need address for NIMHANS?")
end

filename = ARGV[0]
file = open(filename, 'r')
string = file.read
#tokens = tokenizer(string)

json_output = parser_factory(string)
result, tokens = json_output
puts "result is #{result}"
puts "result[2] = #{result[2]}"
