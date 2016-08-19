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

  store_accessor :data, :hook_id, :webhook_name, :repo_fullname

  def hook_id
    super.to_i
  end
end
