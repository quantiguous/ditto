require 'spec_helper'

describe "input_requests/new" do
  before(:each) do
    assign(:input_request, stub_model(InputRequest,
      :req_str => "MyText",
      :req_uid => "MyString"
    ).as_new_record)
  end

  it "renders new input_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", input_requests_path, "post" do
      assert_select "textarea#input_request_req_str[name=?]", "input_request[req_str]"
      assert_select "input#input_request_req_uid[name=?]", "input_request[req_uid]"
    end
  end
end
