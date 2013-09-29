# -*- coding: utf-8 -*-
require 'spec_helper'

describe "searches/show" do
  before(:each) do
    flash[:notice] = "ようこそ、foo さん"
    assign(:search, stub_model(Search, keywords: "foobar"))
    assign(:anns, [stub_model(Ann, name: "foo"), stub_model(Ann, name: "foo")])
    Ann.any_instance.stub_chain(:procedure, :path).and_return("/procs/bar.pdf")
  end

  it "flash[:notice] の内容を表示する" do
    render
    rendered.should match(/ようこそ、foo さん/)
  end

  it "検索のキーワードを表示する" do
    render
    rendered.should match(/検索キーワード: foobar/)
  end
end
