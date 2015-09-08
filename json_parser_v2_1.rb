def parse_backslash(tokens)
  if tokens[0] == '\\'
    case tokens[1]
    when 'n'; return "\n", tokens[2..-1]
    when '"'; return "\"", tokens[2..-1]
    when 't'; return "\t", tokens[2..-1]
    when '\\'; return "\\", tokens[2..-1]
    else; abort("not an exception character")
    end
  else
    abort("Not expecting parse_backlash\n")
  end
end



#= array of tokens
#checks if the first element is string 
#returns string and the remaining tokens
def parse_string(tokens)
  tokens = tokens.lstrip()
  if tokens[0] == '"'
    string = ""
    tokens = tokens[1..-1]
    if tokens[0] == '"'; return "", tokens[1..-1].lstrip end
    if tokens[0] == '\\'; string, tokens = parse_backslash(tokens) end
    index = tokens.index(/[\\"]/)
    if index == nil; abort("quotes mismatch") end
    string += tokens[0..index-1]
    result, tokens = parse_string('"'+tokens[index..-1])
    return string+result, tokens
  else
    return nil
  end
end

#input = array of tokens
#checks if the first element is number 
#returns number and the remaining tokens
def parse_number(tokens)
  tokens = tokens.lstrip
  index_space = tokens.index(/[\s\t\n,\]]/)
  string = tokens[0..index_space-1]
  if /^[+-]?[0-9]*\.?[0-9]+([eE][+-]?[0-9]+)?$/.match(string)
    return string.to_f, tokens[index_space..-1].lstrip
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
  if tokens[0..index_space-1] == 'true';  return true, tokens[index_space..-1]
  elsif tokens[0..index_space-1] == 'false'; return false, tokens[index_space..-1]
  else; return nil
  end
end 

def parse_colon(tokens)
  tokens = tokens.lstrip
  if tokens[0] == ':';  return ':', tokens[1..-1].lstrip
  else; abort("No colon after key in the hash object")
  end
end

def parse_comma(tokens)
  tokens.lstrip
  if tokens[0] == ','; return ',', tokens[1..-1].lstrip
  else; return nil
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
    while tokens[0] != '}'
      result = parse_string(tokens)
      if result == nil; abort("Hash Object Key needs to be string.\n")  end
      key, tokens = result
      colon, tokens = parse_colon(tokens)
      result_func = parser_factory(method(:parse_object), method(:parse_array), method(:parse_string), method(:parse_number), method(:parse_true_false))
      value, tokens = result_func.call(tokens)
      hash_object[key] = value
      tokens = tokens.lstrip
      result = parse_comma(tokens)
      if result != nil; comma, tokens = result
      elsif tokens[0] != '}'; abort("Expecting comma(,) or closed braces(})")
      end
    end
    return hash_object, tokens[1..-1].lstrip
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
    while tokens[0] != ']'
      result_func = parser_factory(method(:parse_object), method(:parse_array), method(:parse_string), method(:parse_number), method(:parse_true_false))
      value, tokens = result_func.call(tokens)
      array << value
      tokens = tokens.lstrip
      result = parse_comma(tokens)
      if result != nil; comma, tokens= result
      elsif tokens[0] != ']'; abort("Wrong array creation\n expected comma or closing bracket(])")
      end
    end
    return array, tokens[1..-1].lstrip
  else
    return nil
  end
end 

#input: accept the parser functions as the arguments(args)
# arguments that are passed are parse_object, parse_array, parse_string, parse_number, parse_true, parse_false, or nil
#output: returns the anonymous fuction
#anonynous fuction: This function takes tokens as the input and calls all the parser functions passed 
#to the parser.  This function returns 2 tuples 1) returned type b) remaining to be parsed


def parser_factory(*args)
  #puts "I am called"
  return_func = lambda do |tokens|
    args.each do 
      |parser_func|
      collect_tuple = parser_func.call(tokens)
      if collect_tuple != nil
        return collect_tuple
      end
    end
    abort"None of the parser handled the tokens"
  end
  return return_func
end

filename = ARGV[0]
file = open(filename, 'r')
      result_func = parser_factory(method(:parse_object), method(:parse_array))
      result, tokens = result_func.call(file.read)
#puts "tokens.length = #{tokens.length} =  #{tokens}"
if tokens.length != 0
  abort "tokens = #{tokens} wrong object or array creation"
end
puts "result is #{result}"
