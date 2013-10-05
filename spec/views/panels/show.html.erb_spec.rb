# -*- coding: utf-8 -*-
require 'spec_helper'

describe "panels/show" do
  before(:each) do
    procedure = stub_model(Procedure, path: "/foo/bar.pdf", filename: "bar.pdf")
    ann = stub_model(Ann, name: "foo", procedure: procedure)
    ann_array = [[ann, nil, ann], [nil, ann, nil], [ann, nil, ann]]

    panel = stub_model(Panel,
                       :number => "Number",
                       :height => 3,
                       :width  => 3,
                       )
    panel.stub(:anns).with({array: true}).and_return(ann_array)
    @panel = assign(:panel, panel)
  end

  it "基本データ設定" do
    expect(@panel.anns(array: true)).to be_kind_of(Array)
    expect(@panel.anns(array: true).first).to be_kind_of(Array)
  end

  it "警報パネルの名称を表示する" do
    render
    rendered.should match(/Number/)
  end

  it "テーブルを描画する" do
    render
    assert_select "table"
  end

  it "テーブルに 3 つの行数を描画する" do
    render
    assert_select "table tr", 3
  end

  it "テーブルに 9 つの td 要素を描画する" do
    render
    assert_select "table tr td", 9
  end

  it "テーブルの td 要素には、場所情報を含む id を設定する" do
    render
    assert_select "table tr td#loc_a1"
  end
end
