# -*- coding: utf-8 -*-
require 'spec_helper'

describe Procedure do

  describe "#file_path" do
    context "path 属性が設定されている場合" do
      it "Rails の public ディレクトリ + path を返す" do
        procedure = Procedure.new
        procedure.send(:write_attribute, :path, "/foo/bar")
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
      procedure = Procedure.new
      procedure.send(:write_attribute, :path, "/procs/foo.pdf")
      expect(procedure.system_path).to eq("/Users/kueda/dev/proc-viewer/public/procs/foo.pdf")
    end
  end

  describe "#filename" do
    it "path 属性から生成したファイル名を返す" do
      procedure = Procedure.new
      procedure.send(:write_attribute, :path, "/procs/foo.pdf")
      expect(procedure.filename).to eq("foo.pdf")
    end
  end

  describe "#construct_filename" do
    before(:each) do
      @procedure = Procedure.new(revision: 6)
      @ann = stub_model(Ann, :procedure_header => "ann-m1-a1")
      @procedure.ann = @ann
    end
    it "割り当てられている警報に procedure_header メソッドを送る" do
      @ann.should_receive(:procedure_header)
      @procedure.construct_filename
    end
    it "procedure_header メソッドの返り値を返す" do
      expect(@procedure.construct_filename).to match /^ann-m1-a1/
    end
    it "手順書のファイル名は、手順書の改定番号 (3桁) を含んでいる" do
      expect(@procedure.construct_filename).to match /r006/
    end

    context "警報と関連付けられていないとき" do
      it "警報パネルの情報の部分は zz-zz となる" do
        @procedure.ann = nil
        expect(@procedure.construct_filename).to match /zz-zz/
      end
    end
    context "手順書の改定番号が設定されていないとき" do
      it "手順書のファイル名の手順書の改定番号の部分は \"r999\" となる" do
        @procedure.revision = nil
        expect(@procedure.construct_filename).to match /r999/
      end
    end
  end

  describe "#path=" do
    it "例外を発生する (プライベートメソッドのため)" do
      procedure = Procedure.new
      expect { procedure.path = "/foo/bar.pdf" }.to raise_error NoMethodError
    end

    it "プライベートメソッドであるというメッセージを例外に設定する (プライベートメソッドのため)" do
      procedure = Procedure.new
      begin
        procedure.path = "/foo/bar.pdf"
      rescue NoMethodError
        expect($!.to_s).to match /^private method/
      end
    end

    describe "path 属性が nil 以外のとき (手順書ファイルが存在しているはず)" do
      it "path の値を変更する" do
        procedure = Procedure.new
        procedure.send(:write_attribute, :path, "/foo/bar.pdf")
        expect(procedure.path).to eq("/foo/bar.pdf")
      end

      it "手順書ファイルの名称を変更する" do
        procedure = Procedure.new
        procedure.send(:write_attribute, :path, "/foo/bar.pdf")
        expect(File).to receive(:rename).with("#{Rails.public_path}/foo/bar.pdf", "#{Rails.public_path}/foo/bazz.pdf")
        procedure.send(:path=, "/foo/bazz.pdf")
      end
    end

    describe "path 属性が nil のとき (手順書ファイルは存在しない)" do
      it "path の値を設定する" do
        procedure = Procedure.new
        procedure.send(:path=, "/foo/bar.pdf")
        expect(procedure.path).to eq("/foo/bar.pdf")
      end
    end

    describe "すでに存在しているファイルと同じ名前に設定しようとする" do
      it "例外 Errno::EEXIST を発生する" do
        procedure = Procedure.new
        procedure.send(:write_attribute, :path, "/foo/bar.pdf")
        File.stub(:exist?).with("#{Rails.public_path}/foo/bazz.pdf").and_return(true)
        expect { procedure.send(:path=, "/foo/bazz.pdf") }.to raise_error Errno::EEXIST
      end
    end
  end

  describe "#write" do
    before(:each) do
      @tempfile = Tempfile.new(['foo', '.pdf'])
      @tempfile.print("This file is dummy for pdf file.\n")
      @tempfile.rewind

      @ann = Ann.create!(name: "foo")
      Panel.assign(@ann, panel: "n1", to: "a1")

      @procedure = Procedure.new(revision: 6, ann: @ann)
      @proc_dir = Rails.public_path.join("procs")
    end

    after(:each) do
      expect { File.unlink(@procedure.system_path) }.not_to raise_error
    end

    it "手順書のファイルをファイルシステムに保存する" do
      expect { @procedure.write @tempfile }.to change {@proc_dir.entries.count}.by(1)
    end

    it "手順書のファイルのパスを path 属性に設定する" do
      @procedure.write @tempfile
      expect(@procedure.path).to be_kind_of String
    end

    it "手順書の path 属性のパスにファイルが存在する" do
      @procedure.write @tempfile
      expect(File.exist?(@procedure.system_path)).to be_true
    end

    it "手順書のファイル名は \"ann\" で始まる" do
      @procedure.write @tempfile
      expect(@procedure.system_path).to match %r|^.*/ann[^/]*$|
    end

    it "手順書のファイル名は、警報パネルの名称と場所を含んでいる" do
      @procedure.write @tempfile
      expect(@procedure.system_path).to match %r|^.*/[^/]*-n1-a1-[^/]*$|
    end

    it "手順書のファイル名は、手順書の改定番号を含んでいる" do
      @procedure.write @tempfile
      expect(@procedure.system_path).to match %r|^.*/[^/]*-r006-[^/]*$|
    end

    context "手順書の改定番号が設定されていないとき" do
      it "手順書のファイル名の手順書の改定番号の部分は \"r999\" となる" do
        @procedure.revision = nil
        @procedure.write @tempfile
        expect(@procedure.system_path).to match %r|^.*/[^/]*-r999-[^/]*$|
      end
    end

    context "警報が警報パネルに配置されていないとき" do
      it "警報パネルの情報の部分は zz-zz となる" do
        @ann.location.destroy
        @ann.location(true)
        @ann.panel(true)
        @procedure.write @tempfile
        expect(@procedure.system_path).to match %r|^.*/[^/]*-zz-zz-[^/]*$|
      end
    end
  end

  describe "#update_path" do
    it "Procedure#construct_filename を呼出す" do
      procedure = Procedure.new
      ann = Ann.create!(name: "foo")
      Panel.assign(ann, panel: "m1", to: "a1")
      ann.procedures << procedure
      procedure.should_receive(:construct_filename).and_return("ann-m1-a1-r999-2013-10-18-13_25_05.pdf")
      procedure.update_path
    end
  end
end
