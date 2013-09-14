# -*- coding: utf-8 -*-

Given(/^警報の新規作成画面が表示されている$/) do
  visit(new_ann_url)
end

When(/^警報名称を入力する$/) do
  fill_in('ann_name', with: "CRD ポンプトリップ")
end

When(/^既存の警報パネルの番号を入力する$/) do
  @panel = Panel.create(number: "n1")
  fill_in('ann_panel_number', with: @panel.number)
end

When(/^警報パネルの、警報が割り当てられていない窓のロケーションを入力する$/) do
  expect(@panel.assigned?("a1")).to be_false
  fill_in('ann_panel_location', with: "a1")
end

When(/^警報の手順書をアップロードする$/) do
  attach_file(:ann_procedure, Rails.root.join('feature', 'procs', 'ann-n1-c6.pdf'))
end

When(/^警報の新規作成ボタンをクリックする$/) do
  click_button I18n.t(:create_ann)
end

Then(/^警報の詳細ページが表示される$/) do
  expect(current_path).to match %r|^/anns/[0-9]+$|
end

Then(/^正常に警報が作成されたメッセージが表示されている$/) do
  expect(page).to have_selector('p#notice', text: "Ann was successfully created.")
end

Then(/^詳細ページでは、警報を割り当てた警報パネルへのリンクがある$/) do
  expect(page).to have_link(@panel.number)
end

Then(/^詳細ページでは、警報の手順書へのリンクがある$/) do
  expect(page).to have_link(@ann.procedure.filename)
end
