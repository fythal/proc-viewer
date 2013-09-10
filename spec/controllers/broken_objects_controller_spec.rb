# -*- coding: utf-8 -*-
require 'spec_helper'

describe BrokenObjectsController do

  def valid_session
    {}
  end

  it "Ann クラスに broken を送る" do
    Ann.should_receive(:broken)
    get :index, {}, valid_session
  end

  it "@broken_anns に Ann.broken で返される値をセットする" do
    ann = Object.new
    Ann.stub(:broken).and_return([ann])

    get :index, {}, valid_session
    expect(assigns(:broken_anns)).to eq([ann])
  end
end
