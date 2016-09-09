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
#  done             :boolean
#  last_recorded_at :datetime
#  sort             :integer
#  status           :integer
#

class Todo < ActiveRecord::Base
  include AASM
  sortable column: :sort, scope: :user, add_new_at: nil

  belongs_to :project
  belongs_to :user
  has_many :records, dependent: :nullify

  validates :user_id, :project_id, :desc, presence: true

  scope :for_bind, -> { where("status = ? OR status = ? OR last_recorded_on = ?", 1, 2, Time.zone.now.to_date).order(done: :asc) }
  scope :today_done, -> { today.finished }
  scope :today_doing, -> { where(status: [1, 2]).where(last_recorded_on: Time.zone.now.to_date).order(done: :asc) }
  scope :today, -> { where(last_recorded_on: Time.zone.now.to_date) }
  scope :not_today, -> { where("last_recorded_on != ? OR last_recorded_on is ?", Time.zone.now.to_date, nil) }
  scope :project_sorted, -> { order(project_id: :asc) }

  store_accessor :data, :total_time, :original_id

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

  def not_finished?
    !finished?
  end

  enum status: {
    pending: 1,
    doing: 2,
    finished: 3
  }

  aasm column: :status, enum: true, whiny_transitions: false do
    state :pending, initial: true
    state :doing
    state :finished

    event :to_doing, after: :add_to_sort do
      transitions from: [:pending, :finished], to: :doing
    end

    event :to_pending, after: :remove_sort do
      transitions from: :doing, to: :pending
    end

    event :to_finished, after: :remove_sort do
      transitions from: [:pending, :doing], to: :finished do
        guard do
          has_last_record?
        end
      end
    end
  end

  def has_last_record?
    last_recorded_at.present?
  end

  def remove_sort
    remove_from_list if in_list?
  end

  def add_to_sort
    if not_in_list?
      insert_at(1)
      move_to_bottom
    end
  end
end
