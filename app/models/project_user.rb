# == Schema Information
#
# Table name: project_users
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates_uniqueness_of :project_id, scope: :user_id
end
