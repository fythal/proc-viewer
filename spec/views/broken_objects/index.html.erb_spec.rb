# -*- coding: utf-8 -*-
require 'spec_helper'

describe "broken_objects/index" do
  def anns_without_proc
    [
      stub_model(Ann, :name => "Ann without proc")
    ]
  end

  it "broken_anns という id の要素がある" do
    assign(:broken_anns, anns_without_proc)
    render
    assert_select "#broken_anns a", :text => "Ann without proc"
  end

end
