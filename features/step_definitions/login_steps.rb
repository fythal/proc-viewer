# -*- coding: utf-8 -*-

Given(/^そのパソコンにはユーザーの記録が残っていない$/) do
end

Then(/^ログインの画面にリダイレクトされる$/) do
  expect(current_path).to eq("/logins/new")
end
