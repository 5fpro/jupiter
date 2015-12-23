FactoryGirl.define do
  factory :project do
    owner { FactoryGirl.create :user }    
  end

end
