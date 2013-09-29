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
end
