# -*- coding: utf-8 -*-
require 'spec_helper'

describe "procedures/new" do
  before(:each) do
    @procedure = stub_model(Procedure, :path => "MyString", :ann_id => 1, :revision => "", :revised_on => "MyString").as_new_record
    assign(:procedure, @procedure)
  end

  describe "新規の手順書が警報に割り当てられる場合" do
    before(:each) do
      @ann = stub_model(Ann, id: 1, name: "MyAnnName")
      assign(:ann, @ann)
    end

    it "アクションに警報の id が含まれたフォームを描画する" do
      render

      assert_select "form[action=?][method=?]", ann_procedures_path(@ann), "post" do
        # assert_select "input#procedure_ann_id[name=?]", "procedure[ann_id]"
        assert_select "input#procedure_revision[name=?]", "procedure[revision]"
        assert_select "input#procedure_revised_on[name=?]", "procedure[revised_on]"
        assert_select "input#procedure_file[name=?][type=?]", "procedure[file]", "file"
      end
    end

    it "警報名称を表示する" do
      render
      assert_select "#ann_name", /#{@ann.name}/
    end

    describe "警報に割り当てられている手順書の最新の情報の表示" do
      describe "警報には手順書が割り当てられている" do
        it "最新の手順書の改定番号が表示される" do
          assign(:ann, stub_model(Ann, :name => "MyAnnName",
                                  :procedure => stub_model(Procedure, revision: 1, id: 101, path: "/foo/bar.jpg"),
                                  :procedures =>
                                  [
                                    stub_model(Procedure, revision: 0, id: 100, path: "/foo/bar.jpg"),
                                    stub_model(Procedure, revision: 1, id: 101,path: "/foo/bar.jpg" ),
                                  ]))
          render
          assert_select "#prev_revision", text: /1/
        end
      end

      describe "警報には手順書が割り当てられていない" do
        it "最新の手順書の改定番号の欄には「(手順書なし)」と表示される" do
          assign(:ann, stub_model(Ann, :name => "MyAnnName", :procedure => nil, :procedures => []))
          render
          assert_select "#prev_revision", text: /\(手順書なし\)/
        end
      end
    end
  end

  describe "新規の手順書がどの警報にも割り当てられない場合" do
    it "renders new procedure form" do
      render

      assert_select "form[action=?][method=?]", procedures_path, "post" do
        assert_select "input#procedure_ann_id[name=?]", "procedure[ann_id]"
        assert_select "input#procedure_revision[name=?]", "procedure[revision]"
        assert_select "input#procedure_revised_on[name=?]", "procedure[revised_on]"
        assert_select "input#procedure_file[name=?][type=?]", "procedure[file]", "file"
      end
    end
  end
end
