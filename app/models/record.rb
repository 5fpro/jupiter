class Record < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :comments, as: :item
end
