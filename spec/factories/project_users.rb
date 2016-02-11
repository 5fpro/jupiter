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
#

FactoryGirl.define do
  factory :project_user do
    user    { FactoryGirl.create :user }
    project { FactoryGirl.create :project }
  end

  trait :create_project_user do
    user_id    { FactoryGirl.create(:user).id }
    project_id { FactoryGirl.create(:project).id }
  end

  trait :update_project_user do
    sort :last
  end

end
