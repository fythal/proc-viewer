#!/usr/bin/env ruby

number, height, width = ARGV[0, 3]

data = (1..width.to_i).inject([]) do |result, col|
  (1..height.to_i).inject(result) do |result, row|
    result << "  - name: \"\"\n" +
      "    panel_location: #{row.to_s.tr('1-8', 'a-h')}#{col}\n" +
      "    panel_number: #{number}\n"
  end
end

puts "ann:"
puts data.join("\n")
