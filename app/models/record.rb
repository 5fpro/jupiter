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

  store_accessor :data, :note
end
