FactoryGirl.define do
  factory :todo do
    project { FactoryGirl.create :project }
    user    { FactoryGirl.create :user }
  end

end
