class Project < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :project_users
  has_many :users, through: :project_users
end
