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
#  todo_id     :integer
#

class Record < ApplicationRecord
  enum record_type: [:coding, :meeting, :discuss, :plan, :research, :documentation, :etc]

  belongs_to :project
  belongs_to :user
  belongs_to :todo
  has_many :comments, as: :item, dependent: :destroy

  validates :user_id, :project_id, :record_type, :minutes, presence: true

  scope :this_month, -> { where(created_at: Time.zone.now.beginning_of_month..Time.zone.now) }
  scope :last_month, -> { where(created_at: 1.month.ago.beginning_of_month..1.month.ago.end_of_month) }
  scope :this_week, -> { where(created_at: Time.zone.now.beginning_of_week..Time.zone.now) }
  scope :last_week, -> { where(created_at: 1.week.ago.beginning_of_week..1.week.ago.end_of_week) }
  scope :today, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }

  store_accessor :data, :note

  class << self
    def total_time
      (unscope(:order, :select, :group).select(:minutes).map(&:minutes).inject(&:+) || 0).minutes
    end
  end

  def total_time
    minutes.to_i.minutes
  end
end
