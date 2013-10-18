require 'spec_helper'

describe "panels/edit" do
  before(:each) do
    @panel = assign(:panel, stub_model(Panel,
      :number => "MyString"
    ))
  end

  it "renders the edit panel form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", panel_path(@panel), "post" do
      assert_select "input#panel_number[name=?]", "panel[number]"
      assert_select "input#panel_width[name=?]", "panel[width]"
      assert_select "input#panel_height[name=?]", "panel[height]"
    end
  end
end
