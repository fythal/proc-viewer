# -*- coding: utf-8 -*-
require 'spec_helper'

describe "panels/show" do
  before(:each) do
    procedure = stub_model(Procedure, path: "/foo/bar.pdf", filename: "bar.pdf")
    ann = stub_model(Ann, name: "foo", procedure: procedure)
    subpanel = stub_model(Panel, name: "bar", number: "bazz")
    item_array = [[ann, nil, ann], [nil, ann, nil], [ann, subpanel, ann]]

    panel = stub_model(Panel,
                       :number => "Number",
                       :height => 3,
                       :width  => 3,
                       )
    panel.stub(:items).with({array: true}).and_return(item_array)
    @panel = assign(:panel, panel)
  end

  it "基本データ設定" do
    expect(@panel.items(array: true)).to be_kind_of(Array)
    expect(@panel.items(array: true).first).to be_kind_of(Array)
  end

  it "警報パネルの名称を表示する" do
    render
    rendered.should match(/Number/)
  end

  it "クラス名 panel のテーブルを描画する" do
    render
    assert_select "table.panel"
  end

  it "テーブルに 3 つの行数を描画する" do
    render
    assert_select "table tr", 3
  end

  it "テーブルに 9 つの td 要素を描画する" do
    render
    assert_select "table tr td", 3 + 3 * 3
  end

  it "テーブルの td 要素には、場所情報を含む id を設定する" do
    render
    assert_select "table tr td#loc_a1"
  end

  it "警報へのリンクは ann クラスとする" do
    render
    assert_select "td#loc_a1 a.ann"
  end

  it "一括警報のリンクは panel クラスとする" do
    render
    assert_select "td#loc_c2 a.panel"
  end
end
