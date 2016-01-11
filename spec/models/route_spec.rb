require 'spec_helper'

describe Route do
  context 'association' do
    it { should have_many(:matchers) }
  end 

#   context "parse_request" do
#     it "should parse the incoming SOAP request" do
#       route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "SOAP")
#       document = route.parse_request("<people>foo</people>")
#       document.xpath("/people").text.should eq('foo')
#     end
#
#     it "should raise exception if incoming SOAP request is invalid" do
#       # request with content-type xml cannot be loaded by Oga
#       route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "SOAP")
#       parsed_request = route.parse_request("<people>foo/people>")
#       parsed_request[:error].should_not == nil
#     end
#
#     it "should parse the incoming JSON request" do
#       route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "JSON")
#       document = route.parse_request({ :id => 123, :v1 => 1 })
#       document.xpath("/id").text.should eq("123")
#     end
#
#     it "should raise exception if incoming JSON request is invalid" do
#       # request with content-type json cannot be loaded by Gyuko
#       route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "JSON")
#       parsed_request = route.parse_request("{ id: 123, v1 '2' }")
#       parsed_request[:error].should_not == nil
#     end
#   end
#
#   context "find_matching_reply" do
#     it "should return matching reply corresponding to the first matcher based on matching content type" do
#       route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "SOAP")
#       matcher1 = Factory(:matcher, :route_id => route.id)
#       matcher2 = Factory(:matcher, :route_id => route.id)
#       match1 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher1.id)
#       match2 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher1.id)
#       response1 = Factory(:response, :content_type => "text/json", :matcher_id => matcher1.id)
#       response2 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher1.id)
#
#       match3 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher2.id)
#       match4 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher2.id)
#       response3 = Factory(:response, :content_type => "text/json", :matcher_id => matcher2.id)
#       response4 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher2.id)
#
#       route.find_matching_reply(Oga.parse_xml("<root><abc>123</abc><xyz>444</xyz></root>"), "text/xml", nil).should == response2
#
#       route.find_matching_reply(Oga.parse_xml("<root><abc>123</abc><xyz>444</xyz></root>"), "text/xml", nil).should_not == response4
#     end
#
#     it "should return matching reply corresponding to the first matcher based on matching accept header" do
#       route = Factory(:route, :uri => "eibm/EmpaysTransactionService", :http_method => "POST", :kind => "SOAP")
#       matcher1 = Factory(:matcher, :route_id => route.id)
#       matcher2 = Factory(:matcher, :route_id => route.id)
#       match1 = Factory(:match, :expression => "/destTele", :eval_criteria => "equal_to", :value => '91009594129651', :matcher_id => matcher1.id)
#       response1 = Factory(:response, :content_type => "application/xml", :matcher_id => matcher1.id)
#
#       match3 = Factory(:match, :expression => "/secretCode", :eval_criteria => "equal_to", :value => 'ABCD1234', :matcher_id => matcher2.id)
#       response3 = Factory(:response, :content_type => "application/xml", :matcher_id => matcher2.id)
#
#       request1 = "
# <soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:impl='http://impl.services.eibm.empays.com/'>
#    <soapenv:Header/>
#    <soapenv:Body>
#       <impl:initiatePayment>
#          <!--Optional:-->
#          <arg0>
#             <!--Optional:-->
#
#             <!--Optional:-->
#
#             <!--Optional:-->
#             <accountId>1</accountId><acquirerCurr>356</acquirerCurr><addField1>?</addField1>
#             <!--Optional:-->
#             <addField2>?</addField2>
#             <!--Optional:-->
#             <addField3>?</addField3>
#             <!--Optional:-->
#
#             <!--Optional:-->
#             <amount>1000000</amount>
#             <!--Optional:-->
#             <bankTransId>btrnsid</bankTransId>
#             <!--Optional:-->
#
#             <!--Optional:-->
#             <cardNumber>1234</cardNumber>
#             <!--Optional:-->
#             <channelId>04</channelId>
#             <!--Optional:-->
#             <confirmationFlag>00</confirmationFlag><conversionRate>?</conversionRate>
#             <!--Optional:-->
#
#             <!--Optional:-->
#
#             <!--Optional:-->
#             <currency>356</currency>
#             <!--Optional:-->
#             <customerId>Ganesh11</customerId>
#             <!--Optional:-->
#             <customerName>Ganesh</customerName><data1>?</data1>
#             <!--Optional:-->
#             <data2>?</data2>
#             <!--Optional:-->
#             <data3>?</data3>
#             <!--Optional:-->
#
#             <!--Optional:-->
#             <destCountry>IN</destCountry>
#             <!--Optional:-->
#             <destTele>88881009594129651</destTele>
#             <!--Optional:-->
#
#             <!--Optional:-->
#
#             <!--Optional:-->
#
#             <!--Optional:-->
#             <destType>01</destType><entityId>0211</entityId><expiryDate>20151220000000</expiryDate>
#             <!--Optional:-->
#             <initiatorType>01</initiatorType>
#             <!--Optional:-->
#
#             <!--Optional:-->
#             <languageDest>ENG</languageDest><nodeID>?</nodeID>
#             <!--Optional:-->
#
#             <!--Optional:-->
#
#             <!--Optional:-->
#
#             <!--Optional:-->
#             <poolAccountId>?</poolAccountId><productId>1</productId><purpose>p</purpose><purposeType>?</purposeType>
#             <!--Optional:-->
#
#             <!--Optional:-->
#             <secretCode>ABCD1234</secretCode><sendCurrencyAmount>?</sendCurrencyAmount>
#             <!--Optional:-->
#             <senderAccountNumber>?</senderAccountNumber>
#             <!--Optional:-->
#             <senderAddress>?</senderAddress>
#             <!--Optional:-->
#             <senderAgentName>?</senderAgentName>
#             <!--Optional:-->
#             <senderEmailAdd>?</senderEmailAdd>
#             <!--Optional:-->
#             <senderName>?</senderName>
#             <!--Optional:-->
#
#             <!--Optional:-->
#             <smsDest>00091009820175762</smsDest><subEntityId>?</subEntityId>
#             <!--Optional:-->
#
#             <!--Optional:-->
#
#             <!--Optional:-->
#             <subNodeConfigCode>AXIS_IMT</subNodeConfigCode><terminalId>0000000000002529</terminalId>
#             <!--Optional:-->
#             <transDateTime>20151127000000</transDateTime><uniqueRefNo>?</uniqueRefNo>
#             <!--Optional:-->
#             <value1>?</value1>
#             <!--Optional:-->
#             <value2>?</value2>
#             <!--Optional:-->
#             <value3>?</value3>
#          </arg0>
#       </impl:initiatePayment>
#    </soapenv:Body>
# </soapenv:Envelope>"
#       route.find_matching_reply(Oga.parse_xml(request1), "application/xml", "application/xml").should == response2
#
#       # route.find_matching_reply(Oga.parse_xml("<root><abc>123</abc><xyz>444</xyz></root>"), "text/xml", nil).should_not == response4
#     end
#
#     it "should return first response if no matcher matches when accept header is nil" do
#       route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "SOAP")
#       matcher1 = Factory(:matcher, :route_id => route.id)
#       matcher2 = Factory(:matcher, :route_id => route.id)
#       match1 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher1.id)
#       match2 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher1.id)
#       response1 = Factory(:response, :content_type => "text/json", :matcher_id => matcher1.id)
#       response2 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher1.id)
#
#       match3 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher2.id)
#       match4 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher2.id)
#       response3 = Factory(:response, :content_type => "text/json", :matcher_id => matcher2.id)
#       response4 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher2.id)
#
#       route.find_matching_reply(Oga.parse_xml("<root><www>123</www><xyz>444</xyz></root>"), "text/xml", nil).should == response2
#
#       route.find_matching_reply(Oga.parse_xml("<root><www>123</www><xyz>444</xyz></root>"), "text/xml", nil).should_not == response4
#       route.find_matching_reply(Oga.parse_xml("<root><www>123</www><xyz>444</xyz></root>"), "text/xml", nil).should_not == response3
#       route.find_matching_reply(Oga.parse_xml("<root><www>123</www><xyz>444</xyz></root>"), "text/xml", nil).should_not == response1
#     end
#
#     it "should return first response if no matcher matches when accept header is present" do
#       route = Factory(:route, :uri => "abc", :http_method => "POST", :kind => "SOAP")
#       matcher1 = Factory(:matcher, :route_id => route.id)
#       matcher2 = Factory(:matcher, :route_id => route.id)
#       match1 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher1.id)
#       match2 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher1.id)
#       response1 = Factory(:response, :content_type => "text/json", :matcher_id => matcher1.id)
#       response2 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher1.id)
#
#       match3 = Factory(:match, :expression => "//abc", :eval_criteria => "exists", :matcher_id => matcher2.id)
#       match4 = Factory(:match, :expression => "//xyz", :eval_criteria => "exists", :matcher_id => matcher2.id)
#       response3 = Factory(:response, :content_type => "text/json", :matcher_id => matcher2.id)
#       response4 = Factory(:response, :content_type => "text/xml", :matcher_id => matcher2.id)
#
#       route.find_matching_reply(Oga.parse_xml("<root><www>123</www><xyz>444</xyz></root>"), "text/xml", "text/xml").should == response2
#
#       route.find_matching_reply(Oga.parse_xml("<root><www>123</www><xyz>444</xyz></root>"), "text/xml", "text/xml").should_not == response4
#       route.find_matching_reply(Oga.parse_xml("<root><www>123</www><xyz>444</xyz></root>"), "text/xml", "text/xml").should_not == response3
#       route.find_matching_reply(Oga.parse_xml("<root><www>123</www><xyz>444</xyz></root>"), "text/xml", "text/xml").should_not == response1
#     end
#   end
end