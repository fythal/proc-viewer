# -*- coding: utf-8 -*-

Given(/^警報パネル (.*) がある$/) do |panel_number|
  @panel = Panel.create!(number: panel_number)
end

Given(/^そのパネルは盤 (.*) にある$/) do |board_name|
  board = Board.create!(name: board_name)
  board.panels << @panel
end

Given(/^そのパネルは縦 (\d+)、横 (\d+) の大きさを持つ$/) do |height, width|
  @panel.height = height.to_i
  @panel.width  = width.to_i
  @panel.save
end

Given(/^そのパネルの (.*) に警報が割り当てられている$/) do |location|
  ann = Ann.create!(name: "foobar")
  procedure = Procedure.create!
  procedure.send(:write_attribute, :path, "/foo/bar.pdf")

  @panel.assign(ann, to: location)
end

When(/^その表の詳細画面を表示する$/) do
  visit panel_path(@panel)
end

Then(/^縦 (\d+)、横 (\d+) の表が表示される$/) do |height, width|
  expect(page).to have_selector('table')
  expect(page).to have_selector('table tr', :count => height.to_i)
  expect(page).to have_selector('table td', :count => height.to_i * width.to_i)
end

Then(/^そのパネルの (.*) には手順書のリンクが含まれている$/) do |location|
  expect(page).to have_selector("table td#loc_#{location.downcase} a", text: "bar.pdf")
end
