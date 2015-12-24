class UsersRole < ActiveRecord::Base
  belongs_to :user
  belongs_to :role
  belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'AdminUser'
  belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'AdminUser'

  validates_uniqueness_of :user_id
  validates_presence_of :user_id,:role_id
end