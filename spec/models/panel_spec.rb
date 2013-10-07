# -*- coding: utf-8 -*-
require 'spec_helper'

describe Panel do

  def valid_panel_attributes
    { number: "n1"}
  end

  def valid_panel_number
    valid_panel_attributes[:number]
  end

  def valid_ann_attributes
    { name: "HPCS 電気故障" }
  end

  def valid_location_attributes
    { location: "a1"}
  end

  #
  # 警報パネルと窓に警報を割り当てる
  #

  describe "Panel.assign(ann, panel_and_location)" do
    describe "警報は保存されていない" do
      before(:each) { @ann = Ann.new(valid_ann_attributes) }

      describe "パネルの番号は空白、場所は空白を指定する" do
        def params
          { panel: "", to: ""}
        end

        it "false を返す" do
          expect(Panel.assign(@ann, params)).to be_false
        end
        it "警報の location には invalid な Locaiton オブジェクトを設定" do
          Panel.assign(@ann, params)
          expect(@ann.location).to be_kind_of(Location)
          expect(@ann.location).not_to be_valid
        end
        it "警報の panel には invalid な Panel オブジェクトを設定" do
          Panel.assign(@ann, params)
          expect(@ann.location.panel).to be_kind_of(Panel)
          expect(@ann.location.panel).not_to be_valid
        end
        it "Panel オブジェクトを生成しない" do
          expect { Panel.assign(@ann, params) }.to change(Panel, :count).by(0)
        end
        it "Location オブジェクトを生成しない" do
          expect { Panel.assign(@ann, params) }.to change(Location, :count).by(0)
        end
      end
    end

    describe "警報は保存されている" do
      before(:each) { @ann = Ann.create!(valid_ann_attributes) }

      describe "パネルの番号を指定する" do
        describe "指定した番号のパネルが存在している"      # その場合は Panel#assign でスペックを規定
        describe "指定した番号のパネルは存在していない" do
          before(:each) do
            expect(Panel.find_by_number(valid_panel_attributes[:number])).to be_nil
            def new_location
              "a1"
            end
            def params
              { panel: valid_panel_number, to: new_location }
            end
          end

          it "Location オブジェクトが関連付ける" do
            Panel.assign(@ann, params)
            expect(@ann.location).to be_kind_of(Location)
          end
          it "Locaiton オブジェクトの location 属性を設定する" do
            Panel.assign(@ann, params)
            expect(@ann.location.location).to eq(new_location)
          end
          it "新規の Locaiton オブジェクトをデータベースに保存する" do
            expect {Panel.assign(@ann, params)}.to change(Location, :count).by(1)
          end
          it "警報パネルオブジェクトは作成する。これには location メソッド経由でアクセスできる" do
            Panel.assign(@ann, params)
            expect(@ann.location.panel).not_to be_nil
          end
          it "警報パネルオブジェクトは作成する。Ann#panel メソッドで直接アクセスできる" do
            Panel.assign(@ann, params)
            expect(@ann.panel).not_to be_nil
            expect(@ann.panel.number).to eq(valid_panel_number)
          end
          it "警報パネルオブジェクトはデータベースには保存されていない" do
            expect { Panel.assign(@ann, params) }.to change(Panel, :count).by(1)
          end
          it "true を返す" do
            expect { Panel.assign(@ann, params) }.to be_true
          end
        end
      end
    end
  end

  describe "#assign(ann, location)" do
    before(:each) do
      @ann = Ann.create!(valid_ann_attributes)
      @panel = Panel.create!(valid_panel_attributes)
      @location = valid_location_attributes[:location]
    end

    describe "割り当てられていない場所に警報を割り当てる" do
      it "警報を警報パネルと関連付ける" do
        @panel.assign(@ann, to: @location)
        expect(@ann.location.panel).to eq(@panel)
      end
    end

    describe "場所に空白が指定される" do
      describe "警報が保存されている場合" do
        it "false が返される" do
          expect(@panel.assign(@ann, to: "")).to be_false
        end
      end
      describe "警報が保存されていない場合" do
        before(:each) do
          # すでに属性が存在しているというエラーメッセージを避けるため
          @ann.destroy
          @ann = Ann.new(valid_ann_attributes)
          @panel.assign(@ann, to: "")
        end
        it "警報の locaiton が設定される" do
          expect(@ann.location).to be_kind_of(Location)
        end
        it "警報の location の location 属性を空白にする" do
          expect(@ann.location.location).to eq("")
        end
      end
    end

    # context "すでに警報パネルが割り当てられている" do
    #   before(:each) do
    #     @ann.panel = Panel.create!(number: @new_number + "xxx")
    #     @panel = Panel.find_or_create_by!(number: @new_number + "xxx") do |panel|
    #       panel.assign(@ann)
    #     end
    #     expect { Panel.assign(panel: @new_number + "xxx")
    #     end
    #     it "他のパネルを割り当てると、元のパネルに destroy を送る" do
    #       @ann.panel.should_receive(:destroy)
    #       @proc.call
    #     end
    #   end

    #   context "割り当てようとした警報パネルの場所に他の警報がすでに割り当てられている" do
    #     it "false を返す"
    #     it "@ann の panel_location 属性にエラーが設定される"
    #   end

    #   describe "警報パネルの番号は正しく指定されるが、場所は空文字列が指定される" do
    #     before(:each) do
    #       @return_value = @ann.assign(panel: @new_number, location: "")
    #     end
    #     it "false を返す" do
    #       expect(@return_value).to be_false
    #     end
    #     it "Location オブジェクトが作成される" do
    #       expect(@ann.location).not_to be_nil
    #     end
    #     it "Location オブジェクトの locaiton 属性は空文字である" do
    #       expect(@ann.location.location).to eq("")
    #     end
    #     it "Location オブジェクトはデータベースには保存されていない" do
    #       expect(@ann.location).to be_new_record
    #     end
    #     it "@ann の panel_location 属性にエラーが設定される" do
    #       expect(@ann.errors[:panel_location]).not_to be_empty
    #     end
    #     it "警報パネルオブジェクトは作成する。これには location メソッド経由でアクセスできる" do
    #       expect(@ann.location.panel).not_to be_nil
    #     end
    #     it "警報パネルオブジェクトは作成する。panel メソッドで直接アクセスできない" do
    #       expect(@ann.panel).to be_nil
    #     end
    #     it "警報パネルオブジェクトはデータベースには保存されていない" do
    #       expect(@ann.location.panel).to be_new_record
    #     end
    #   end
    # end
  end

  describe "Panel.assigned?(panel_and_location)" do
    describe "既存のパネルの空いている場所を指定" do
      # it "false を返す"
    end
    describe "既存のパネルの合いていない場所を指定" do
      # it "true を返す"
    end
    describe "既存のパネルに対して、場所指定が空白の場合" do
    end
    describe "存在しないパネルの場所"
    describe "存在しないパネルに対して、場所指定が空白の場合"
  end

  describe "#assigned?(loc)" do
    context "関連する Location オブジェクトの中で loc を location 属性に持っているものがある" do
      it "true を返す" do
        ann = stub_model(Ann)
        panel = Panel.create!(valid_panel_attributes)
        panel.assign(ann, to: valid_location_attributes[:location])
        expect(panel.assigned?(valid_location_attributes[:location])).to be_true
      end
    end

    context "関連する Location オブジェクトの中で loc を location 属性に持っているものがない" do
      it "false を返す" do
        panel = Panel.create!(valid_panel_attributes)
        expect(panel.assigned?("a1")).to be_false
      end
    end
  end


  describe "#destroy" do
    before(:each) do
      @panel = Panel.create!(valid_panel_attributes)
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


  describe "#height" do
    context "_height が nil" do
      context "パネルには Location オブジェクトが関連付けられていない" do
        it "nil を返す" do
          panel = Panel.new
          expect(panel.height).to eq(0)
        end
      end

      context "パネルには Location オブジェクトが関連付けられている" do
        it "Location オブジェクトの y 属性の最大を返す" do
          locs = []
          locs << stub_model(Location, y: 1)
          locs << stub_model(Location, y: 8)
          locs << stub_model(Location, y: 2)
          panel = Panel.new
          panel.locations = locs
          expect(panel.height).to eq(8)
        end
      end
    end

    context "_height に値が設定されている" do
      context "パネルには Location オブジェクトが関連付けられていない" do
        it "_height の値を返す" do
          panel = Panel.new(_height: 8)
          expect(panel.height).to eq(8)
        end
      end

      context "パネルには Location オブジェクトが関連付けられている" do
        context "Location オブジェクトの y 属性の最大が _height より大きいとき" do
          it "Location オブジェクトの y 属性の最大値を返す" do
            locs = []
            locs << stub_model(Location, y: 1)
            locs << stub_model(Location, y: 8)
            locs << stub_model(Location, y: 2)
            panel = Panel.new(_height: 3)
            panel.locations = locs
            expect(panel.height).to eq(8)
          end
        end

        context "Location オブジェクトの y 属性の最大が _height より小さいとき" do
          it "_height の値を返す" do
            locs = []
            locs << stub_model(Location, y: 1)
            locs << stub_model(Location, y: 8)
            locs << stub_model(Location, y: 2)
            panel = Panel.new(_height: 20)
            panel.locations = locs
            expect(panel.height).to eq(20)
          end
        end
      end
    end
  end

  describe "#height=" do
    it "height が設定した値を返す" do
      panel = Panel.new(height: 3)
      expect(panel.height).to eq(3)
    end
  end

  describe "#anns(option)" do
    describe "引数なし" do
      it "anns_orig を呼出す" do
        panel = Panel.new
        panel.should_receive(:anns_orig)
        panel.anns
      end
    end

    describe "引数が true/false" do
      it "anns_orig を呼出す" do
        panel = Panel.new
        panel.should_receive(:anns_orig)
        panel.anns(true)
      end
    end

    describe "引数が :array" do
      it "2次元配列を返す" do
        panel = Panel.new(width: 3, height: 3)
        expect(panel.anns(array: true)).to be_kind_of(Array)
        expect(panel.anns(array: true).first).to be_kind_of(Array)
      end

      it "配列の大きさは警報パネルと同じ" do
        panel = Panel.new(width: 3, height: 3)
        expect(panel.anns(array: true).size).to eq(3)
        expect(panel.anns(array: true).first.size).to eq(3)
      end
    end
  end

  describe "#<=>(other)" do
    before(:each) do
      @panel = Panel.new(number: "zzz")
      @other = Panel.new(number: "aaa")
    end
    it "number を基にソートをする" do
      expect(@panel <=> @other).to eq(1)
      expect(@other <=> @panel).to eq(-1)
    end
  end

end
