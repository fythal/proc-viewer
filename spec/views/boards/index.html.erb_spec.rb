# -*- coding: utf-8 -*-
require 'spec_helper'

describe "boards/index" do
  before(:each) do
    assign(:boards, [
             stub_model(Board, :code => "Code", :name => "Name"),
             stub_model(Board, :code => "Code", :name => "Name"),
           ])
  end

  it "盤の一覧を描画する" do
    render
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
