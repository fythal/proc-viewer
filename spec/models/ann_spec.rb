# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ann do
  def valid_ann_attributes
    { name: "HPCS 電気故障" }
  end

  def valid_panel_attributes
    { number: "n1" }
  end

  def valid_panel_number
    valid_panel_attributes[:number]
  end

  def valid_ann_location
    "a1"
  end

  describe 'initialize' do
    context 'name: のみが指定されたとき' do
      before(:each) do
        @ann = Ann.new(valid_ann_attributes)
      end

      it "名称を返す" do
        expect(@ann.name).to eq(valid_ann_attributes[:name])
      end
    end

    context "panel: と location: が文字列で指定されたとき" do
      before(:each) do
        @ann = Ann.new(valid_ann_attributes)
        Panel.assign(@ann, panel: valid_panel_number, to: valid_ann_location)
      end

      it "Location オブジェクトと関連付ける" do
        expect(@ann.location).not_to be_nil
        expect(@ann.location).to be_a_kind_of(Location)
      end

      it "Location オブジェクトは保存しない" do
        expect(@ann.location).to be_new_record
      end

      it "関連する Location オブジェクトの「場所」を正しく設定する" do
        expect(@ann.location.location).to eq(valid_ann_location)
      end

      it "#location.panel によって Panel オブジェクトへのアクセスはできる" do
        expect(@ann.location.panel).not_to be_nil
      end

      it "#location.panel によってアクセスできる Panel オブジェクトは設定したパネル番号が設定されている" do
        expect(@ann.location.panel.number).to eq(valid_panel_number)
      end

      it "#panel によって Panel オブジェクトへのアクセスできないようにする" do
        # @ann を保存したらアクセスできるはず
        expect(@ann.panel).to be_nil
      end

      it "警報を保存して、panel(true) によって Panel オブジェクトへアクセスすることができる" do
        @ann.save
        @ann.panel(true)
        expect(@ann.panel).not_to be_nil
      end

      it "関連する Panel オブジェクトの番号を正しく設定する" do
        @ann.save
        @ann.panel(true)
        expect(@ann.panel.number).to eq(valid_panel_number)
      end
    end
  end

  #   context '設定した窓のところにすでに他の警報が割り当てられている' do
  #     before(:each) do
  #       @ann   = Ann.create!(:panel => "n1")
  #       @other = Ann.create!(:panel => "n1", :window => "a1")

  #       @ann.window = "a1"
  #     end
  #   end

  
  #   context '警報にパネル番号が設定されているが、窓番号は設定されていない' do
  #     before(:each) do
  #       @ann = Ann.create(panel: "n1")
  #     end

  #     context '手順書が割り当てられていない' do
  #       before(:each) do
  #         expect(@ann.procedures).to be_empty
  #       end

  #       describe '窓番号を設定して保存する' do
  #         before(:each) do
  #           @ann.window = "a1"
  #           @ann.save
  #         end

  #         it "その警報用に手順書オブジェクトは生成される" do
  #           expect(@ann.procedures).not_to be_empty
  #         end

  #       end
  #     end

  describe "#procedure" do
    before(:each) do
      @ann = Ann.create!(valid_ann_attributes)
    end

    context '手順書が割り当てられている' do
      it "手順書を返す" do
        @ann.procedures << Procedure.create!
        expect(@ann.procedure).to be_kind_of(Procedure)
      end
      it "最新の手順書を返す" do
        procedure = Procedure.create!
        @ann.procedures << procedure
        expect(@ann.procedure).to eq(procedure)
      end
    end

    context "手順書が割り当てられていない" do
      it "nil を返す" do
        expect(@ann.procedure).to be_nil
      end
    end
  end

  #     context '手順書が割り当てられている' do
  #       before(:each) do
  #         @proc = Procedure.create(ann: @ann, path: "/assets/procs/foo-bar.pdf")
  #         expect(@ann.procedures.size).to eq(1)
  #       end

  #       describe '窓番号を設定して保存する' do
  #         before(:each) do
  #           @ann.window = "a1"
  #           @ann.save
  #         end

  #         it "手順書オブジェクトが生成されることはない" do
  #           expect(@ann.procedures).to eq([@proc])
  #         end

  #       end
  #     end
  #   end


  describe "#panel=" do
    it "例外 NoMethodError が発生する" do
      ann = Ann.create!(name: "foo")
      panel = Panel.create!(number: "bar")
      expect { ann.panel = panel }.to raise_error(NoMethodError)
    end
  end


  describe '#panel_number' do
    context "警報がパネルに割り当てられているとき" do
      it "割り当てらえている警報パネルの番号を返す" do
        ann = Ann.create!(valid_ann_attributes)

        panel = Panel.create!(valid_panel_attributes)
        panel.assign(ann, to: valid_ann_location)

        expect(ann.panel_number).to eq(valid_panel_number)
      end
    end

    describe "未保存の警報がパネルに割り当てられているとき" do
      it "割り当てらえている警報パネルの番号を返す" do
        ann = Ann.new(valid_ann_attributes)

        panel = Panel.new(valid_panel_attributes)
        panel.assign(ann, to: valid_ann_location)

        expect(ann.panel_number).to eq(valid_panel_number)
      end
    end

    context "警報がパネルに割り当てられていないとき" do
      it "nil を返す" do
        ann = Ann.create!(valid_ann_attributes)
        expect(ann.panel_number).to be_nil
      end
    end
  end


  describe "#location=" do
    context "引数が文字列のとき" do
      it "Location の location 属性が引数の文字列に値が設定される" do
        ann = Ann.create(valid_ann_attributes)
        ann.location = "a1"
        expect(ann.location.location).to eq("a1")
      end
    end
  end


  #
  # 疑似属性 panel_number と panel_location についてのスペック
  #
  context "警報に関連する Location オブジェクトがない" do
    describe "#panel_number"
    describe "#panel_number="
    describe "#panel_location"
    describe "#panel_location="
  end

  context "警報と関連する Location オブジェクトがある" do
    context "location 属性が設定されていない" do
      describe "#panel_number"
      describe "#panel_number="
      describe "#panel_location"
      describe "#panel_location="
    end

    context "location 属性が設定されている" do
      before(:each) do
        @ann = Ann.create!(valid_ann_attributes)
        location = Location.create!(location: "a1")
        @ann.location = location
      end
      describe "#panel_number"
      describe "#panel_number="
      describe "#panel_location" do
        it "関連付けられた Location オブジェクトの location 属性を返す" do
          expect(@ann.panel_location).to eq("a1")
        end
      end
      describe "#panel_location="
    end
  end

  context "警報と関連する Location オブジェクトと Panel オブジェクトがある" do
    context "location 属性が設定されていない" do
      describe "#panel_number"
      describe "#panel_number="
      describe "#panel_location"
      describe "#panel_location="
    end

    context "location 属性が設定されている" do
      describe "#panel_number"
      describe "#panel_number="
      describe "#panel_location"
      describe "#panel_location="
    end
  end

  describe "#panel_location" do
    context "Location の関連がされているとき" do
      it "Location の location 属性が返される" do
        ann = Ann.create!(valid_ann_attributes)
        ann.location = Location.new(location: "a1")

        expect(ann.panel_location).to eq("a1")
      end
    end

    context "Location の関連がされていないとき" do
      it "nil が返される" do
        ann = Ann.create!(valid_ann_attributes)
        expect(ann.panel_location).to be_nil
      end
    end
  end

  describe "#panel_and_location_if_assigned" do
    context "保存されていない警報について、関連する Location オブジェクトがない (パネルに割り当てられていない)" do
      it "true を返す" do
        ann = Ann.new(valid_ann_attributes)
        expect(ann.send(:panel_and_location_if_assigned)).to be_true
      end
      it "errors が発生していない" do
        ann = Ann.new(valid_ann_attributes)
        ann.send(:panel_and_location_if_assigned)
        expect(ann.errors).to be_empty
      end
    end

    context "保存された警報について、関連する Location オブジェクトがある" do
      context "location 属性が設定されていない"
      context "location 属性が設定されている" do
        before(:each) do
          @ann = Ann.create!(valid_ann_attributes)
          @ann.build_location(location: "a1")
        end
        it "false を返す" do
          expect(@ann.send(:panel_and_location_if_assigned)).to be_false
        end
        it "panel_number 属性についてエラーが設定されている" do
          @ann.send(:panel_and_location_if_assigned)
          expect(@ann.errors[:panel_number]).not_to be_empty
        end
      end
    end

    describe "警報パネルの番号が空白である" do
      it "false を返す" do
        ann = Ann.new(valid_ann_attributes)
        Panel.assign(ann, panel: "", to: valid_ann_location)
        expect(ann.valid?).to be_false
      end
    end

    describe "警報パネルの番号と場所が空白である" do
      it "true を返す" do
        ann = Ann.new(valid_ann_attributes)
        Panel.assign(ann, panel: "", to: "")
        expect(ann).to be_valid
      end
    end

    describe "警報が保存されていない" do
      context "Location オブジェクトがない" do
        describe "Panel オブジェクトがない"
        describe "Panel オブジェクトがある" do
          describe "警報は number が設定されている"
          describe "警報は number が設定されていない"
        end
      end

      context "警報と関連する Location オブジェクトがある" do
        context "location 属性が設定されていない" do
          describe "Panel オブジェクトがない"
          describe "Panel オブジェクトがある" do
            describe "警報は number が設定されている"
            describe "警報は number が設定されていない"
          end
        end
        context "location 属性が設定されている" do
          describe "Panel オブジェクトがない"
          describe "Panel オブジェクトがある" do
            describe "警報は number が設定されている"
            describe "警報は number が設定されていない"
          end
        end
      end
    end

    describe "警報が保存されている" do
      context "Location オブジェクトがない" do
        describe "Panel オブジェクトがない"
        describe "Panel オブジェクトがある" do
          describe "警報は number が設定されている"
          describe "警報は number が設定されていない"
        end
      end

      context "警報と関連する Location オブジェクトがある" do
        context "location 属性が設定されていない" do
          describe "Panel オブジェクトがない"
          describe "Panel オブジェクトがある" do
            describe "警報は number が設定されている"
            describe "警報は number が設定されていない"
          end
        end
        context "location 属性が設定されている" do
          describe "Panel オブジェクトがない"
          describe "Panel オブジェクトがある" do
            describe "警報は number が設定されている"
            describe "警報は number が設定されていない"
          end
        end
      end
    end

    context "警報と関連する Location オブジェクトと Panel オブジェクトがある" do
      context "location 属性が設定されていない"
      context "location 属性が設定されている"
    end
  end

  describe "#procedure_header" do
    context "警報パネルに割り当てられている場合" do
      before(:each) do
        @ann = Ann.create!(name: "CRD")
        Panel.assign(@ann, panel: "m1", to: "a1")
      end
      it "'ann' で始まる文字列を返す" do
        expect(@ann.procedure_header).to match /^ann/
      end
      it "警報パネルの名称や場所が含まれる文字列を返す" do
        expect(@ann.procedure_header).to match /-m1-a1/
      end
    end

    context "警報パネルに割り当てられていない場合" do
      it "\"ann-zz-zz\" を返す" do
        ann = Ann.create!(name: "CRD")
        expect(ann.procedure_header).to match /^ann-zz-zz/
      end
    end
  end

  describe "#search" do
    before(:each) do
      Ann.create!(name: "foo 故障")
      Ann.create!(name: "bar 故障")
    end

    describe "マッチするキーワードが与えられた" do
      it "マッチする警報の配列が返される" do
        search_result = Ann.search("foo")
        expect(search_result).to be_kind_of(Array)
        expect(search_result).not_to be_empty
        expect(search_result.first.name).to eq("foo 故障")
      end
    end

    describe "マッチするキーワードが与えられなかった" do
      it "空の配列を返す" do
        search_result = Ann.search("baz")
        expect(search_result).to be_kind_of(Array)
        expect(search_result).to be_empty
      end
    end
  end
end
