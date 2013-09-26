require 'spec_helper'

describe "procedures/index" do
  before(:each) do
    assign(:procedures, [
      stub_model(Procedure, :path => "/foo/bar.pdf", :ann_id => 1, :revision => "4", :revised_on => "2013/9/26"),
      stub_model(Procedure, :path => "/foo/bar.pdf", :ann_id => 1, :revision => "4", :revised_on => "2013/9/26")
           ])
  end

  it "renders a list of procedures" do
    render

    assert_select "tr>td", :text => "bar.pdf".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => /4/, :count => 2
    assert_select "tr>td", :text => /2013-09-26/, :count => 2
  end
end
