# -*- coding: utf-8 -*-
require 'spec_helper'

describe "anns/index" do
  def valid_anns
    [
      stub_model(Ann, :name => "Name", :procedure => stub_model(Procedure, :path => "/foo/bar.pdf")),
      stub_model(Ann, :name => "Name", :procedure => stub_model(Procedure, :path => "/foo/bar.pdf")),
    ]
  end

  def invalid_anns
    [
      stub_model(Ann, :name => "Name")
    ]
  end

  it "renders a list of anns" do
    assign(:anns, valid_anns)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "a[href=?]", "/foo/bar.pdf", :text => "Name", :count => 2
  end

  it "renders a list of anns, no links if anns are not assiged to any panel/window" do
    assign(:anns, invalid_anns)
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 1
    assert_select "a[href=?]", "/assets/procs/ann-n1-c6.pdf", :text => "Name", :count => 0
  end
end
