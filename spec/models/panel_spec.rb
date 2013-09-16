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

  describe "#destroy" do
    before(:each) do
      @panel = Panel.create
      @panel_id = @panel.id
    end

    context "警報が関連付けられているとき" do
      before(:each) do
        @panel.stub(:anns).and_return([stub_model(Ann)])
      end

      it "削除操作をキャンセルする" do
        expect(@panel.destroy).to be_false
      end

      it "データベースにパネルは残っている" do
        @panel.destroy
        expect { Panel.find(@panel_id) }.not_to raise_error
      end
    end

    context "警報が関連付けられていないとき" do
      before(:each) do
        @panel.stub(:anns).and_return([])
      end

      it "削除操作が成功する" do
        expect(@panel.destroy).to be_true
      end

      it "データベースにパネルは残っていない" do
        @panel.destroy
        expect { Panel.find(@panel_id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
