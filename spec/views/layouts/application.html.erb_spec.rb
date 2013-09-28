# -*- coding: utf-8 -*-
require 'spec_helper'

describe "layouts/application" do
  it "検索用フォームを描画する" do
    render
    assert_select '#search_field form'
    assert_select '#search_field form input#search_keywords[type="text"]'
  end
end
