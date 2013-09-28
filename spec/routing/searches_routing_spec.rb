require "spec_helper"

describe SearchesController do
  describe "routing" do

    it "routes to #index" do
      get("/users/1/searches").should route_to("searches#index", :user_id => "1")
    end

    it "routes to #new" do
      get("/users/1/searches/new").should route_to("searches#new", :user_id => "1")
    end

    it "routes to #show" do
      get("/users/1/searches/2").should route_to("searches#show", :user_id => "1", :id => "2")
    end

    it "routes to #edit" do
      get("/users/1/searchesg/edit").should route_to("searches#edit", :user_id => "1")
    end

    it "routes to #create" do
      post("/users/1/searches").should route_to("searches#create", :user_id => "1")
    end

    it "routes to #update" do
      put("/users/1/searches/2").should route_to("searches#update", :user_id => "1", :id => "2")
    end

    it "routes to #destroy" do
      delete("/users/1/searches/2").should route_to("searches#destroy", :user_id => "1", :id => "2")
    end

  end
end
