# -*- coding: utf-8 -*-
require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the AnnsHelper. For example:
#
# describe AnnsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe AnnsHelper do
  describe "link_or_name" do
    describe "引数が警報オブジェクトで手順書が設定されている" do
      it "手順書へのリンクを返す" do
        procedure = stub_model(Procedure, path: "/foo/bar.pdf", filename: "bar.pdf")
        ann = stub_model(Ann, name: "foo", procedure: procedure)
        expect(helper.link_or_name(ann)).to match /^<a /
      end
      it "手順書へ名称を含む" do
        procedure = stub_model(Procedure, path: "/foo/bar.pdf", filename: "bar.pdf")
        ann = stub_model(Ann, name: "bazz", procedure: procedure)
        expect(helper.link_or_name(ann)).to match /bazz/
      end
    end
    describe "引数が警報オブジェクトで手順書が設定されていない" do
      it "警報の名称を返す" do
        ann = stub_model(Ann, name: "bazz")
        expect(helper.link_or_name(ann)).to eq("bazz")
      end
    end
    describe "引数が nil のとき" do
      it "空白を返す" do
        expect(helper.link_or_name(nil)).to eq("")
      end
    end
  end
end
