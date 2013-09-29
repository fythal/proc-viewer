# -*- coding: utf-8 -*-

Given(/^そのパソコンにはユーザーの記録が残っていない$/) do
end

When(/^システムにアクセスする$/) do
  visit(anns_url)
end

Then(/^ログインの画面が表示される$/) do
  expect(current_path).to match %r|^/login$|
end
