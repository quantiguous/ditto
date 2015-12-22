require 'spec_helper'

describe "input_requests/show" do
  before(:each) do
    @input_request = assign(:input_request, stub_model(InputRequest,
      :req_str => "MyText",
      :req_uid => "Req Uid"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    rendered.should match(/Req Uid/)
  end
end
