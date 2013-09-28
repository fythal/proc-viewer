require "spec_helper"

describe ApplicationController do
  describe "routing" do
    it "routes to #new" do
      get("/logins/new").should route_to("logins#new")
    end
  end
end
