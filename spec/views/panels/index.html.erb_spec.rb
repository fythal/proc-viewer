require 'spec_helper'

describe "panels/index" do
  before(:each) do
    assign(:panels, [
      stub_model(Panel,
        :number => "Number-1"
      ),
      stub_model(Panel,
        :number => "Number-2"
      )
    ])
  end

  it "renders a list of panels" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Number-1".to_s, :count => 1
    assert_select "tr>td", :text => "Number-2".to_s, :count => 1
  end
end
