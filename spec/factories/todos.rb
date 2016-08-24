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
#  done             :boolean
#  last_recorded_at :datetime
#  sort             :integer
#

FactoryGirl.define do
  factory :todo do
    project { FactoryGirl.create :project }
    user    { FactoryGirl.create :user }
    sequence(:desc) { |n| "desc-#{n}" }

    trait :with_records do
      after :create do |todo|
        FactoryGirl.create_list(:record, 2, todo: todo)
      end
    end

    trait :done do
      last_recorded_at { Time.zone.now }
      done true
    end

    trait :not_done do
      done nil
    end
  end

  factory :todo_for_params, class: Todo do
    sequence(:desc) { |n| "desc-#{n}" }

    trait :has_project_id do
      project_id { FactoryGirl.create(:project).id }
    end
  end
end
