# -*- coding: utf-8 -*-
require 'spec_helper'

describe Board do
  describe "#<=>(other)" do
    before(:each) do
      @board = Board.new(name: "zzz")
      @other = Board.new(name: "aaa")
    end
    it "name を基にソートをする" do
      expect(@board <=> @other).to eq(1)
      expect(@other <=> @board).to eq(-1)
    end
  end
end
