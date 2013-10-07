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
  ann.procedures << procedure

  @panel.assign(ann, to: location)
end

When(/^その表の詳細画面を表示する$/) do
  visit panel_path(@panel)
end

When(/^その警報パネルの編集画面を表示する$/) do
  visit edit_panel_path(@panel)
end

When(/^警報パネルの番号として (.*) を入力する$/) do |name|
  fill_in 'panel_number', with: name
end

When(/^編集の実行のボタンをクリックする$/) do
  click_button 'Update Panel'
end

Then(/^縦 (\d+)、横 (\d+) の表が表示される$/) do |height, width|
  expect(page).to have_selector('table')
  expect(page).to have_selector('table tr', :count => height.to_i)
  expect(page).to have_selector('table td', :count => height.to_i * width.to_i)
end

Then(/^そのパネルの (.*) には手順書のリンクが含まれている$/) do |location|
  expect(page).to have_selector("table td#loc_#{location.downcase} a", text: "foobar")
end

Then(/^そのパネルの (.*) には手順書のリンクが含まれていない$/) do |location|
  expect(page).not_to have_selector("table td#loc_#{location.downcase} a", text: "foobar")
end

Then(/^警報パネルの番号として (.*) が表示される$/) do |number|
  expect(page).to have_content(number)
end

Then(/^警報パネルの番号が (.*) に変更される$/) do |number|
  expect(Panel.find(@panel.to_param).number).to eq(number)
end
