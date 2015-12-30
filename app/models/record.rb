# == Schema Information
#
# Table name: records
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  project_id  :integer
#  record_type :string
#  minutes     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  data        :hstore
#

class Record < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :comments, as: :item

  validates_presence_of :user_id, :project_id, :record_type

  store_accessor :data, :tmp
end
