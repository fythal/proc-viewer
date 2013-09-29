# -*- coding: utf-8 -*-
require 'spec_helper'

describe SearchesController do
  describe "POST create" do
    it "ログイン画面へリダイレクトする" do
      post :create, {}, {}
      response.should redirect_to(new_login_url)
    end
  end
end
