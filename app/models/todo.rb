# == Schema Information
#
# Table name: todos
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  project_id       :integer
#  desc             :text
#  last_recorded_on :date
#  data             :hstore
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  last_recorded_at :datetime
#  sort             :integer
#  status           :integer
#

class Todo < ApplicationRecord
  include TodoStatusConcern
  sortable column: :sort, scope: :user, add_new_at: nil

  belongs_to :project
  belongs_to :user
  has_many :records, dependent: :nullify

  validates :user_id, :project_id, :desc, presence: true
  scope :for_bind, -> { where.not('status = ? AND last_recorded_on != ?', Todo.statuses[:finished], Time.zone.now.to_date) }
  scope :today_finished, -> { today.finished }
  scope :today_doing_and_not_finished, -> { where(status: [Todo.statuses[:pending], Todo.statuses[:doing]]).where(last_recorded_on: Time.zone.now.to_date) }
  scope :today, -> { where(last_recorded_on: Time.zone.now.to_date) }
  scope :not_today, -> { where('last_recorded_on != ? OR last_recorded_on is ?', Time.zone.now.to_date, nil) }
  scope :project_sorted, -> { order(project_id: :asc) }
  store_accessor :data, :total_time, :original_id

  enum status: {
    pending: 1,
    doing: 2,
    finished: 3
  }

  def total_time
    super.to_i.seconds
  end

  def original_id
    super.to_i
  end

  def last_recorded_at=(v)
    super(v)
    self.last_recorded_on = v.try(:to_date)
  end
end
