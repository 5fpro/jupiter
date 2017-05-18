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
#  is_archived   :boolean          default(FALSE)
#

class Project < ActiveRecord::Base
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  has_many :project_users, dependent: :destroy
  accepts_nested_attributes_for :project_users
  has_many :users, through: :project_users
  has_many :records
  has_many :slack_channels, dependent: :destroy
  has_many :todos
  has_many :githubs

  store_accessor :data, :users_count, :description, :hours_limit,
                 :approached_hours_limit, :primary_slack_channel_id,
                 :github_slack_users_mapping_json

  validates :name, :owner_id, presence: true

  scope :archived?, -> (option) { where(is_archived: option) }

  def has_user?(user)
    project_users.map(&:user_id).include?(user.id)
  end

  def owner?(user)
    owner_id == user.try(:id)
  end

  def users_count
    super.to_i
  end

  def hours_limit
    super.to_i
  end

  def approached_hours_limit
    super == "true"
  end

  def primary_slack_channel
    return if primary_slack_channel_id.blank?
    @primary_slack_channel ||= slack_channels.try(:find, primary_slack_channel_id)
  end
end
