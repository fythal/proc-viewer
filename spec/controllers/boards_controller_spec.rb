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

end
