# -*- coding: utf-8 -*-

When(/^「(.*)」というキーワードを入力する$/) do |keywords|
  fill_in 'search_keywords', :with => keywords
end

When(/^検索フィールドにキーワードを入力する$/) do
  visit(anns_url)
  fill_in "search_keywords", with: "foo"
  click_button "Search"
end

Then(/^そのページに検索用フィールドが表示される$/) do
  expect(page).to have_selector('#search_field form input[type="text"]')
end

Then(/^検索結果のページが表示される$/) do
  expect(current_path).to match %r|^/users/\d+/searches/\d+$|
end

Then(/^検索結果が画面に表示される$/) do
  expect(current_path).to match %r|^/searches/\d+$|
end
