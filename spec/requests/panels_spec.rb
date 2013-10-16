# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Panels" do
  describe "GET /panels" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get panels_path
      response.status.should be(200)
    end

    it "オブジェクトが生成される" do
      expect { Panel.create!(number: "foo-${Time.now}", height: 3, width: 3) }.to change(Panel, :count).by(1)
    end

    it "json 形式のレスポンスに期待通りのパラメータが含まれている" do
      Panel.create!(number: "foo-${Time.now}", height: 3, width: 3)

      get panels_path, format: "json"
      panel = JSON.parse(response.body).first
      ["number", "height", "width"].each { |key| expect(panel).to have_key(key) }
    end
  end
end
