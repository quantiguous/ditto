require "spec_helper"

describe InputRequestsController do
  describe "routing" do

    it "routes to #index" do
      get("/input_requests").should route_to("input_requests#index")
    end

    it "routes to #new" do
      get("/input_requests/new").should route_to("input_requests#new")
    end

    it "routes to #show" do
      get("/input_requests/1").should route_to("input_requests#show", :id => "1")
    end

    it "routes to #edit" do
      get("/input_requests/1/edit").should route_to("input_requests#edit", :id => "1")
    end

    it "routes to #create" do
      post("/input_requests").should route_to("input_requests#create")
    end

    it "routes to #update" do
      put("/input_requests/1").should route_to("input_requests#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/input_requests/1").should route_to("input_requests#destroy", :id => "1")
    end

  end
end
