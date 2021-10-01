# == Schema Information
#
# Table name: todos
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  project_id       :integer
#  desc             :text
#  last_recorded_on :date
#  data             :hstore
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  last_recorded_at :datetime
#  sort             :integer
#  status           :integer
#

FactoryBot.define do
  factory :todo do
    project { FactoryBot.create :project }
    user    { FactoryBot.create :user }
    sequence(:desc) { |n| "desc-#{n}" }

    trait :with_records do
      last_recorded_at { Time.zone.now }
      after :create do |todo|
        FactoryBot.create_list(:record, 2, todo: todo)
      end
    end

    trait :with_not_calculate_record do
      after :create do |todo|
        FactoryBot.create_list(:record, 2, todo: todo)
      end
    end

    trait :finished do
      last_recorded_at { Time.zone.now }
      status { 'finished' }
    end

    trait :doing do
      status { 'doing' }
    end

    trait :pending do
      status { 'pending' }
    end
  end

  factory :todo_for_params, class: 'Todo' do
    sequence(:desc) { |n| "desc-#{n}" }

    trait :has_project_id do
      project_id { FactoryBot.create(:project).id }
    end
  end
end
