# == Schema Information
#
# Table name: slack_channels
#
#  id         :integer          not null, primary key
#  project_id :integer
#  disabled   :boolean          default(FALSE)
#  data       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :slack_channel do
    project { FactoryGirl.create :project }

    trait :create do
      project nil
      webhook "http://xxxxxx.comasdasd/dasdasdasd/asdasdas"
      robot_name "Jupiter"
      name "tetetetet"
      icon_url "http://i.imgur.com/4G30GGh.jpg"
      room "#general"
    end

    trait :update do
      project nil
      name "ttt"
    end
  end

end