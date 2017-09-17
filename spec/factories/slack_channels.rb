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
    webhook 'https://hooks.slack.com/services/xxxxx/xxxx'
    room '#general'
    name 't123'

    trait :record_created do
      events { [:record_created] }
    end

    trait :approach_hours_limit do
      events { [:approach_hours_limit] }
    end
  end

  factory :slack_channel_for_update, class: SlackChannel do
    name 'ttt'
    primary '1'
  end

  factory :slack_channel_for_create, class: SlackChannel do
    robot_name 'Jupiter'
    name 'tetetetet'
    icon_url 'http://i.imgur.com/4G30GGh.jpg'
  end

end
