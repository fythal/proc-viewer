# -*- coding: utf-8 -*-
require 'spec_helper'

describe Ann do
  describe 'initialize' do
    context 'name: のみが指定されたとき' do
      before(:each) do
        @ann = Ann.new(name:"HPCS 電気故障")
      end

      it "名称を返す" do
        expect(@ann.name).to eq("HPCS 電気故障")
      end
    end
  end

  describe 'ann.proc_path' do
    context 'panel と window が設定されている' do
      it "pdf ファイルへのリンクが返される" do
        ann = Ann.create!({:panel => "n1", :window => "c6"})
        expect(ann.proc_path).to eq("/assets/procs/ann-n1-c6.pdf")
      end
    end

    context 'window が設定されていない' do
      it "nil が返される" do
        ann = Ann.create!({:panel => "n1"})
        expect(ann.proc_path).to be_nil
      end
    end

    context 'panel が設定されていない' do
      it "nil が返される" do
        ann = Ann.create!({:window => "c6"})
        expect(ann.proc_path).to be_nil
      end
    end
  end

  context '設定した窓のところにすでに他の警報が割り当てられている' do
    before(:each) do
      @ann   = Ann.create!(:panel => "n1")
      @other = Ann.create!(:panel => "n1", :window => "a1")

      @ann.window = "a1"
    end

    describe '#valid?' do
      it 'エラーを発生させる' do
        @ann.valid?
        @ann.should have(1).error_on(:window)
      end

      it 'メッセージを設定する' do
        @ann.valid?
        expect(@ann.errors[:window]).to eq([I18n.t(:ann_already_assigned_to_other_ann)])
      end
    end
  end


  context '警報にパネル番号が設定されているが、窓番号は設定されていない' do
    before(:each) do
      @ann = Ann.create(panel: "n1")
    end

    context '手順書が割り当てられていない' do
      before(:each) do
        expect(@ann.procedures).to be_empty
      end

      describe '窓番号を設定して保存する' do
        before(:each) do
          @ann.window = "a1"
          @ann.save
        end

        it "その警報用に手順書オブジェクトは生成される" do
          expect(@ann.procedures).not_to be_empty
        end

        it "手順書のパスはパネル番号と窓番号から自動的に設定される" do
          expect(@ann.proc_path).to eq("/assets/procs/ann-n1-a1.pdf")
        end
      end
    end

    context '手順書が割り当てられている' do
      before(:each) do
        @proc = Procedure.create(ann: @ann, path: "/assets/procs/foo-bar.pdf")
        expect(@ann.procedures.size).to eq(1)
      end

      describe '窓番号を設定して保存する' do
        before(:each) do
          @ann.window = "a1"
          @ann.save
        end

        it "手順書オブジェクトが生成されることはない" do
          expect(@ann.procedures).to eq([@proc])
        end

        it "手順書のパスは変わらない" do
          expect(@ann.proc_path).to eq("/assets/procs/foo-bar.pdf")
        end
      end
    end
  end

end
