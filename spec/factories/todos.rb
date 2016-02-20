# == Schema Information
#
# Table name: todos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  desc       :text
#  date       :date
#  data       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
  end

  factory :todo_for_create, class: Todo do
    sequence(:desc) { |n| "desc-#{n}" }

    trait :has_project_id do
      project_id { FactoryGirl.create(:project).id }
    end
  end

  factory :todo_for_update, class: Todo do
    sequence(:desc) { |n| "desc-#{n}" }

    trait :has_project_id do
      project_id { FactoryGirl.create(:project).id }
    end
  end

end
