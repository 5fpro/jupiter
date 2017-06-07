# == Schema Information
#
# Table name: project_users
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sort       :integer
#  data       :hstore
#

class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :project_id, uniqueness: { scope: :user_id }

  sortable column: :sort, add_new_at: nil

  store_accessor :data, :slack_user

  def self.project_archived(project_users, option)
    project_users.select { |project_user| project_user.project.is_archived? == option }
  end
end
