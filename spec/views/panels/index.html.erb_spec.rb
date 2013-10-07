# -*- coding: utf-8 -*-
require 'spec_helper'

describe "panels/index" do
  before(:each) do
    assign(:boards, [
             stub_model(Board, name: "foo board",
                        panels: [
                          stub_model(Panel, :number => "foo-panel-1"),
                          stub_model(Panel, :number => "foo-panel-2")]),
             stub_model(Board, name: "bar board",
                        panels: [
                          stub_model(Panel, :number => "bar-panel-1"),
                          stub_model(Panel, :number => "bar-panel-2")]),
           ])
  end

  it "盤をリスト形式で描画する" do
    render
    assert_select "li", :text => /foo board/, :count => 1
    assert_select "li", :text => /bar board/, :count => 1
  end

  it "盤の下に警報パネルをテーブル形式で描画する" do
    render
    assert_select "li" do
      assert_select "td", :text => "foo-panel-1".to_s, :count => 1
    end
  end

  it "警報パネルのテーブル要素は css の panel クラスである" do
    render
    assert_select "li" do
      assert_select "td.panel", :text => "foo-panel-1".to_s, :count => 1
    end
  end

  it "警報パネルはリンクになっている" do
    render
    assert_select "li" do
      assert_select "td" do
        assert_select "a[href=?]", %r|^/panels/\d+$|
      end
    end
  end
end
