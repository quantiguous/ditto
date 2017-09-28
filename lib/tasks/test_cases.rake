namespace :test_cases do
  desc "Creating Test Cases"
  task :seed, [:file_path] => :environment do |t, args|
    xlsx = Roo::Excelx.new(File.expand_path(args[:file_path]))
    
    service_id = Service.find_by_name('FundsTransferByCustomerService').id
    
    xlsx.each_row_streaming do |row|
      scenario = "#{row[0].value} - ReqTransferType: #{row[1].value} - TransferType: #{row[2].value}"
      TestCase.find_or_create_by(scenario: scenario) do |s|
        s.request = row[3].value
        s.service_id = service_id
      end
    end
  end
end
