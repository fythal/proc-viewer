# -*- coding: utf-8 -*-

Given(/^そのパソコンにはユーザーの記録が残っていない$/) do
end

When(/^ログイン画面が表示されるので、そこで自分の名前 "(.*?)" を選択する$/) do |name|
  select name
end

Then(/^ログインの画面にリダイレクトされる$/) do
  expect(current_path).to eq("/logins/new")
end

Then(/^「ようこそ、foo さん」と画面に表示される$/) do
  pending # express the regexp above with the code you wish you had
end
