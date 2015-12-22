require "spec_helper"

describe ExpectedResponsesController do
  describe "routing" do

    it "routes to #index" do
      get("/expected_responses").should route_to("expected_responses#index")
    end

    it "routes to #new" do
      get("/expected_responses/new").should route_to("expected_responses#new")
    end

    it "routes to #show" do
      get("/expected_responses/1").should route_to("expected_responses#show", :id => "1")
    end

    it "routes to #edit" do
      get("/expected_responses/1/edit").should route_to("expected_responses#edit", :id => "1")
    end

    it "routes to #create" do
      post("/expected_responses").should route_to("expected_responses#create")
    end

    it "routes to #update" do
      put("/expected_responses/1").should route_to("expected_responses#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/expected_responses/1").should route_to("expected_responses#destroy", :id => "1")
    end

  end
end
