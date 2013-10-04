# -*- coding: utf-8 -*-
require 'spec_helper'

describe Location do
  describe "#to_s" do
    it "設定された場所 (location) を返す" do
      loc = Location.new(location: "a1")
      expect(loc.to_s).to eq("a1")
    end
  end

  describe "#location=" do
    describe "b3 を設定した場合" do
      it "#location は b3 を返す" do
        location = Location.new(location: "b3")
        expect(location.location).to eq("b3")
      end
      it "#x は 3 を返す" do
        location = Location.new(location: "b3")
        expect(location.x).to eq(3)
      end
      it "#y は 2 を返す" do
        location = Location.new(location: "b3")
        expect(location.y).to eq(2)
      end
    end
    describe "3b を設定した場合" do
      it "#location は b3 を返す" do
        location = Location.new(location: "3b")
        expect(location.location).to eq("b3")
      end
      it "#x は 3 を返す" do
        location = Location.new(location: "3b")
        expect(location.x).to eq(3)
      end
      it "#y は 2 を返す" do
        location = Location.new(location: "3b")
        expect(location.y).to eq(2)
      end
    end
  end

  describe "#location" do
    describe "x に 3, y に 2 が設定されている" do
      it "\"b3\" を返す" do
        location = Location.new(x: 3, y: 2)
        expect(location.location).to eq("b3")
      end
    end
    describe "x に nil, y に 3 が設定されている" do
      it "nil を返す" do
        location = Location.new(x: nil,  y: 3)
        expect(location.location).to be_nil
      end
    end
    describe "x に 2, y に nil が設定されている" do
      it "nil を返す" do
        location = Location.new(x: 2,  y: nil)
        expect(location.location).to be_nil
      end
    end
    describe "x に nil, y に nil が設定されている" do
      it "nil を返す" do
        location = Location.new(x: nil,  y: nil)
        expect(location.location).to be_nil
      end
    end
  end
end
