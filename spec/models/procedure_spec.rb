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

  describe "#system_path" do
    it "path 属性から生成したシステムのパスを返す" do
      procedure = Procedure.create!(path: "/procs/foo.pdf")
      expect(procedure.system_path).to eq("/Users/kueda/dev/proc-viewer/public/procs/foo.pdf")
    end
  end

  describe "#filename" do
    it "path 属性から生成したファイル名を返す" do
      procedure = Procedure.create!(path: "/procs/foo.pdf")
      expect(procedure.filename).to eq("foo.pdf")
    end
  end

  describe "#write" do
    before(:each) do
      @tempfile = Tempfile.new(['foo', '.pdf'])
      @tempfile.print("This file is dummy for pdf file.\n")
      @tempfile.rewind

      @ann = Ann.create!(name: "foo")
      Panel.assign(@ann, panel: "n1", to: "a1")
      @procedure = Procedure.create!(revision: 6, ann: @ann)
      @proc_dir = Rails.public_path.join("procs")
    end

    after(:each) do
      expect { File.unlink(@procedure.system_path) }.not_to raise_error
    end

    it "手順書のファイルをファイルシステムに保存する" do
      expect { @procedure.write @tempfile }.to change {@proc_dir.entries.count}.by(1)
    end

    it "手順書のファイルのパスを path 属性に設定する" do
      expect(@procedure.path).to be_nil
      @procedure.write @tempfile
      expect(@procedure.path).to be_kind_of String
      expect(File.exist?(@procedure.system_path)).to be_true
    end
  end
end
