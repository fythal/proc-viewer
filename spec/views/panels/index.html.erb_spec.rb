# -*- coding: utf-8 -*-
require 'spec_helper'

describe "panels/index" do
  before(:each) do
    assign(:boards, [
             stub_model(Board, code: "foo-foo", name: "foo board",
                        panels: [
                          stub_model(Panel, :number => "foo-panel-1"),
                          stub_model(Panel, :number => "foo-panel-2")]),
             stub_model(Board, code: "foo-bar", name: "bar board",
                        panels: [
                          stub_model(Panel, :number => "bar-panel-1"),
                          stub_model(Panel, :number => "bar-panel-2")]),
           ])
  end

  it "盤をリスト形式で描画する" do
    render
    assert_select "li", :text => /foo-foo  foo board/, :count => 1
    assert_select "li", :text => /foo-bar  bar board/, :count => 1
  end

  it "盤のリストを #list_of_panels 要素で囲む" do
    render

    assert_select "#list_of_panels" do
      assert_select "li", :text => /foo-foo  foo board/, :count => 1
      assert_select "li", :text => /foo-bar  bar board/, :count => 1
    end
  end


  it "盤の HTML 要素を board クラスとする" do
    render
    assert_select "li.board", :text => /foo-foo  foo board/, :count => 1
    assert_select "li.board", :text => /foo-bar  bar board/, :count => 1
  end

  it "警報パネルを盤の要素の下位に、テーブル形式で描画する" do
    render
    assert_select "li" do
      assert_select "td", :text => "foo-panel-1".to_s, :count => 1
    end
  end

  it "警報パネルの table 要素を panel クラスとする" do
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
