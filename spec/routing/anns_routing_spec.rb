require "spec_helper"

describe AnnsController do
  describe "routing" do

    it "routes to #index" do
      get("/anns").should route_to("anns#index")
    end

    it "routes to #new" do
      get("/anns/new").should route_to("anns#new")
    end

    it "routes to #show" do
      get("/anns/1").should route_to("anns#show", :id => "1")
    end

    it "routes to #edit" do
      get("/anns/1/edit").should route_to("anns#edit", :id => "1")
    end

    it "routes to #create" do
      post("/anns").should route_to("anns#create")
    end

    it "routes to #update" do
      put("/anns/1").should route_to("anns#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/anns/1").should route_to("anns#destroy", :id => "1")
    end

  end
end
