# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  item_id    :integer
#  item_type  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  data       :hstore
#

class Comment < ApplicationRecord
  belongs_to :item, polymorphic: true
  belongs_to :user

  validates :user_id, presence: true

  store_accessor :data, :tmp
end
