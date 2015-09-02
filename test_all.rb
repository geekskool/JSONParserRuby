#puts "number of arguments = #{ARGV}"
files = ARGV

files.each do
	|file|
	#puts "okay file is #{file}"
	cmd = "ruby json_parser_v2_1.rb #{file}"
	puts "we are executing command  \n #{cmd}"
	system (cmd)
	$stdin.gets
end
