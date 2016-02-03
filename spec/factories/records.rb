# == Schema Information
#
# Table name: records
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  project_id  :integer
#  minutes     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  data        :hstore
#  record_type :integer
#

FactoryGirl.define do
  factory :record do
    project { FactoryGirl.create :project }
    user    { FactoryGirl.create :user }
    record_type :coding
    minutes 100
  end

  trait :create_record do
    record_type :coding
    minutes 120
    note "fix bug"
  end

  trait :update_record do
    record_type :etc
    minutes 10
    note "update minutes"
  end

end
