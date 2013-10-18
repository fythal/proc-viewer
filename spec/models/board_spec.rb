# -*- coding: utf-8 -*-
require 'spec_helper'

describe Board do
  describe "#<=>(other)" do
    before(:each) do
      @one   = Board.new(code: "A")
      @two   = Board.new(code: "B")
      @three = Board.new(name: "AAA")
      @four  = Board.new(name: "BBB")

      @sp_one    = Board.new(code: "H11-P700")
      @sp_two    = Board.new(code: "H11-P704-2")
      @sp_three    = Board.new(code: "H11-P703")
    end

    it "code をアルファベット順に比較する" do
      expect(@one <=> @two).to eq(-1)
    end

    it "code が設定されていないものより設定されている方が順方向とする" do
      expect(@two <=> @three).to eq(-1)
    end

    it "code が設定されていないもの同士では name を比較する" do
      expect(@three <=> @four).to eq(-1)
    end

    it "「特別」な盤は一般的なルールが除外され、先に持って来る" do
      expect(@sp_one <=> @one).to eq(-1)
    end

    it "「特別」な盤同士でも特定のルールで順番を決める (ルールはアプリケーションの設定)" do
      expect(@sp_two <=> @sp_three).to eq(-1)
    end
  end
end
