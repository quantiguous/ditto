require 'spec_helper'

describe "input_requests/index" do
  before(:each) do
    assign(:input_requests, [
      stub_model(InputRequest,
        :req_str => "MyText",
        :req_uid => "Req Uid"
      ),
      stub_model(InputRequest,
        :req_str => "MyText",
        :req_uid => "Req Uid"
      )
    ])
  end

  it "renders a list of input_requests" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Req Uid".to_s, :count => 2
  end
end
