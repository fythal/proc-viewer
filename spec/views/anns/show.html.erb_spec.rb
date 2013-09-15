# -*- coding: utf-8 -*-
require 'spec_helper'

describe "anns/show" do
  context "警報がパネルにアサインされている" do
    before(:each) do
      @panel = assign(:panel, stub_model(Panel, :id => 1, :number => "n1"))
      @ann = assign(:ann, stub_model(Ann, :name => "Name"))
    end

    it "パネルへのリンクを描画する" do
      render
      assert_select '#ann_panel' do
        assert_select 'a[href=?]', panel_path(@panel), {text: @panel.number}
      end
    end
  end

  context "警報にはパネルと窓がアサインされていない" do
    before(:each) do
      @ann = assign(:ann, stub_model(Ann, :name => "Name"))
    end

    it "renders attributes in <p>" do
      render
      assert_select '#ann_panel' do
        assert_select 'a', 0
      end
    end
  end

  context "警報に手順書が関連付けられている" do
    before(:each) do
      assign(:ann, stub_model(Ann,
                              :name => "Name",
                              :procedure => stub_model(Procedure, :path => "/procs/bar.pdf")))
    end

    it "手順書へのリンクがある" do
      render
      assert_select "a[href=?]", "/procs/bar.pdf"
    end

    it "手順書へのリンクにはファイル名が表示されている" do
      render
      assert_select "a[href=?]", "/procs/bar.pdf", :text => "bar.pdf"
    end

    it "手順書へのリンクは #ann_procedure 要素の中に入っている" do
      render
      assert_select "#ann_procedure" do
        assert_select "a[href=?]", "/procs/bar.pdf"
      end
    end
  end

  context "警報の場所を示す @location が設定されている" do
    before(:each) do
      location = stub_model(Location, to_s: "a1")
      assign(:ann, stub_model(Ann, location: location))
    end

    it "警報の場所を #ann_panel_location に表示する" do
      render
      assert_select "#ann_panel_location", :text => /a1/
    end
  end

end
