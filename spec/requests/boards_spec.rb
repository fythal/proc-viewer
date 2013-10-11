# -*- coding: utf-8 -*-
require 'spec_helper'

describe "Boards" do
  describe "GET /boards.json" do
    it "パラメータが含まれている" do
      Board.create!(name: "foo", code: "bar")

      get boards_path, format: "json"
      board = JSON.parse(response.body).first
      ["name", "code"].each do |key|
        expect(board).to have_key(key)
      end
    end
  end
end
