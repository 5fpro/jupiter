FactoryGirl.define do
  factory :project_user do
    user    { FactoryGirl.create :user }
    project { FactoryGirl.create :project } 
  end

end
