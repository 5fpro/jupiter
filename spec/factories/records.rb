# == Schema Information
#
# Table name: records
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  project_id  :integer
#  record_type :string
#  minutes     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :record do
    project { FactoryGirl.create :project }
    user    { FactoryGirl.create :user }
  end

end
