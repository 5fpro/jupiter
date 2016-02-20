# == Schema Information
#
# Table name: todos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  desc       :text
#  date       :date
#  data       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Todo < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :records, dependent: :nullify

  validates :user_id, :project_id, :desc, presence: true

  scope :for_bind, -> { where(date: [nil, Time.zone.now.to_date]) }

  store_accessor :data, :total_time

  def total_time
    super.to_i.seconds
  end

  def done?
    date.present?
  end
end
