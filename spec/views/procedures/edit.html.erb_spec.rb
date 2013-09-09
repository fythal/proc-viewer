require 'spec_helper'

describe "procedures/edit" do
  before(:each) do
    @procedure = assign(:procedure, stub_model(Procedure,
      :path => "MyString",
      :ann_id => 1,
      :revision => "",
      :revised_on => "MyString",
      :prev_revision_id => 1
    ))
  end

  it "renders the edit procedure form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", procedure_path(@procedure), "post" do
      assert_select "input#procedure_path[name=?]", "procedure[path]"
      assert_select "input#procedure_ann_id[name=?]", "procedure[ann_id]"
      assert_select "input#procedure_revision[name=?]", "procedure[revision]"
      assert_select "input#procedure_revised_on[name=?]", "procedure[revised_on]"
      assert_select "input#procedure_prev_revision_id[name=?]", "procedure[prev_revision_id]"
    end
  end
end
