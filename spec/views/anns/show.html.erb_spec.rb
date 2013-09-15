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
end
