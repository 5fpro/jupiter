FactoryGirl.define do
  factory :comment do
    user { FactoryGirl.create :user }
    item { FactoryGirl.create :record }
  end

end
