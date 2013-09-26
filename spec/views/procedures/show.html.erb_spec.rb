require 'spec_helper'

describe "procedures/show" do
  before(:each) do
    @procedure = assign(:procedure, stub_model(Procedure, :path => "/foo/bar.pdf", :ann_id => 1, :revision => 0, :revised_on => "2013/1/1"))
    @ann = assign(:ann, stub_model(Ann, :name => "foo"))
    Ann.stub(:find).with(1).and_return(@ann)
  end

  it "renders attributes in <p>" do
    render

    assert_select('#path', text: %r|/foo/bar.pdf|)
    assert_select('#ann_name', text: /foo/)
    assert_select('#revision', text: /0/)
    assert_select('#revised_on', text: /2013-01-01/)
  end
end
