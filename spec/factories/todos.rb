FactoryGirl.define do
  factory :todo do
    project { FactoryGirl.create :project }
    user    { FactoryGirl.create :user }
  end

  factory :todo_for_create, class: Todo do
    trait :params do
      project_id { FactoryGirl.create(:project).id }
      sequence(:desc) { |n| "desc-#{n}" }
    end
  end

  factory :todo_for_update, class: Todo do
    trait :params do
      sequence(:desc) { |n| "desc-#{n}" }
    end

    trait :params_with_project do
      project_id { FactoryGirl.create(:project).id }
      sequence(:desc) { |n| "desc-#{n}" }
    end
  end

end
