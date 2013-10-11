require 'spec_helper'

describe "boards/show" do
  before(:each) do
    @board = assign(:board, stub_model(Board,
      :code => "MyCode", :name => "Name",
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Code/)
    rendered.should match(/Name/)
  end
end
