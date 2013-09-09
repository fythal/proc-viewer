# -*- coding: utf-8 -*-
require 'spec_helper'

describe "anns/show" do
  context "警報はパネルと窓にアサインされている" do
    before(:each) do
      @ann = assign(:ann, stub_model(Ann, :name => "Name", :pdf => "Pdf",
                                     :panel => "n1", :window => "a1"))
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/Name/)
      rendered.should match(/Pdf/)
      rendered.should match(/<p\b.*\bid=[""']ann_panel[""''].*パネル番号:.*n1/)
      rendered.should match(/<p\b.*\bid=[""']ann_window[""''].*窓番号:.*a1/)
    end
  end

  context "警報にはパネルと窓がアサインされていない" do
    before(:each) do
      @ann = assign(:ann, stub_model(Ann, :name => "Name", :pdf => "Pdf"))
    end

    it "renders attributes in <p>" do
      render
      # Run the generator again with the --webrat flag if you want to use webrat matchers
      rendered.should match(/Name/)
      rendered.should match(/Pdf/)
      rendered.should match(/<p\b.*\bid=[""']ann_panel[""''].*パネル番号:.*\(未設定\)/)
      rendered.should match(/<p\b.*\bid=[""']ann_window[""''].*窓番号:.*\(未設定\)/)
    end
  end
end
