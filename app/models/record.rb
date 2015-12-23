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
#

class Record < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :comments, as: :item
end
