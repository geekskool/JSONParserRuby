#convert the input string to array of tokens
def tokenizer(string)
	string = string.gsub('{', ' { ')
	string = string.gsub(':', ' : ')
	string = string.gsub(',', ' , ')
	string = string.gsub('}', ' } ')
	string = string.gsub('[', ' [ ')
	string = string.gsub(']', ' ] ')
	tokens = string.split(" ")
end

#input = array of tokens
#checks if the first element is string 
#returns string and the remaining tokens
def parse_string(tokens)
	if tokens[0][0] == '"'
		token = tokens.shift()
		string = token.delete '"'
		return string, tokens
	else
		return nil
	end
end

#input = array of tokens
#checks if the first element is number 
#returns number and the remaining tokens
def parse_number(tokens)
	string = tokens[0]
	if /^[+-]?[0-9]*\.?[0-9]+([eE][+-]?[0-9]+)?$/.match(string)
		tokens.shift()
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
	string = tokens.shift()
	if string == 'true'
		return string, tokens
	elsif string == 'false'
		return string, tokens
	else
		return nil
	end
end	
	
#input = array of tokens
#checks if the element is object
#returns tuple (object, remaining_tokens)
def parse_object(tokens) 
	if tokens[0] == '{'
		hash_object = Hash.new
		tokens.shift()
		while tokens[0] != nil
			result = parse_string(tokens)
			if result == nil
				abort("what kind of json input have you given man.\n
						 In a Hash Object Key needs to be string.\n
						Do you need address for NIMHANS?")
			end
			key, tokens = result
			if tokens[0] != ':'
				abort("wrong hash key value. what am I going to do with you!")
			end
			tokens.shift()
			value, tokens = parse_factory(tokens)
			hash_object[key] = value
			if tokens[0] == ','
				tokens.shift()
			elsif tokens[0] == '}'
				tokens.shift()
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
		tokens.shift()
		array = Array.new
		while tokens[0] != nil
			value, tokens = parse_factory(tokens)
			array << value
			if tokens[0] == ','
				tokens.shift()
			elsif tokens[0] == ']'
				tokens.shift()
				break
			else
				abort("You dont know how to add arrays. \n
							Go and read here http://www.tutorialspoint.com/cprogramming/c_arrays.htm\n
							dumbo.")
			end
		end
		return array, tokens
	else
		return nil
	end
end	

#pass the tokens to functions 
# parse_object, parse_array, parse_string, parse_number, parse_true, parse_false, or nil
# Currently parse _object, parse_array, parse_string parse_number and prase_true_false are implemented
# This function returns 2 tuples 1) returned type b) remaining to be parsed
def parse_factory(tokens)
	collect_tuple = parse_object(tokens)
	if collect_tuple != nil
		return collect_tuple
	end
	
	collect_tuple = parse_array(tokens)
	if  collect_tuple != nil
		return collect_tuple
	end
	
	collect_tuple = parse_string(tokens)
	if  collect_tuple != nil
		return collect_tuple
	end
		
	collect_tuple = parse_number(tokens)
	if  collect_tuple != nil
		return collect_tuple
	end
	
	collect_tuple = parse_true_false(tokens)
	if  collect_tuple != nil
		return collect_tuple
	end

	abort("what kind of json input have you given man. Do you need address for NIMHANS?")
end

filename = ARGV[0]
file = open(filename, 'r')
string = file.read
tokens = tokenizer(string)
json_output = parse_factory(tokens)
result, tokens = json_output
puts "result is #{result}"
