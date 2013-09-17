require 'spec_helper'

describe "panels/show" do
  before(:each) do
    @panel = assign(:panel, stub_model(Panel,
      :number => "Number"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Number/)
  end
end
