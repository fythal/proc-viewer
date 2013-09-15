# -*- coding: utf-8 -*-
require 'spec_helper'

describe AnnsController do

  # This should return the minimal set of attributes required to create a valid
  # Ann. As you add validations to Ann, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "name" => "HPCS 電気故障" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AnnsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    before(:each) do
      @ann = Ann.create! valid_attributes
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
      ann = Ann.create! valid_attributes
      get :show, {:id => ann.to_param}, valid_session
      assigns(:ann).should eq(ann)
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
      ann = Ann.create! valid_attributes
      get :edit, {:id => ann.to_param}, valid_session
      assigns(:ann).should eq(ann)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Ann" do
        expect {
          post :create, {:ann => valid_attributes}, valid_session
        }.to change(Ann, :count).by(1)
      end

      it "assigns a newly created ann as @ann" do
        post :create, {:ann => valid_attributes}, valid_session
        assigns(:ann).should be_a(Ann)
        assigns(:ann).should be_persisted
      end

      it "割り当てられたパネルを @panel に代入する" do
        attributes = valid_attributes.merge(:panel_number => "n1")
        post :create, {:ann => attributes}, valid_session
        assigns(:panel).should be_a(Panel)
        assigns(:panel).should be_persisted
      end

      it "@panel はフォームに入力した同じパネル番号を持つ" do
        attributes = valid_attributes.merge(:panel_number => "n1")
        post :create, {:ann => attributes}, valid_session
        expect(assigns(:panel).number).to eq("n1")
      end

      it "警報は @panel に割り当てられている" do
        attributes = valid_attributes.merge(:panel_number => "n1")
        post :create, {:ann => attributes}, valid_session
        expect(assigns(:panel).anns.last).to eq(assigns(:ann))
      end

      it "警報に手順書オブジェクトが関連付けられている" do
        def file_attachment
          test_document = Rails.root.join('features', 'procs', 'ann-n1-c6.pdf')
          Rack::Test::UploadedFile.new(test_document, "text/pdf")
        end

        attributes = valid_attributes.merge(procedure: file_attachment)
        post :create, {:ann => attributes}, valid_session

        expect(assigns(:ann).procedure).not_to be_nil
      end

      it "警報にアップロードした手順書のファイルが関連付けられている" do
        def file_attachment
          test_document = Rails.root.join('features', 'procs', 'ann-n1-c6.pdf')
          Rack::Test::UploadedFile.new(test_document, "text/pdf")
        end

        attributes = valid_attributes.merge(procedure: file_attachment)
        post :create, {:ann => attributes}, valid_session

        procedure_file_size = File.size(Rails.root.join('features', 'procs', 'ann-n1-c6.pdf'))
        assigned_procedure_file_size = File.size(assigns(:ann).procedure.file_path)
        expect(assigned_procedure_file_size).to eq(procedure_file_size)
      end

      it "redirects to the created ann" do
        post :create, {:ann => valid_attributes}, valid_session
        response.should redirect_to(Ann.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved ann as @ann" do
        # Trigger the behavior that occurs when invalid params are submitted
        Ann.any_instance.stub(:save).and_return(false)
        post :create, {:ann => { "name" => "invalid value" }}, valid_session
        assigns(:ann).should be_a_new(Ann)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Ann.any_instance.stub(:save).and_return(false)
        post :create, {:ann => { "name" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested ann" do
        ann = Ann.create! valid_attributes
        # Assuming there are no other anns in the database, this
        # specifies that the Ann created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        valid_name = valid_attributes["name"]
        Ann.any_instance.should_receive(:update).with({ "name" => valid_name })
        put :update, {:id => ann.to_param, :ann => { "name" => valid_name }}, valid_session
      end

      it "assigns the requested ann as @ann" do
        ann = Ann.create! valid_attributes
        put :update, {:id => ann.to_param, :ann => valid_attributes}, valid_session
        assigns(:ann).should eq(ann)
      end

      it "redirects to the ann" do
        ann = Ann.create! valid_attributes
        put :update, {:id => ann.to_param, :ann => valid_attributes}, valid_session
        response.should redirect_to(ann)
      end

      it "@panel に Panel オブジェクトを代入する" do
        ann = Ann.create! valid_attributes
        attributes = valid_attributes.merge(:panel_number => "n1")
        put :update, {:id => ann.to_param, :ann => attributes}, valid_session
        expect(assigns(:panel)).to be_kind_of(Panel)
      end

      it "@panel はフォームに入力した同じパネル番号を持つ" do
        ann = Ann.create! valid_attributes
        attributes = valid_attributes.merge(:panel_number => "n1")
        put :update, {:id => ann.to_param, :ann => attributes}, valid_session
        expect(assigns(:panel).number).to eq("n1")
      end

      it "警報は @panel に割り当てられている" do
        ann = Ann.create! valid_attributes
        attributes = valid_attributes.merge(:panel_number => "n1")
        put :update, {:id => ann.to_param, :ann => attributes}, valid_session
        expect(assigns(:panel).anns).to include(ann)
      end

      it "警報を窓に割り当てる" do
        ann = Ann.create! valid_attributes
        attributes = valid_attributes.merge(:window => "a1")
        put :update, {:id => ann.to_param, :ann => attributes}, valid_session
        expect(assigns(:ann).window).to eq("a1")
      end
    end

    describe "with invalid params" do
      it "assigns the ann as @ann" do
        ann = Ann.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Ann.any_instance.stub(:save).and_return(false)
        put :update, {:id => ann.to_param, :ann => { "name" => "invalid value" }}, valid_session
        assigns(:ann).should eq(ann)
      end

      it "re-renders the 'edit' template" do
        ann = Ann.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Ann.any_instance.stub(:save).and_return(false)
        put :update, {:id => ann.to_param, :ann => { "name" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested ann" do
      ann = Ann.create! valid_attributes
      expect {
        delete :destroy, {:id => ann.to_param}, valid_session
      }.to change(Ann, :count).by(-1)
    end

    it "redirects to the anns list" do
      ann = Ann.create! valid_attributes
      delete :destroy, {:id => ann.to_param}, valid_session
      response.should redirect_to(anns_url)
    end
  end

end
