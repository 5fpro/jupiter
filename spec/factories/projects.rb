# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  price_of_hour :integer
#  name          :string
#  owner_id      :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  data          :hstore
#

FactoryGirl.define do
  factory :project do
    owner { FactoryGirl.create :user }
    sequence(:name) { |n| "Project Name - #{n}" }
  end

end
