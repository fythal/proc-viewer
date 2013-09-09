# -*- coding: utf-8 -*-
require 'spec_helper'

describe Procedure do
  context "2 つの手順書があり、同じ警報用のものであるが、リビジョンが違う" do
    before(:each) do
      @prev_revision = Procedure.create
      @next_revision = Procedure.create
      @next_revision.update_attribute(:prev_revision_id, @prev_revision.to_param)
    end

    describe "#prev_revision" do
      it "前のリビジョンの手順書を辿ることができる" do
      expect(@next_revision.prev_revision).to eq(@prev_revision)
      end
    end

    describe "#next_revision" do
      it "次のリビジョンの手順書を辿ることができる" do
        expect(@prev_revision.next_revision).to eq(@next_revision)
      end
    end

    describe "#latest_revision" do
      it "最新版の手順書を辿ることができる" do
        expect(@prev_revision.latest_revision).to eq(@next_revision)
      end
    end
  end
end
