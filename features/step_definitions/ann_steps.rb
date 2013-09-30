# -*- coding: utf-8 -*-

Given(/^警報の新規作成画面が表示されている$/) do
  visit(new_ann_url)
end

Given(/^警報の一覧のページが表示されている$/) do
  visit(anns_url)
end

Given(/^警報の一覧のページを表示している$/) do
  visit(anns_url)
end

Given(/^警報パネルに割り当てられていない警報がある$/) do
  @ann = Ann.create!(name: "foo")
  expect(@ann.panel).to be_nil
end

When(/^警報名称を入力する$/) do
  fill_in('ann_name', with: "CRD ポンプトリップ")
end

When(/^既存の警報パネルの番号を入力する$/) do
  @panel = Panel.create(number: "n1")
  fill_in('ann_panel_number', with: @panel.number)
end

When(/^存在していない警報パネルの番号を入力する$/) do
  @panel_number = "n2"
  fill_in('ann_panel_number', with: @panel_number)
end

When(/^警報パネルの、警報が割り当てられていない窓のロケーションを入力する$/) do
  expect(@panel.assigned?("a1")).to be_false
  fill_in('ann_panel_location', with: "a1")
end

When(/^警報パネルの窓のロケーションを入力する$/) do
  @panel_location = "a1"
  fill_in('ann_panel_location', with: @panel_location)
end

When(/^警報の手順書をアップロードする$/) do
  attach_file(:ann_procedure, Rails.root.join('features', 'procs', 'ann-n1-c6.pdf'))
end

When(/^警報の新規作成ボタンをクリックする$/) do
#  click_button I18n.t(:create_ann)
  click_button "Create Ann"
end

When(/^警報の一覧のページを表示する$/) do
  visit(anns_url)
end

When(/^その警報の編集画面を表示する$/) do
  visit(edit_ann_url @ann)
end

When(/^アプリケーションのページを表示する$/) do
  visit(anns_url)
end

Then(/^警報の詳細ページが表示される$/) do
  expect(current_path).to match %r|^/anns/[0-9]+$|
end

Then(/^警報の新規作成画面が表示される$/) do
  expect(response_headers["Set-Cookie"]).to match /request_method=POST;/
  expect(current_path).to eq(anns_path)
end

Then(/^正常に警報が作成されたメッセージが表示されている$/) do
  expect(page).to have_selector('p#notice', text: "Ann was successfully created.")
end

Then(/^正常に警報が編集されたされたメッセージが表示される$/) do
  expect(page).to have_selector('p#notice', text: "Ann was successfully updated.")
end

Then(/^詳細ページでは、警報を割り当てた警報パネルへのリンクがある$/) do
  expect(page).to have_link(@panel.number)
end

Then(/^詳細ページでは、新規に作成された警報パネルへのリンクがある$/) do
  expect(page).to have_link(@panel_number)
end

Then(/^詳細ページでは、警報の手順書へのリンクがある$/) do
  ann_id = (current_path.match(%r|/anns/(\d)+|) and $~[1])
  ann = Ann.find(ann_id.to_i)
  expect(page).to have_link(ann.procedure.path.sub(%r|^.*/|, ''), href: ann.procedure.path)
end

Then(/^詳細ページでは、警報を割り当てた窓のロケーションが表示される$/) do
  expect(page).to have_selector('#ann_panel_location', :text => @panel_location)
end

Then(/^窓の場所は空白ではいけない旨のエラーが表示される$/) do
  expect(page).to have_selector('#error_explanation li', :text => "Panel locationを入力してください。")
end

Then(/^警報パネルは空白ではいけない旨のエラーが表示される$/) do
  expect(page).to have_selector('#error_explanation li', :text => "Panel numberを入力してください。")
end

Then(/^窓の場所のフィールドが色付される$/) do
  expect(page).to have_selector('.field_with_errors label[for="ann_panel_location"]')
  expect(page).to have_selector('.field_with_errors input#ann_panel_location')
end

Then(/^警報パネルのフィールドが色付される$/) do
  expect(page).to have_selector('.field_with_errors label[for="ann_panel_number"]')
  expect(page).to have_selector('.field_with_errors input#ann_panel_number')
end

Then(/^手順書は割り当てられていないメッセージが表示される$/) do
  expect(page).to have_selector('#ann_procedure', text: %r|\(未設定\)|)
end

Then(/^警報パネルの番号と場所は設定されていないメッセージが表示される$/) do
  expect(page).to have_selector('#ann_panel', text: %r|\(未設定\)|)
  expect(page).to have_selector('#ann_panel_location', text: %r|\(未設定\)|)
end

Then(/^警報パネルの番号は "(.*?)"、警報の場所は "(.*?)" となっている$/) do |number, location|
  expect(page).to have_selector '#ann_panel', text: %r|#{number}|
  expect(page).to have_selector '#ann_panel_location', text: %r|#{location}|
end
