# -*- coding: utf-8 -*-

Given(/^そのパソコンにはユーザーの記録が残っていない$/) do
end

Given(/^自分は "(.*?)" という名前であらかじめユーザー登録してある$/) do |name|
  User.create!(name: name)
end

When(/^ログイン画面が表示されるので、そこで自分の名前 "(.*?)" を選択する$/) do |name|
  select name
  click_button "Create Login"
end

Then(/^ログインの画面にリダイレクトされる$/) do
  expect(current_path).to eq("/logins/new")
end

Then(/^「(ようこそ、.*?さん)」と画面に表示される$/) do |msg|
  expect(page).to have_content msg
end
