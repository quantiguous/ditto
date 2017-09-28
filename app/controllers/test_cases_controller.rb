class TestCasesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :block_inactive_user!

  def download
    test_case = TestCase.find(params[:id])
    
    file = Tempfile.new("request-#{test_case.scenario}")
    file.write(test_case.request)
    file.close
    send_file file.path, filename: "#{test_case.scenario}", type: 'text/plain'
  end
end