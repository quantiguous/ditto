require 'spec_helper'

describe "expected_responses/edit" do
  before(:each) do
    @expected_response = assign(:expected_response, stub_model(ExpectedResponse,
      :resp_str => "MyText"
    ))
  end

  it "renders the edit expected_response form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", expected_response_path(@expected_response), "post" do
      assert_select "textarea#expected_response_resp_str[name=?]", "expected_response[resp_str]"
    end
  end
end
