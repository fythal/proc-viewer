# -*- coding: utf-8 -*-

Then(/^そのページに検索用フィールドが表示される$/) do
  expect(page).to have_selector('#search_field form input[type="text"]')
end
