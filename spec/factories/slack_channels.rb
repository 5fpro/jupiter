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
    webhook "https://hooks.slack.com/services/xxxxx/xxxx"
    room "#general"

    trait :create do
      project nil
      robot_name "Jupiter"
      name "tetetetet"
      icon_url "http://i.imgur.com/4G30GGh.jpg"
    end

    trait :record_created do
      events { [:record_created] }
    end

    trait :monthly_limit_hours_approach do
      events { [:monthly_limit_hours_approach] }
    end

    trait :update do
      project nil
      name "ttt"
    end
  end

end
