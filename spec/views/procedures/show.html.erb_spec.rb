# -*- coding: utf-8 -*-
require 'spec_helper'

describe "procedures/show" do

  def valid_attributes
    {
      :path => "/foo/bar.pdf",
      :revision => "9",
      :revised_on => "2013/1/1",
    }
  end

  def valid_ann_attributes
    {
      :id => 1,
      :name => "foo-bar",
    }
  end

  def assign_ann
    Procedure.any_instance.stub(:ann).and_return(stub_model(Ann, valid_ann_attributes))
  end

  before(:each) do
    @procedure = assign(:procedure, stub_model(Procedure, valid_attributes))
    @ann = assign(:ann, stub_model(Ann, valid_ann_attributes))
  end

  it "renders attributes in <p>" do
    render

    assert_select('#ann_name', text: /foo-bar/)
    assert_select('#revision', text: /9/)
    assert_select('#revised_on', text: /2013-01-01/)
    assert_select('#path', text: %r|/foo/bar.pdf|)
  end

  it "警報の編集画面へのリンクを表示する" do
    render

    assert_select('a[href=?]', edit_ann_path(@ann), text: I18n.t(:editing_ann) )
  end
end
