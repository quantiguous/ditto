require 'spec_helper'

describe "input_requests/edit" do
  before(:each) do
    @input_request = assign(:input_request, stub_model(InputRequest,
      :req_str => "MyText",
      :req_uid => "MyString"
    ))
  end

  it "renders the edit input_request form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", input_request_path(@input_request), "post" do
      assert_select "textarea#input_request_req_str[name=?]", "input_request[req_str]"
      assert_select "input#input_request_req_uid[name=?]", "input_request[req_uid]"
    end
  end
end
