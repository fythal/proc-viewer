# -*- coding: utf-8 -*-

require 'spec_helper'

# アプリケーションコントローラのスペックについてであるが、代表として
# AnnsController とする。すべてのコントローラは ApplicationController
# を継承している。

describe AnnsController do
  describe "GET index" do
    context "session[:login] が設定されていないとき" do
      before(:each) do
        session[:login] = nil
      end
      it "ログインのページにリダイレクトする" do
        get :index, {}, {}
        response.should redirect_to(new_login_url)
      end
    end
    context "session[:login] が設定されているとき" do
      before(:each) do
        session[:login] = stub_model(Login, user_id: 1)
      end

      it "警報一覧のページが表示される" do
        get :index, {}, {}
        expect(response).to render_template("index")
      end
    end
  end
end
