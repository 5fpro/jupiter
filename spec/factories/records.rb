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

FactoryBot.define do
  factory :record do
    project { FactoryBot.create :project }
    user    { FactoryBot.create :user }
    todo    { FactoryBot.create(:todo) }
    record_type { :coding }
    minutes { 100 }

    trait :with_todo do
    end
  end

  factory :record_for_params, class: 'Record' do
    record_type { :etc }
    minutes { 10 }
    note { 'update minutes' }

    trait :has_todo_id do
      todo_id { FactoryBot.create(:todo).id }
    end
  end
end
