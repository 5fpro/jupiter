# == Schema Information
#
# Table name: todos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  desc       :text
#  record_ids :text
#  date       :date
#  data       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Todo < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :user_id, :project_id, :desc, presence: true
  serialize :record_ids

  scope :for_bind, -> { where(date: [nil, Time.zone.now.to_date]) }

  store_accessor :data, :tmp
end
