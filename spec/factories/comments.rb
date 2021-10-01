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

FactoryBot.define do
  factory :comment do
    user { FactoryBot.create :user }
    item { FactoryBot.create :record }
  end

  factory :comment_for_create, class: 'Comment' do
    user_id { FactoryBot.create(:user).id }
  end
end
