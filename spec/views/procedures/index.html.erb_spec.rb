require 'spec_helper'

describe "procedures/index" do
  before(:each) do
    assign(:procedures, [
      stub_model(Procedure,
        :path => "Path",
        :ann_id => 1,
        :revision => "",
        :revised_on => "Revised On",
        :prev_revision_id => 2
      ),
      stub_model(Procedure,
        :path => "Path",
        :ann_id => 1,
        :revision => "",
        :revised_on => "Revised On",
        :prev_revision_id => 2
      )
    ])
  end

  it "renders a list of procedures" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Path".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Revised On".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
