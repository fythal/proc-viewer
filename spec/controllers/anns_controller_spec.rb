# -*- coding: utf-8 -*-
require 'spec_helper'

describe AnnsController do

  # This should return the minimal set of attributes required to create a valid
  # Ann. As you add validations to Ann, be sure to
  # update the return value of this method accordingly.
  def valid_ann_attributes
    { "name" => "HPCS 電気故障" }
  end

  def valid_panel_attributes
    { panel_number:"n1", panel_location: "a1" }
  end

  def valid_ann_and_panel_attributes
    valid_ann_attributes.merge(valid_panel_attributes)
  end

  def attributes_for_procedure
    test_document = Rails.root.join('features', 'procs', 'ann-n1-c6.pdf')
    { procedure: Rack::Test::UploadedFile.new(test_document, "text/pdf") }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AnnsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    before(:each) do
      @ann = Ann.create! valid_ann_attributes
    end

    context "パラメータなし" do
      it "assigns all anns as @anns" do
        get :index, {}, valid_session
        expect(assigns(:anns)).to match_array([@ann])
      end
    end

    context "keyword にマッチする警報あり" do
      it "マッチするすべての警報をアサインする" do
        get :index, {:keyword => "HPCS"}, valid_session
        expect(assigns(:anns)).to match_array([@ann])
      end
    end

    context "keyword にマッチする警報なし" do
      it "空の配列をアサインする" do
        get :index, {:keyword => "火山爆発"}, valid_session
        expect(assigns(:anns)).to match_array([])
      end
    end
  end

  describe "GET show" do
    it "assigns the requested ann as @ann" do
      ann = Ann.create! valid_ann_attributes
      get :show, {:id => ann.to_param}, valid_session
      assigns(:ann).should eq(ann)
    end

    context "要求された警報に対し、警報パネルが関連付けられている" do
      it "警報パネルを @panel に割り当てる" do
        ann = Ann.create! valid_ann_attributes
        panel = Panel.create! number: valid_panel_attributes[:panel_number]
        Panel.assign(ann, panel: panel.number, to: "a1")

        get :show, {:id => ann.to_param}, valid_session
        assigns(:panel).should eq(panel)
      end
    end
  end

  describe "GET new" do
    it "assigns a new ann as @ann" do
      get :new, {}, valid_session
      assigns(:ann).should be_a_new(Ann)
    end
  end

  describe "GET edit" do
    it "assigns the requested ann as @ann" do
      ann = Ann.create! valid_ann_attributes
      get :edit, {:id => ann.to_param}, valid_session
      assigns(:ann).should eq(ann)
    end
  end

  describe "POST create" do
    describe "正常な警報のパラメータを与えた場合" do
      it "新しい Ann オブジェクトを作成する" do
        expect {
          post :create, {:ann => valid_ann_attributes}, valid_session
        }.to change(Ann, :count).by(1)
      end

      it "assigns a newly created ann as @ann" do
        post :create, {:ann => valid_ann_attributes}, valid_session
        assigns(:ann).should be_a(Ann)
        assigns(:ann).should be_persisted
      end

      it "redirects to the created ann" do
        post :create, {:ann => valid_ann_attributes}, valid_session
        response.should redirect_to(Ann.last)
      end
    end

    describe "正常な警報、パネル、場所のパラメータを与えた場合" do
      it "新しい Ann オブジェクトを作成する" do
        expect {
          post :create, {:ann => valid_ann_and_panel_attributes}, valid_session
        }.to change(Ann, :count).by(1)
      end

      it "新しい Location オブジェクトを作成する" do
        expect {
          post :create, {:ann => valid_ann_and_panel_attributes}, valid_session
        }.to change(Location, :count).by(1)
      end

      it "新しい Panel オブジェクトを作成する" do
        expect {
          post :create, {:ann => valid_ann_and_panel_attributes}, valid_session
        }.to change(Panel, :count).by(1)
      end

      it "新しい警報を @ann に代入する" do
        post :create, {:ann => valid_ann_and_panel_attributes}, valid_session
        assigns(:ann).should be_a(Ann)
        assigns(:ann).should be_persisted
      end

      it "割り当てられたパネルを @panel に代入する" do
        post :create, {:ann => valid_ann_and_panel_attributes}, valid_session
        assigns(:panel).should be_a(Panel)
        assigns(:panel).should be_persisted
      end

      it "@ann と @panel は #location を仲介して関連付けられている" do
        post :create, {:ann => valid_ann_and_panel_attributes}, valid_session
        expect(assigns(:ann).location.panel).to eq(assigns(:panel))
      end

      it "@ann と @panel は直接関連付けられていない" do
        post :create, {:ann => valid_ann_and_panel_attributes}, valid_session
        expect(assigns(:ann).panel).to be_nil
      end

      it "@panel はフォームに入力した同じパネル番号を持つ" do
        post :create, {:ann => valid_ann_and_panel_attributes}, valid_session
        expect(assigns(:panel).number).to eq(valid_ann_and_panel_attributes[:panel_number])
      end

      it "@ann の場所はフォームに入力した同じ場所である" do
        post :create, {:ann => valid_ann_and_panel_attributes}, valid_session
        expect(assigns(:ann).location.location).to eq(valid_ann_and_panel_attributes[:panel_location])
      end

      it "作成された警報についての詳細ページにリダイレクトされる" do
        post :create, {:ann => valid_ann_and_panel_attributes}, valid_session
        response.should redirect_to(Ann.last)
      end
    end

    describe "手順書のアップロードをした場合" do
      after(:each) do
        File.unlink(assigns(:ann).procedure.system_path)
      end
      it "新しい手順書オブジェクトを作成する" do
        attributes = valid_ann_attributes.merge(attributes_for_procedure)
        expect { post :create, {:ann => attributes}, valid_session }.to change(Procedure, :count).by(1)
      end

      it "警報に手順書オブジェクトが関連付けられている" do
        attributes = valid_ann_attributes.merge(attributes_for_procedure)
        post :create, {:ann => attributes}, valid_session
        expect(assigns(:ann).procedure).not_to be_nil
      end
    end

    describe "警報の保存に失敗した場合 (不正な値を設定する等)" do
      before(:each) do
        Ann.any_instance.stub(:save).and_return(false)
        post :create, {:ann => { "name" => "invalid value" }}, valid_session
      end

      it "assigns a newly created but unsaved ann as @ann" do
        assigns(:ann).should be_a_new(Ann)
      end

      it "re-renders the 'new' template" do
        response.should render_template("new")
      end

      # it "警報をパネルを指定しないで窓に割り当てる" do
      #   ann = Ann.create! valid_ann_attributes
      #   attributes = valid_ann_attributes.merge(:panel_location => "a1")
      #   expect { put :create, {:id => ann.to_param, :ann => attributes}, valid_session }.to raise_error(RuntimeError)
      # end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested ann" do
        ann = Ann.create! valid_ann_attributes
        # Assuming there are no other anns in the database, this
        # specifies that the Ann created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        valid_name = valid_ann_attributes["name"]
        Ann.any_instance.should_receive(:update).with({ "name" => valid_name })
        put :update, {:id => ann.to_param, :ann => { "name" => valid_name }}, valid_session
      end

      it "assigns the requested ann as @ann" do
        ann = Ann.create! valid_ann_attributes
        put :update, {:id => ann.to_param, :ann => valid_ann_attributes}, valid_session
        assigns(:ann).should eq(ann)
      end

      describe "@panel の代入" do
        it "警報がパネルに割り当てられていなければ、@panel に nil を代入する" do
          ann = Ann.create! valid_ann_attributes
          ann.stub(:panel).and_return(nil)
          put :update, {:id => ann.to_param, :ann => valid_ann_attributes}, valid_session
          expect(assigns(:panel)).to be_nil
        end

        it "警報がパネルに割り当てられていれば、@panel にパネルをセットする" do
          ann = Ann.create! valid_ann_attributes
          panel = Panel.create! number: valid_ann_and_panel_attributes[:panel_number]
          put :update, {:id => ann.to_param, :ann => valid_ann_and_panel_attributes}, valid_session
          expect(assigns(:panel)).to eq(panel)
        end
      end

      it "redirects to the ann" do
        ann = Ann.create! valid_ann_attributes
        put :update, {:id => ann.to_param, :ann => valid_ann_attributes}, valid_session
        response.should redirect_to(ann)
      end

      describe "パラメータに警報パネルとその場所を与える" do
        it "@panel に警報パネルのパラメータが設定されている" do
          ann = Ann.create! valid_ann_attributes
          put :update, {:id => ann.to_param, :ann => valid_ann_and_panel_attributes}, valid_session
          expect(assigns(:panel).number).to eq(valid_panel_attributes[:panel_number])
        end

        it "@panel.location.location に警報パネルの場所のパラメータが設定されている" do
          ann = Ann.create! valid_ann_attributes
          put :update, {:id => ann.to_param, :ann => valid_ann_and_panel_attributes}, valid_session
          expect(assigns(:panel).locations.map(&:location)).to include(valid_panel_attributes[:panel_location])
        end
      end
    end

    describe "with invalid params" do
      it "assigns the ann as @ann" do
        ann = Ann.create! valid_ann_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Ann.any_instance.stub(:save).and_return(false)
        put :update, {:id => ann.to_param, :ann => { "name" => "invalid value" }}, valid_session
        assigns(:ann).should eq(ann)
      end

      it "re-renders the 'edit' template" do
        ann = Ann.create! valid_ann_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Ann.any_instance.stub(:save).and_return(false)
        put :update, {:id => ann.to_param, :ann => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested ann" do
      ann = Ann.create! valid_ann_attributes
      expect {
        delete :destroy, {:id => ann.to_param}, valid_session
      }.to change(Ann, :count).by(-1)
    end

    it "redirects to the anns list" do
      ann = Ann.create! valid_ann_attributes
      delete :destroy, {:id => ann.to_param}, valid_session
      response.should redirect_to(anns_url)
    end
  end

end
