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

Given(/^盤 (.*) がある$/) do |name|
  Board.create!(name: name)
end

Given(/^盤 (.*) には (.*) と (.*) の警報パネルが配置されている$/) do |board_name, panel_name_one, panel_name_two|
  board = Board.find_by name: board_name
  board.panels << Panel.new(number: panel_name_one)
  board.panels << Panel.new(number: panel_name_two)
  expect(board.panels.count).to eq(2)
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

When(/^警報パネル一覧のページを描画する$/) do
  visit panels_path
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

Then(/^盤 (.*) には警報パネルが (.*)、(.*) の順で表示される$/) do |board_name, panel_one_name, panel_two_name|
  # 要素が希望の通りになっていることを確認
  expect(page).to have_selector 'li td', :text => panel_one_name
  expect(page).to have_selector 'li td', :text => panel_two_name

  # 順番が希望の通りになっていることを確認
#  expect(page).to have_content(%|#{panel_one_name}.*#{panel_two_name}|)
end

Then(/^警報パネルの部分は、パネルの詳細のページへのリンクとなっている$/) do
  expect(page).to have_selector ".panel a"
end
