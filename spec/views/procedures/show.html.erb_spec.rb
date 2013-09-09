require 'spec_helper'

describe "procedures/show" do
  before(:each) do
    @procedure = assign(:procedure, stub_model(Procedure,
      :path => "Path",
      :ann_id => 1,
      :revision => "",
      :revised_on => "Revised On",
      :prev_revision_id => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Path/)
    rendered.should match(/1/)
    rendered.should match(//)
    rendered.should match(/Revised On/)
    rendered.should match(/2/)
  end
end
