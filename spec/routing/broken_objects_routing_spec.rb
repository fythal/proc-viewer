require "spec_helper"

describe BrokenObjectsController do
  describe "routing" do

    it "routes to #index" do
      get("/broken_objects").should route_to("broken_objects#index")
    end
  end
end
