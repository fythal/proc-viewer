# -*- coding: utf-8 -*-
require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the PanelsHelper. For example:
#
# describe PanelsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe PanelsHelper do
  describe "num_to_alpha(index)" do
    describe "index が整数の場合" do
      it "整数 1-8 をアルファベット A-H に変換する" do
        expect(num_to_alpha(3)).to eq("C")
      end

      it "整数 1-8 以外ならば空白を返す" do
        expect(num_to_alpha(10)).to eq("")
      end
    end

    describe "index が文字列の場合" do
      it "数字 '1'-'8' をアルファベット A-H に変換する" do
        expect(num_to_alpha("3")).to eq("C")
      end

      it "数字に変換できなければ空白を返す" do
        expect(num_to_alpha("x")).to eq("")
      end
    end
  end
end
