require 'spec_helper'

describe Matcher do
  context 'association' do
    it { should have_many(:matches) }
  end 

  # context "evaluate" do
  #   it "should return true if all matches match when eval_criteria = 'exists'" do
  #     matcher = Factory(:matcher)
  #     match1 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher.id)
  #     match2 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher.id)
  #     matcher.evaluate(Oga.parse_xml("<root><abc>123</abc><xyz>444</xyz></root>")).should == true
  #   end
  #
  #   it "should return true if all matches match when eval_criteria = 'equal_to' and value is nil" do
  #     matcher = Factory(:matcher)
  #     match1 = Factory(:match, :expression => "//abc", :eval_criteria => "equal_to", :matcher_id => matcher.id)
  #     match2 = Factory(:match, :expression => "//xyz", :eval_criteria => "equal_to", :matcher_id => matcher.id)
  #     matcher.evaluate(Oga.parse_xml("<root><abc></abc><qqq>444</qqq></root>")).should == true
  #   end
  #
  #   it "should return true if all matches match when eval_criteria = 'equal_to' and value is not nil" do
  #     matcher = Factory(:matcher)
  #     match1 = Factory(:match, :expression => "//abc", :eval_criteria => "equal_to", :value => "123", :matcher_id => matcher.id)
  #     match2 = Factory(:match, :expression => "//xyz", :eval_criteria => "equal_to", :value => "555", :matcher_id => matcher.id)
  #     matcher.evaluate(Oga.parse_xml("<root><abc>123</abc><xyz>555</xyz></root>")).should == true
  #   end
  #
  #   it "should return false if unmatched xpath found" do
  #     matcher = Factory(:matcher)
  #     match1 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher.id)
  #     match2 = Factory(:match, :expression => "//qwe", :eval_criteria => "exists", :matcher_id => matcher.id)
  #     match3 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher.id)
  #     matcher.evaluate(Oga.parse_xml("<root><abc>123</abc><xyz>444</xyz></root>")).should == false
  #   end
  # end
  #
  # context "find_response" do
  #   it "should return correct response if response exists for the corresponding content-type" do
  #     matcher = Factory(:matcher)
  #     response1 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher.id)
  #     response2 = Factory(:response, :content_type => "text/json", :matcher_id => matcher.id)
  #     matcher.find_response("text/xml").should == response1
  #   end
  #
  #   it "should return default response if content-type of incoming request is nil" do
  #     matcher = Factory(:matcher)
  #     response1 = Factory(:response, :content_type => "text/json", :matcher_id => matcher.id)
  #     response2 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher.id)
  #     matcher.find_response(nil).should == response1
  #   end
  #
  #   it "should return nil if content-type of incoming request is nil" do
  #     matcher = Factory(:matcher)
  #     matcher.find_response("text/xml").should == nil
  #   end
  # end
end