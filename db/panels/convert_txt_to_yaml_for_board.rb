require 'yaml'

lines = ARGF.readlines

h = lines.inject([]) do |result, line|
  line.chomp!
  number, name = line.split(/ /, 2)

  h = Hash.new
  h["number"] = number.upcase
  h["name"] = name unless name.nil?
  result << h
end

puts h.to_yaml

