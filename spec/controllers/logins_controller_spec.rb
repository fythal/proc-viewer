# -*- coding: utf-8 -*-
require 'spec_helper'

describe LoginsController do
  describe "GET new" do
    it "@login がアサインされている" do
      get :new, {}, {}
      expect(assigns(:login)).not_to be_nil
    end
    it "@users は配列" do
      get :new, {}, {}
      expect(assigns(:users)).to be_kind_of(Array)
    end
    it "ログインページを描画" do
      get :new, {}, {}
      expect(response).to render_template("new")
    end
  end

  describe "POST create" do
    def attributes
      {"login" => {"user_id" => "1", "new_user_name" => ""}}
    end
    before(:each) do
      User.stub(:find).with("1").and_return(stub_model(User, id: 1, name: "foo"))
      Ann.stub(:search).and_return([stub_model(Ann, name: "foo-bar")])
    end
    it "Login オブジェクトを生成する" do
      expect { post :create, attributes, {} }.to change(Login, :count).by(1)
    end
    it "session に現在のログインの id を格納する" do
      post :create, attributes, {}
      expect(session[:current_login_id]).not_to be_nil
    end
    it "flash にウェルカムメッセージを設定する" do
      post :create, attributes, {}
      expect(flash[:notice]).to match(/ようこそ、.* さん/)
    end
    it "検索の途中であれば検索結果の画面にリダイレクトする" do
      session[:search_keywords] = "foo"
      post :create, attributes, {}
      response.should redirect_to(assigns[:search])
    end
  end
end
