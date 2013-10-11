# -*- coding: utf-8 -*-
require 'spec_helper'

describe "boards/edit" do
  before(:each) do
    @board = assign(:board, stub_model(Board, :code => "MyCode", :name => "MyString"))
  end

  it "盤を編集するためのフォームを描画する" do
    render

    assert_select "form[action=?][method=?]", board_path(@board), "post" do
      assert_select "input#board_code[name=?]", "board[code]"
      assert_select "input#board_name[name=?]", "board[name]"
    end
  end
end
