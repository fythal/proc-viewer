# -*- coding: utf-8 -*-
require 'spec_helper'

describe "procedures/index" do

  def valid_attributes
    {
      :path => "/foo/bar.pdf",
      :revision => "4",
      :revised_on => "2013/9/26",
    }
  end

  def assign_ann
    Procedure.any_instance.stub(:ann).and_return(stub_model(Ann, :name => "foo-bar"))
  end

  describe "手順書オブジェクトが完璧に設定されている場合" do
    before(:each) do
      attrs = valid_attributes
      assign(:procedures, [stub_model(Procedure, attrs), stub_model(Procedure, attrs)])
      assign_ann
    end

    it "renders a list of procedures" do
      render

      assert_select "tr>td", :text => /foo-bar/, :count => 2
      assert_select "tr>td", :text => /4/, :count => 2
      assert_select "tr>td", :text => /2013-09-26/, :count => 2
      assert_select "tr>td", :text => "bar.pdf".to_s, :count => 2
    end
  end

  describe "警報が割り当てられていない場合" do
    before(:each) do
      attrs = valid_attributes
      assign(:procedures, [stub_model(Procedure, attrs), stub_model(Procedure, attrs)])
    end

    it "renders a list of procedures" do
      render

      assert_select "tr>td", :text => /#{t(:no_ann_assigned)}/, :count => 2
    end
  end

  describe "手順書の改訂日が割り当てられていない場合" do
    before(:each) do
      attrs = valid_attributes.merge(revised_on: nil)
      assign(:procedures, [stub_model(Procedure, attrs), stub_model(Procedure, attrs)])
    end

    it "renders a list of procedures" do
      render

      assert_select "tr>td", :text => /#{t(:not_assigned)}/, :count => 2
    end
  end

  describe "手順書のファイルが割り当てられていない場合" do
    before(:each) do
      attrs = valid_attributes.merge(path: nil)
      assign(:procedures, [stub_model(Procedure, attrs), stub_model(Procedure, attrs)])
    end

    it "renders a list of procedures" do
      render

      assert_select "tr>td", :text => /#{t(:no_path_for_procedure)}/, :count => 2
    end
  end
end
