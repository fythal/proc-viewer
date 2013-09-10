# -*- coding: utf-8 -*-
require 'spec_helper'

describe "broken_objects/index" do
  def anns_without_proc
    [
      stub_model(Ann, :name => "Ann without proc")
    ]
  end

  context "@broken_anns に 1 つ以上の警報オブジェクトが割り当てられている" do
    before(:each) do
      assign(:broken_anns, anns_without_proc)
    end

    it "#broken_anns の要素がある (壊れた警報をグループ化するため)" do
      render
      assert_select "#broken_anns"
    end

    it "壊れた警報はリンクで示される" do
      render
      assert_select "#broken_anns a", :text => "Ann without proc"
    end
  end

  context "@broken_anns に警報オブジェクトが割り当てられていない" do
    before(:each) do
      assign(:broken_anns, [])
    end

    it "#broken_anns の要素がある (壊れた警報をグループ化するため)" do
      render
      assert_select "#broken_anns"
    end

    it "リンクの要素が存在していない" do
      render
      assert_select "#broken_anns a", false
    end
  end

end
