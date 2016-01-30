# == Schema Information
#
# Table name: slack_channels
#
#  id         :integer          not null, primary key
#  project_id :integer
#  disabled   :boolean          default(FALSE)
#  data       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SlackChannel < ActiveRecord::Base
  belongs_to :project

  validates :project, presence: true

  store_accessor :data, :name, :webhook, :icon_url, :robot_name, :room
end
