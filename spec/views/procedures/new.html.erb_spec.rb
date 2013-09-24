# -*- coding: utf-8 -*-
require 'spec_helper'

describe "procedures/new" do
  before(:each) do
    assign(:procedure, stub_model(Procedure,
      :path => "MyString",
      :ann_id => 1,
      :revision => "",
      :revised_on => "MyString",
      :prev_revision_id => 1
    ).as_new_record)
  end

  it "renders new procedure form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", procedures_path, "post" do
      assert_select "input#procedure_path[name=?]", "procedure[path]"
      assert_select "input#procedure_ann_id[name=?]", "procedure[ann_id]"
      assert_select "input#procedure_revision[name=?]", "procedure[revision]"
      assert_select "input#procedure_revised_on[name=?]", "procedure[revised_on]"
      assert_select "input#procedure_prev_revision_id[name=?]", "procedure[prev_revision_id]"
    end
  end

  it "警報 @ann が代入されていれば、警報名称を表示する" do
    assign(:ann, stub_model(Ann, :name => "MyAnnName"))
    render
    assert_select "#ann_name", /MyAnnName/
  end
end
