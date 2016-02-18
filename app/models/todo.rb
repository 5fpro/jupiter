# == Schema Information
#
# Table name: todos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  desc       :text
#  record_ids :text
#  date       :datetime
#  data       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Todo < ActiveRecord::Base
  belongs_to :project
  belongs_to :user

  validates :user_id, :project_id, :desc, presence: true
  serialize :record_ids

  store_accessor :data, :tmp
end
