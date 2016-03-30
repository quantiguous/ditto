require 'spec_helper'

describe AdminRole do
  context 'association' do
  	it { should have_and_belong_to_many(:admin_users) }
  	it { should belong_to(:resource)}
  end 	
end
