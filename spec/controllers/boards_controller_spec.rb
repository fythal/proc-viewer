# -*- coding: utf-8 -*-
require 'spec_helper'

describe BoardsController do
  def valid_attributes
    {code: "MyCode", name: "MyName"}
  end

  def valid_session
    {}
  end

  describe "POST create" do
    it "オブジェクトを生成する" do
      expect { post :create, {:board => valid_attributes}, valid_session }.to change(Board, :count).by(1)
    end

    it "新しいオブジェクトを @board にアサインする" do
      post :create, {:board => valid_attributes}, valid_session
      assigns(:board).should be_kind_of(Board)
      assigns(:board).should be_persisted
    end

    it "生成されたオブジェクトの詳細画面へリダイレクトする" do
      post :create, {:board => valid_attributes}, valid_session
      response.should redirect_to(assigns[:board])
    end
  end


  describe "PUT update" do
    it "リクエストされた盤の属性をアップデートする" do
      board = Board.create! valid_attributes
      Board.any_instance.should_receive(:update).with({ "code" => "MyNewCode", "name" => "MyNewName" })
      put :update, {:id => board.to_param, :board => { "code" => "MyNewCode", "name" => "MyNewName" }}, valid_session
    end

    it "リクエストされた盤を @board にアサインする" do
      board = Board.create! valid_attributes
      put :update, {:id => board.to_param, :board => valid_attributes}, valid_session
      assigns(:board).should eq(board)
    end

    it "リクエストされた盤の属性をアップデートする" do
      board = Board.create! valid_attributes
      put :update, {:id => board.to_param, :board => { :code => "foo", :name => "bar" }}, valid_session
      expect(assigns(:board).code).to eq("foo")
      expect(assigns(:board).name).to eq("bar")
    end

    it "リクエストされた盤の詳細画面へリダイレクトする" do
      board = Board.create! valid_attributes
      put :update, {:id => board.to_param, :board => valid_attributes}, valid_session
      response.should redirect_to(board)
    end
  end


  describe "DELETE destroy" do
    it "destroys the requested board" do
      board = Board.create! valid_attributes
      expect { delete :destroy, {:id => board.to_param}, valid_session }.to change(Board, :count).by(-1)
    end

    it "redirects to the boards list" do
      board = Board.create! valid_attributes
      delete :destroy, {:id => board.to_param}, valid_session
      response.should redirect_to(boards_url)
    end
  end

end
