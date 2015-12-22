require 'spec_helper'

describe "expected_responses/index" do
  before(:each) do
    assign(:expected_responses, [
      stub_model(ExpectedResponse,
        :resp_str => "MyText"
      ),
      stub_model(ExpectedResponse,
        :resp_str => "MyText"
      )
    ])
  end

  it "renders a list of expected_responses" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
