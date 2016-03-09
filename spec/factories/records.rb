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

    trait :with_todo do
      todo_id { FactoryGirl.create(:todo).id }
    end
  end

  factory :record_for_params, class: Record do
    record_type :etc
    minutes 10
    note "update minutes"

    trait :has_todo_id do
      todo_id { FactoryGirl.create(:todo).id }
    end
  end
end
