# == Schema Information
#
# Table name: githubs
#
#  id            :integer          not null, primary key
#  project_id    :integer
#  webhook_token :string
#  data          :hstore
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryGirl.define do
  factory :github do

  end

end
