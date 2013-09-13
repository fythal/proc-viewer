# -*- coding: utf-8 -*-
require 'spec_helper'

describe Panel do
  describe "#assign(ann, location)" do
    context "割り当てようとする場所に他の警報が割り当てられていないとき" do
      it "true を返す" do
        expect(ann.assign(ann, "a1")).to be_true
      end

      it "その場所が「割り当て済み」となる" do
        panel.assign(ann, "a1")
        expect(panel.occupied?("a1")).to be_true
      end

      it "警報にパネルが設定される" do
        panel.assign(ann, "a1")
        expect(ann.panel).to eq(panel)
      end

      it "警報にパネルが設定される" do
      end
    end
  end
end
