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
      { "user_id" => "1", "search" => { "keywords" => "foo" } }
    end
    before(:each) do
      User.stub(:find).with("1").and_return(stub_model(Ann, id: 1, name: "foo"))
      Ann.stub(:search).and_return([stub_model(Ann, name: "foo-bar")])
    end
    it "Login オブジェクトを生成する" do
      expect { post :create, attributes, {} }.to change(Login, :count).by(1)
    end
    it "session に Login オブジェクトを格納する" do
      post :create, attributes, {}
      expect(session[:login]).to be_kind_of(Login)
    end
    it "検索の途中であれば検索結果の画面にリダイレクトする" do
      response.should redirect_to(search_url(1))
    end
  end
end
