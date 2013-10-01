# -*- coding: utf-8 -*-

When(/^警報パネルについて、パネル番号に "(.*?)"、警報の場所に "(.*?)" を入力する$/) do |number, location|
  fill_in 'ann_panel_number', with: number
  fill_in 'ann_panel_location', with: location
end

When(/^手順書の編集ボタンをクリックする$/) do
  click_button 'Update Ann'
end
