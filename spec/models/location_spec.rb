# -*- coding: utf-8 -*-
require 'spec_helper'

describe Location do
  describe "#to_s" do
    it "設定された場所 (location) を返す" do
      loc = Location.new(location: "a1")
      expect(loc.to_s).to eq("a1")
    end
  end
end
