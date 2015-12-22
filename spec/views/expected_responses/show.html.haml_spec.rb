require 'spec_helper'

describe "expected_responses/show" do
  before(:each) do
    @expected_response = assign(:expected_response, stub_model(ExpectedResponse,
      :resp_str => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
