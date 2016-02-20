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
#  todo_id     :integer
#

FactoryGirl.define do
  factory :record do
    project { FactoryGirl.create :project }
    user    { FactoryGirl.create :user }
    record_type :coding
    minutes 100
  end

  factory :record_for_update, class: Record do
    record_type :etc
    minutes 10
    note "update minutes"
  end
end
