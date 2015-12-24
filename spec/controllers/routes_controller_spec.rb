require 'spec_helper'

describe RoutesController do
  include HelperMethods

  before(:each) do
    @controller.instance_eval { flash.extend(DisableFlashSweeping) }
    sign_in @user = Factory(:user)
    Factory(:users_role, :user_id => @user.id, :role_id => Factory(:role, :name => 'user').id)
    request.env["HTTP_REFERER"] = "/"
  end

  describe "GET execute_route" do
    it "should return 404 if uri does not exist" do
      get :execute_route, :uri => "abc"
      response.response_code.should == 404
    end

    it "should return 405 if http_method of request does not match with the http_method for the saved route" do
      route = Factory(:route, :uri => "abc", :http_method => "POST")
      get :execute_route, :uri => "abc", :http_method => "GET"
      response.response_code.should == 405
    end

    it "should return 400 (bad request), in case the request cannot be loaded by parser" do 
      route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "SOAP")
      inp_req = "<people>foo/people>"
      get :execute_route, :uri => "abc", :http_method => "POST", :input_request => inp_req
      document = route.parse_request(inp_req)
      response.response_code.should == 400
    end

    it "should return 409 if response is not available for the content-type as specified in the the accept header" do
      route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "SOAP")
      matcher1 = Factory(:matcher, :route_id => route.id)
      matcher2 = Factory(:matcher, :route_id => route.id)
      match1 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher1.id)
      match2 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher1.id)
      response1 = Factory(:response, :content_type => "text/json", :matcher_id => matcher1.id) 
      response2 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher1.id)

      inp_req = "<people>foo/people>"
      get :execute_route, :uri => "abc", :http_method => "POST", :input_request => inp_req
    end

    it "should return the response with the content-type as specified in the accept header" do
      route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "SOAP")
      matcher1 = Factory(:matcher, :route_id => route.id)
      matcher2 = Factory(:matcher, :route_id => route.id)
      match1 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher1.id)
      match2 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher1.id)
      response1 = Factory(:response, :content_type => "text/json", :matcher_id => matcher1.id) 
      response2 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher1.id)

      inp_req = "<root><abc>123</abc><xyz>444</xyz></root>"
      get :execute_route, :uri => "abc", :http_method => "POST", :input_request => inp_req
      response.response_code.should == 200
    end
  end

end
