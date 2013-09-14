# -*- coding: utf-8 -*-
require 'spec_helper'

describe Panel do
  describe "#assigned?(loc)" do
    context "関連する Location オブジェクトの中で loc を location 属性に持っているものがある" do
      it "true を返す" do
        panel = Panel.create
        panel.locations << Location.create(location: "a1")
        expect(panel.assigned?("a1")).to be_true
      end
    end

    context "関連する Location オブジェクトの中で loc を location 属性に持っているものがない" do
      it "false を返す" do
        panel = Panel.create
        expect(panel.assigned?("a1")).to be_false
      end
    end
  end
end
