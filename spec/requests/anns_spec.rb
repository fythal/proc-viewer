# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Anns" do
  describe "新しい Ann の作成" do
    it "新しい Ann を作成して、それの詳細ページへリダイレクトする" do
      get "/anns/new"
      expect(response).to render_template(:new)

      post "/anns", :ann => { :name => "My Ann" }

      expect(response).to redirect_to(assigns(:ann))
      follow_redirect!

      expect(response).to render_template(:show)
      expect(response.body).to include("Ann was successfully created.")
    end
  end

  describe "JSON 形式でデータをゲット" do
    it "JSON 形式でレスポンス OK" do
      post anns_url, ann: { name: "My Ann" }, format: "json"
      expect(response.status).to eq(201)
    end
  end

  describe "アップデートをする" do
    it "属性値を変更する" do
      post anns_path, :ann => { :name => "My Ann" }, format: "json"
      get anns_path, format: "json"
      ann = JSON.parse(response.body).first
      put ann["url"], :ann => { :name => "Foo" }, format: "json"
      get anns_path, format: "json"
      ann = JSON.parse(response.body).first
      expect(ann["name"]).to eq("Foo")
    end
  end

  describe "GET /anns.json" do
    it "必要なパラメータが含まれている" do
      Ann.create!(name: "foo")

      get anns_path, format: "json"
      ann = JSON.parse(response.body).first
      ["name", "id"].each { |key| expect(ann).to have_key(key) }
    end
  end

end
