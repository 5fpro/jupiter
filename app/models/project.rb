# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  price_of_hour :integer
#  name          :string
#  owner_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  data          :hstore
#

class Project < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :project_users
  has_many :users, through: :project_users
  has_many :records

  store_accessor :data, :users_count

  validates :name, :owner_id, presence: true

  def has_user?(user)
    project_users.map(&:user_id).include?(user.id)
  end

  def users_count
    super.to_i
  end
end
