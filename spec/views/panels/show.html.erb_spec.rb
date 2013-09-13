require 'spec_helper'

describe "panels/show" do
  before(:each) do
    @panel = assign(:panel, stub_model(Panel,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
