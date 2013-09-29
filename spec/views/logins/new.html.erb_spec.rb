# -*- coding: utf-8 -*-
require 'spec_helper'

describe "logins/new" do
  before(:each) do
    assign(:login, stub_model(Login))
    assign(:users, [stub_model(User, id: 100, name: "foo"), stub_model(User, id: 200, name: "bar")])
  end

  it "ログイン画面を描画する" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => logins_path, :method => "post" do
      assert_select "select", :name => "login[user_id]" do
        assert_select "option[value='100']"
        assert_select "option[value='200']"
      end
      assert_select "input[type='text']", :name => "login[new_user_name]"
    end
  end
end
