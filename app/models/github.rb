# == Schema Information
#
# Table name: githubs
#
#  id            :integer          not null, primary key
#  project_id    :integer
#  webhook_token :string
#  data          :hstore
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Github < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :webhook_token
  validates_uniqueness_of :webhook_token

  store_accessor :data, :hook_id, :repo_fullname

  def hook_id
    super.to_i
  end

  def webhook_url
    "https://#{Setting.host}/webhooks/#{webhook_token}"
  end
end
