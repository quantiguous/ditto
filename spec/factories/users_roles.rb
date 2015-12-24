 FactoryGirl.define do
   factory :users_role do
     user_id {Factory(:user).id}
     role_id {Factory(:role).id}
   end
 end