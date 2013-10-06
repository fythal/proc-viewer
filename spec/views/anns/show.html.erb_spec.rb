# -*- coding: utf-8 -*-
require 'spec_helper'

describe "anns/show" do
  context "警報がパネルにアサインされている" do
    before(:each) do
      @panel = assign(:panel, stub_model(Panel, :id => 1, :number => "n1"))
      @ann = assign(:ann, stub_model(Ann, :name => "Name"))
    end

    it "パネルへのリンクを描画する" do
      render
      assert_select '#ann_panel' do
        assert_select 'a[href=?]', panel_path(@panel), {text: @panel.number}
      end
    end
  end

  context "警報にはパネルと窓がアサインされていない" do
    before(:each) do
      @ann = assign(:ann, stub_model(Ann, :name => "Name"))
    end

    it "renders attributes in <p>" do
      render
      assert_select '#ann_panel' do
        assert_select 'a', 0
      end
    end
  end

  context "警報に手順書が関連付けられている" do
    before(:each) do
      procs = assign(:procedures,
                     [stub_model(Procedure, :id => 2, :path => "/foo/bar.pdf", :revision => 0, :revised_on => Date.new(1999,9,11)),
                       stub_model(Procedure, :id => 2, :path => "/foo/bar.pdf", :revision => 1, :revised_on => Date.new(2011,8,15))])

      assign(:ann, stub_model(Ann, :id => 1, :name => "Name", :procedure => procs.last, :procedures => procs))
    end

    it "手順書へのリンクがある" do
      render
      assert_select "a[href=?]", "/foo/bar.pdf"
    end

    it "手順書へのリンクにはファイル名が表示されている" do
      render
      assert_select "a[href=?]", "/foo/bar.pdf", :text => "bar.pdf"
    end

    it "手順書へのリンクは #ann_procedure 要素の中に入っている" do
      render
      assert_select "#ann_procedure" do
        assert_select "a[href=?]", "/foo/bar.pdf"
      end
    end

    it "最新も含め過去の手順書がリストアップされている" do
      render
      assert_select "#ann_procedures" do
        assert_select "td.revision", :text => "0"
        assert_select "td.revision", :text => "1"
        assert_select "td.revised_on", :text => /1999.*9.*11/
        assert_select "td.revised_on", :text => /2011.*8.*15/
        assert_select "td.file a[href=?]", "/foo/bar.pdf", 2
      end
    end
  end

  context "警報の場所を示す @location が設定されている" do
    before(:each) do
      ann = stub_model(Ann)
      panel = stub_model(Panel)
      location = stub_model(Location, to_s: "a1", location: "a1", ann: ann, panel: panel)
      ann.stub(:location).and_return(location)
      assign(:ann, ann)
    end

    it "警報の場所を #ann_panel_location に表示する" do
      render
      assert_select "#ann_panel_location", :text => /a1/
    end
  end

  context "警報に手順書が関連付けられているが、手順書には日付が設定されていない" do
    before(:each) do
      assign(:ann, stub_model(Ann,
                              :name => "Name",
                              :procedure => stub_model(Procedure, :path => "/procs/bar.pdf"),
                              :procedures => [stub_model(Procedure, :path => "/foo/bar.pdf", :revision => 0)]))
    end

    it "手順書の改訂日の表示欄に \"(未設定)\" と表示する" do
      render
      assert_select ".revised_on", :text => "(未設定)"
    end
  end
end
