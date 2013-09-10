# -*- coding: utf-8 -*-
require 'spec_helper'

describe "broken_objects/index" do
  it "broken_anns という id の要素がある" do
    render
    assert_select "#broken_anns"
  end

end
