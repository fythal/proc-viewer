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
    before(:each) do
      @ann = Ann.create!(valid_ann_attributes)
    end

    context "指定した番号を持つパネルが存在していない" do
      before(:each) do
        expect(Panel.find_by_number(valid_panel_attributes[:number])).to be_nil
        @new_location = "a1"
        @proc = Proc.new { Panel.assign(@ann, panel: valid_panel_number, to: @new_location) }
      end
      it "Location オブジェクトが関連付ける" do
        @proc.call
        expect(@ann.location).to be_kind_of(Location)
      end
      it "Locaiton オブジェクトの location 属性を設定する" do
        @proc.call
        expect(@ann.location.location).to eq(@new_location)
      end
      it "新規の Locaiton オブジェクトをデータベースに保存する" do
        expect { @proc.call }.to change(Location, :count).by(1)
      end
      it "警報パネルオブジェクトは作成する。これには location メソッド経由でアクセスできる" do
        @proc.call
        expect(@ann.location.panel).not_to be_nil
      end
      it "警報パネルオブジェクトは作成する。Ann#panel メソッドで直接アクセスできる" do
        @proc.call
        expect(@ann.panel).not_to be_nil
        expect(@ann.panel.number).to eq(valid_panel_number)
      end
      it "警報パネルオブジェクトはデータベースには保存されていない" do
        expect { @proc.call }.to change(Panel, :count).by(1)
      end
      it "true を返す" do
        expect { @proc.call }.to be_true
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
        it "Location にエラーを設定する" do
          @panel.assign(@ann, to: "")
          expect(@ann.errors[:panel_location]).not_to be_empty
        end
      end

      describe "警報とパネルが保存されていない場合" do
        it "Location にエラーを設定する" do
          @ann = Ann.new(valid_ann_attributes)
          @panel = Panel.new(valid_panel_attributes)
          @panel.assign(@ann, to: "")
          expect(@ann.errors[:panel_location]).not_to be_empty
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
      it "false を返す"
    end
    describe "既存のパネルの合いていない場所を指定" do
      it "true を返す"
    end
    describe "既存のパネルに対して、場所指定が空白の場合" do
    end
    describe "存在しないパネルの場所"
    describe "存在しないパネルに対して、場所指定が空白の場合"
  end

  describe "#assigned?(loc)" do
    context "関連する Location オブジェクトの中で loc を location 属性に持っているものがある" do
      it "true を返す" do
        panel = Panel.create!(valid_panel_attributes)
        panel.locations << Location.create(valid_location_attributes)
        expect(panel.assigned?("a1")).to be_true
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
end
