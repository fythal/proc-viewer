# -*- coding: utf-8 -*-
require 'spec_helper'

describe "panels/show" do
  before(:each) do
    @panel = assign(:panel, stub_model(Panel,
                                       :number => "Number",
                                       :height => 3,
                                       :width  => 3,
                                       ))
    procedure = stub_model(Procedure)
    procedure.stub(:path).and_return("/foo/bar.pdf")
    ann = stub_model(Ann, name: "foo", procedures: [procedure])

    @panel.assign(ann, to: "a1")
    @panel.assign(ann, to: "a2")
    @panel.assign(ann, to: "a3")
    @panel.assign(ann, to: "b1")
    @panel.assign(ann, to: "b3")
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
