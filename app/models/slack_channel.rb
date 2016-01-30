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
  EVENTS = [:record_created].freeze

  belongs_to :project

  validates :project, presence: true

  store_accessor :data, :name, :webhook, :icon_url, :robot_name, :room, :events

  def events
    value = (super || [])
    value = eval(value) if value.is_a?(String) && value.present?
    value.map(&:to_s).select(&:present?)
  end

  def event?(e)
    events.include?(e.to_s)
  end
end
