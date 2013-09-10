# -*- coding: utf-8 -*-
require 'spec_helper'

describe "anns/edit" do
  before(:each) do
    @ann = assign(:ann, stub_model(Ann,
      :name => "MyString",
      :pdf => "MyString"
    ))
  end

  it "renders the edit ann form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => anns_path(@ann), :method => "post" do
      assert_select "input#ann_name", :name => "ann[name]"
      assert_select "input#ann_pdf", :name => "ann[pdf]"
      assert_select "label[for='ann_panel']", I18n.t(:panel_number)
      assert_select "input#ann_panel", :name => "ann[panel]"
      assert_select "label[for='ann_window']", I18n.t(:window_number)
      assert_select "input#ann_window", :name => "ann[window]"
    end
  end
end
