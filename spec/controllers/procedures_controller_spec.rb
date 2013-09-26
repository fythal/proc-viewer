# -*- coding: utf-8 -*-

require 'spec_helper'

describe ProceduresController do

  let(:valid_attributes) { { "path" => "MyString" } }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all procedures as @procedures" do
      procedure = Procedure.create! valid_attributes
      get :index, {}, valid_session
      assigns(:procedures).should eq([procedure])
    end
  end

  describe "GET show" do
    it "assigns the requested procedure as @procedure" do
      procedure = Procedure.create! valid_attributes
      get :show, {:id => procedure.to_param}, valid_session
      assigns(:procedure).should eq(procedure)
    end
  end

  describe "GET new" do
    it "assigns a new procedure as @procedure" do
      get :new, {}, valid_session
      assigns(:procedure).should be_a_new(Procedure)
    end

    it "パスに警報が入っていたときは @ann をアサインする" do
      Ann.stub(:find).and_return(stub_model(Ann, :name => "MyAnnName"))
      get :new, {ann_id: "1"}, valid_session
      expect(assigns(:ann)).to be_kind_of(Ann)
    end
  end

  describe "GET edit" do
    it "assigns the requested procedure as @procedure" do
      procedure = Procedure.create! valid_attributes
      get :edit, {:id => procedure.to_param}, valid_session
      assigns(:procedure).should eq(procedure)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      describe "警報のサブリソースとして手順書を新規作成" do
        before(:each) do
          @ann = stub_model(Ann, :id => 27)
        end
        it "新しい手順書を作成する" do
          expect { post :create, {:procedure => valid_attributes, :ann_id => @ann.id}, valid_session}.to change(Procedure, :count).by(1)
        end

        it "新しく作成した手順書を @procedure に代入する" do
          post :create, {:procedure => valid_attributes, :ann_id => @ann.id}, valid_session
          assigns(:procedure).should be_a(Procedure)
          assigns(:procedure).should be_persisted
        end

        it "作成した手順書の詳細ページへリダイレクトする" do
          post :create, {:procedure => valid_attributes, :ann_id => @ann.id}, valid_session
          response.should redirect_to(ann_procedure_path(@ann, assigns(:procedure)))
        end
      end

      describe "手順書を新規作成 (警報のサブリソースではない)" do
        it "creates a new Procedure" do
          expect { post :create, {:procedure => valid_attributes}, valid_session }.to change(Procedure, :count).by(1)
        end

        it "assigns a newly created procedure as @procedure" do
          post :create, {:procedure => valid_attributes}, valid_session
          assigns(:procedure).should be_a(Procedure)
          assigns(:procedure).should be_persisted
        end

        it "redirects to the created procedure" do
          post :create, {:procedure => valid_attributes}, valid_session
          response.should redirect_to(Procedure.last)
        end
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved procedure as @procedure" do
        # Trigger the behavior that occurs when invalid params are submitted
        Procedure.any_instance.stub(:save).and_return(false)
        post :create, {:procedure => { "path" => "invalid value" }}, valid_session
        assigns(:procedure).should be_a_new(Procedure)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Procedure.any_instance.stub(:save).and_return(false)
        post :create, {:procedure => { "path" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested procedure" do
        procedure = Procedure.create! valid_attributes
        # Assuming there are no other procedures in the database, this
        # specifies that the Procedure created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Procedure.any_instance.should_receive(:update).with({ "path" => "MyString" })
        put :update, {:id => procedure.to_param, :procedure => { "path" => "MyString" }}, valid_session
      end

      it "assigns the requested procedure as @procedure" do
        procedure = Procedure.create! valid_attributes
        put :update, {:id => procedure.to_param, :procedure => valid_attributes}, valid_session
        assigns(:procedure).should eq(procedure)
      end

      it "redirects to the procedure" do
        procedure = Procedure.create! valid_attributes
        put :update, {:id => procedure.to_param, :procedure => valid_attributes}, valid_session
        response.should redirect_to(procedure)
      end
    end

    describe "with invalid params" do
      it "assigns the procedure as @procedure" do
        procedure = Procedure.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Procedure.any_instance.stub(:save).and_return(false)
        put :update, {:id => procedure.to_param, :procedure => { "path" => "invalid value" }}, valid_session
        assigns(:procedure).should eq(procedure)
      end

      it "re-renders the 'edit' template" do
        procedure = Procedure.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Procedure.any_instance.stub(:save).and_return(false)
        put :update, {:id => procedure.to_param, :procedure => { "path" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested procedure" do
      procedure = Procedure.create! valid_attributes
      expect {
        delete :destroy, {:id => procedure.to_param}, valid_session
      }.to change(Procedure, :count).by(-1)
    end

    it "redirects to the procedures list" do
      procedure = Procedure.create! valid_attributes
      delete :destroy, {:id => procedure.to_param}, valid_session
      response.should redirect_to(procedures_url)
    end
  end

end
