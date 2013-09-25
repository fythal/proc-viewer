# -*- coding: utf-8 -*-
require 'spec_helper'

describe Procedure do
  describe "#file_path" do
    context "path 属性が設定されている場合" do
      it "Rails の public ディレクトリ + path を返す" do
        procedure = Procedure.new(path: "/foo/bar")
        expect(procedure.file_path).to eq(Rails.public_path.join(procedure.path.sub(%r|^/|, "")).to_s)
      end
    end

    context "path 属性が設定されていない場合" do
      it "nil を返す" do
        procedure = Procedure.new
        expect(procedure.file_path).to be_nil
      end
    end
  end
end
