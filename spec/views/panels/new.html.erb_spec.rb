require 'spec_helper'

describe "panels/new" do
  before(:each) do
    assign(:panel, stub_model(Panel,
      :number => "MyString"
    ).as_new_record)
  end

  it "renders new panel form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", panels_path, "post" do
      assert_select "input#panel_number[name=?]", "panel[number]"
    end
  end
end
