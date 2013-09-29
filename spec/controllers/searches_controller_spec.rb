# -*- coding: utf-8 -*-
require 'spec_helper'

describe SearchesController do

  # ログインしているように見せかける
  def mock_current_user
    session[:current_login_id] = 1
    Login.stub(:find_by_id).with(1).and_return(stub_model(Login, user: stub_model(User, "name" => "foo")))
  end

  def valid_attributes
    { :id => @search.to_param }
  end

  def valid_search_attributes
    { "search" => { "keywords" => "foobar" } }
  end

  def valid_session
    {}
  end


  describe "GET show" do
    before(:each) do
      @search = Search.create!(keywords: "foobar")
      @search_result = ["foo", "bar"]
      Ann.stub(:search).with("foobar").and_return(@search_result)

      mock_current_user
    end

    it "@search に検索条件を代入する" do
      get :show, valid_attributes, valid_session
      expect(assigns(:search)).to eq(@search)
    end

    it "Ann.search メソッドを呼出す" do
      Ann.should_receive(:search).with("foobar")
      get :show, valid_attributes, valid_session
    end

    it "@anns に検索条件にマッチした警報を代入する" do
      get :show, valid_attributes, valid_session
      expect(assigns(:anns)).to be_kind_of(Array)
      expect(assigns(:anns)).to eq(@search_result)
    end
  end

  describe "POST create" do
    context "まだログインしていないとき" do
      it "ログイン画面へリダイレクトする" do
        post :create, {}, {}
        response.should redirect_to(new_login_url)
      end
    end

    context "ログインしているとき" do
      before(:each) do
        mock_current_user
      end

      it "Search オブジェクトが作成される" do
        expect { post :create, {"search" => {"keywords" => "foobar"}}, {}}.to change(Search, :count).by(1)
      end

      it "新しく生成した Search オブジェクトを @search に代入する" do
        post :create, valid_search_attributes, valid_session
        assigns(:search).should be_a(Search)
        assigns(:search).should be_persisted
      end

      it "検索結果のページにリダイレクトする" do
        post :create, valid_search_attributes, valid_session
        response.should redirect_to(Search.last)
      end
    end
  end
end
