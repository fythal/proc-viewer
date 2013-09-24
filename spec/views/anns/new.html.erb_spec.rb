require 'spec_helper'

describe "anns/new" do
  before(:each) do
    assign(:ann, stub_model(Ann,
                            :name => "MyString",
                            :panel_number => "MyString",
                            :panel_location => "MyString",
                            ).as_new_record)

  end

  it "renders new ann form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => anns_path, :method => "post" do
      assert_select "input#ann_name", :name => "ann[name]"
      assert_select "input#ann_panel_number", :name => "ann[panel_number]"
      assert_select "input#ann_panel_location", :name => "ann[panel_location]"
    end
  end
end
