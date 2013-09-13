require "spec_helper"

describe PanelsController do
  describe "routing" do

    it "routes to #index" do
      get("/panels").should route_to("panels#index")
    end

    it "routes to #new" do
      get("/panels/new").should route_to("panels#new")
    end

    it "routes to #show" do
      get("/panels/1").should route_to("panels#show", :id => "1")
    end

    it "routes to #edit" do
      get("/panels/1/edit").should route_to("panels#edit", :id => "1")
    end

    it "routes to #create" do
      post("/panels").should route_to("panels#create")
    end

    it "routes to #update" do
      put("/panels/1").should route_to("panels#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/panels/1").should route_to("panels#destroy", :id => "1")
    end

  end
end
