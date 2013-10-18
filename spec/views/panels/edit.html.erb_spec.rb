# -*- coding: utf-8 -*-
require 'spec_helper'

describe "panels/edit" do
  before(:each) do
    @panel = assign(:panel, stub_model(Panel,
      :number => "MyString"
    ))

    assign(:boards, [
             stub_model(Board, id: 100, code: "bar-1", name: "Bar 1 ですよ"),
             stub_model(Board, id: 200, code: "bar-2", name: "Bar 2 ですよ"),
           ])
  end

  it "renders the edit panel form" do
    render

    assert_select "form[action=?][method=?]", panel_path(@panel), "post" do
      assert_select "input#panel_number[name=?]", "panel[number]"
      assert_select "input#panel_width[name=?]", "panel[width]"
      assert_select "input#panel_height[name=?]", "panel[height]"

      # 盤の選択メニュー
      assert_select "select", :name => "panel[board_id]" do
        assert_select "option[value='100']", :text => "bar-1  Bar 1 ですよ"
        assert_select "option[value='200']", :text => "bar-2  Bar 2 ですよ"
      end
    end
  end
end
