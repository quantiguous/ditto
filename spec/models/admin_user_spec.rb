require 'spec_helper'

describe AdminUser do 
	context "validation" do
		it "should require a username" do
           user = User.create(:username => "")
           user.valid?
           user.errors.should have_key(:username)
        end
    end    
end