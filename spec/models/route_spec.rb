require 'spec_helper'

describe Route do
  context 'association' do
    it { should have_many(:matchers) }
  end 

  context "parse_request" do
    it "should parse the incoming SOAP request" do
      route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "SOAP")
      document = route.parse_request("<people>foo</people>")
      document.xpath("/people").text.should eq('foo')
    end

    it "should raise exception if incoming SOAP request is invalid" do
      # request with content-type xml cannot be loaded by Oga
      route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "SOAP")
      parsed_request = route.parse_request("<people>foo/people>")
      parsed_request[:error].should_not == nil
    end

    it "should parse the incoming JSON request" do
      route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "JSON")
      document = route.parse_request({ :id => 123, :v1 => 1 })
      document.xpath("/id").text.should eq("123")
    end

    it "should raise exception if incoming JSON request is invalid" do
      # request with content-type json cannot be loaded by Gyuko
      route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "JSON")
      parsed_request = route.parse_request("{ id: 123, v1 '2' }")
      parsed_request[:error].should_not == nil
    end
  end

    context "find_matching_reply" do
    it "should return matching reply corresponding to the first matcher" do
      route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "SOAP")
      matcher1 = Factory(:matcher, :route_id => route.id)
      matcher2 = Factory(:matcher, :route_id => route.id)
      match1 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher1.id)
      match2 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher1.id)
      response1 = Factory(:response, :content_type => "text/json", :matcher_id => matcher1.id) 
      response2 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher1.id)

      match3 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher2.id)
      match4 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher2.id)
      response3 = Factory(:response, :content_type => "text/json", :matcher_id => matcher2.id) 
      response4 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher2.id)

      route.find_matching_reply(Oga.parse_xml("<root><abc>123</abc><xyz>444</xyz></root>"), "text/xml").should == response2

      route.find_matching_reply(Oga.parse_xml("<root><abc>123</abc><xyz>444</xyz></root>"), "text/xml").should_not == response4
    end
  end
end