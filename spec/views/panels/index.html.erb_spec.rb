require 'spec_helper'

describe "panels/index" do
  before(:each) do
    assign(:panels, [
      stub_model(Panel,
        :name => "Name"
      ),
      stub_model(Panel,
        :name => "Name"
      )
    ])
  end

  it "renders a list of panels" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
