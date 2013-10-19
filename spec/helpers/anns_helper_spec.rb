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

      it "リンクは ann クラスである" do
        procedure = stub_model(Procedure, path: "/foo/bar.pdf", filename: "bar.pdf")
        ann = stub_model(Ann, name: "foo", procedure: procedure)
        expect(helper.link_or_name(ann)).to match /^<a [^>]*class=['"]ann["']/
      end
    end

    describe "引数が一括警報 (Panel オブジェクト) である" do
      before(:each) do
        @item = stub_model(Panel, name: "foo", number: "bar")
      end

      it "一括警報へのリンクを返す" do
        expect(helper.link_or_name(@item)).to match /^<a /
      end

      it "name 属性の値を含む" do
        expect(helper.link_or_name(@item)).to match />foo</
      end

      it "リンクは panel クラスである" do
        expect(helper.link_or_name(@item)).to match /^<a [^>]*class=['"]panel["']/
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
