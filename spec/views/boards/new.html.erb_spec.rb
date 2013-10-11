require 'spec_helper'

describe "boards/new" do
  before(:each) do
    assign(:board, stub_model(Board,
      :code => "MyCode", :name => "MyString",
    ).as_new_record)
  end

  it "renders new board form" do
    render

    assert_select "form[action=?][method=?]", boards_path, "post" do
      assert_select "input#board_code[name=?]", "board[code]"
      assert_select "input#board_name[name=?]", "board[name]"
    end
  end
end
