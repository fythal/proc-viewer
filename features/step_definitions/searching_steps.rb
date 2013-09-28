# -*- coding: utf-8 -*-

Then(/^そのページに検索用フィールドが表示される$/) do
  expect(page).to have_selector('form#search input[type="text"]')
end
