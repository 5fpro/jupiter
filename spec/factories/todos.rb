FactoryGirl.define do
  factory :todo do
    project { FactoryGirl.create :project }
    user    { FactoryGirl.create :user }
    sequence(:desc) { |n| "desc-#{n}" }
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
