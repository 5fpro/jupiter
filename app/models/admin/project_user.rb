# == Schema Information
#
# Table name: project_users
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sort       :integer
#

class Admin::ProjectUser < ::ProjectUser
end
