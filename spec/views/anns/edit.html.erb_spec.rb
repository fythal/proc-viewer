# -*- coding: utf-8 -*-
require 'spec_helper'

describe "anns/edit" do
  before(:each) do
    @ann = assign(:ann, stub_model(Ann,
      :name => "MyString",
    ))
  end

  it "renders the edit ann form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => anns_path(@ann), :method => "post" do
      assert_select "input#ann_name", :name => "ann[name]"

      # 警報パネル番号
      assert_select "label[for='ann_panel_number']", I18n.t("helpers.label.ann.panel_number")
      assert_select "input#ann_panel_number", :name => "ann[panel_number]"

      # 警報窓番号
      assert_select "label[for='ann_panel_location']", I18n.t("helpers.label.ann.panel_location")
      assert_select "input#ann_panel_location", :name => "ann[panel_location]"
    end

    # 手順書
    assert_select "a[href=?]", new_ann_procedure_path(@ann), I18n.t("new_procedure_for_the_ann")
  end
end
