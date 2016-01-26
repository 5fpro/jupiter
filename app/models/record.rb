# == Schema Information
#
# Table name: records
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  project_id  :integer
#  minutes     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  data        :hstore
#  record_type :integer
#

class Record < ActiveRecord::Base
  enum record_type: [:coding, :meeting, :discuss, :plan, :research, :documentation, :etc]

  belongs_to :project
  belongs_to :user
  has_many :comments, as: :item

  validates :user_id, :project_id, :record_type, :minutes, presence: true

  scope :this_month, -> { where(created_at: Time.zone.now.beginning_of_month..Time.zone.now) }
  scope :last_month, -> { where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month) }
  scope :this_week, -> { where(created_at: Time.zone.now.beginning_of_week..Time.zone.now) }
  scope :last_week, -> { where(created_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week) }

  store_accessor :data, :note

  class << self
    def total_time
      (unscope(:order, :select, :group).select(:minutes).map(&:minutes).inject(&:+) || 0).minutes
    end
  end
end
