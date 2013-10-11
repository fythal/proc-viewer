#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

ARGF.each do |line|
  line.chomp!

  panel_number, panel_location, name = line.split(/,/).values_at(1, 2, 4)
  panel_location = panel_location.downcase.sub(/^(?=[nmb])0/, "")

  # 盤の名称の変換
  case panel_number
  when /([mnb])0*(\d+)/i
    panel_number = $~[1].downcase + $~[2]
  end

  next if panel_number =~ /^(bousai|ann)$/i

  puts "  - name: \"#{name}\""
  puts "    panel_location: #{panel_location}"
  puts "    panel_number: #{panel_number}"
  puts
end
