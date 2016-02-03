# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  item_id    :integer
#  item_type  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  data       :hstore
#

FactoryGirl.define do
  factory :comment do
    user { FactoryGirl.create :user }
    item { FactoryGirl.create :record }
  end

  trait :create_comment do
    user_id { FactoryGirl.create(:user).id }
  end

end
