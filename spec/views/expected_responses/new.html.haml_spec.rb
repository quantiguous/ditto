require 'spec_helper'

describe "expected_responses/new" do
  before(:each) do
    assign(:expected_response, stub_model(ExpectedResponse,
      :resp_str => "MyText"
    ).as_new_record)
  end

  it "renders new expected_response form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", expected_responses_path, "post" do
      assert_select "textarea#expected_response_resp_str[name=?]", "expected_response[resp_str]"
    end
  end
end
