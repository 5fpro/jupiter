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
#  data       :hstore
#  archived   :boolean          default(FALSE)
#  wage       :integer
#

FactoryGirl.define do
  factory :project_user do
    user    { FactoryGirl.create :user }
    project { FactoryGirl.create :project }
    sequence(:slack_user) { |n| "user-#{n}" }
  end

  factory :project_user_for_update, class: ProjectUser do
    sort :last
    slack_user 'haha'
    wage 123
  end

end
