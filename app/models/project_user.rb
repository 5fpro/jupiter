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
#  archived   :boolean          default(FALSE)
#

class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :project_id, uniqueness: { scope: :user_id }

  sortable column: :sort, add_new_at: nil

  store_accessor :data, :slack_user

  scope :is_archived, -> { where(archived: true) }
  scope :is_not_archived, -> { where(archived: false)}
end
