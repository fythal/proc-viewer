# -*- coding: utf-8 -*-
require 'spec_helper'

describe "panels/new" do
  before(:each) do
    assign(:panel, stub_model(Panel,
      :number => "MyString"
    ).as_new_record)
    assign(:boards, [
             stub_model(Board, id: 100, code: "bar-1", name: "Bar 1 ですよ"),
             stub_model(Board, id: 200, code: "bar-2", name: "Bar 2 ですよ"),
           ])
  end

  it "renders new panel form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", panels_path, "post" do
      assert_select "input#panel_number[name=?]", "panel[number]"
      assert_select "input#panel_width[name=?]", "panel[width]"
      assert_select "input#panel_height[name=?]", "panel[height]"

      # 盤の選択メニュー
      assert_select "select", :name => "panel[board_id]" do
        assert_select "option[value='100']"
        assert_select "option[value='200']"
      end
    end
  end
end
