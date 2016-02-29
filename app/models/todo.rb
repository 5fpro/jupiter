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
#  done             :boolean          default(FALSE)
#  last_recorded_at :datetime
#

class Todo < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :records, dependent: :nullify

  validates :user_id, :project_id, :desc, presence: true

  scope :for_bind, -> { where("done = ? OR last_recorded_on = ?", false, Time.zone.now.to_date).order(done: :asc) }
  scope :today_done, -> { where(last_recorded_on: Time.zone.now.to_date) }
  scope :not_done, -> { where(done: false) }
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
end
