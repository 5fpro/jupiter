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
    price_of_hour 1000

    trait :with_project_user do
      after(:create) do |project|
        FactoryGirl.create :project_user, project: project, user: project.owner
      end
    end

    trait :with_other_user do
      after(:create) do |project|
        FactoryGirl.create :project_user, project: project
      end
    end

    trait :with_slack_channel do
      after(:create) do |project|
        slack_channel = FactoryGirl.create :slack_channel, project: project
        project.update_attribute :primary_slack_channel_id, slack_channel.id
      end
    end

    trait :with_todos do
      after(:create) do |project|
        FactoryGirl.create_list :todo, 2, project: project, user: project.owner
      end
    end

    trait :with_records do
      after(:create) do |project|
        FactoryGirl.create_list :record, 2, :with_todo, project: project, user: project.owner
      end
    end

    trait :is_archived do
      after(:create) do |project|
        project.update_attribute :archived, true
      end
    end

    factory :project_for_slack_notify, traits: [:with_project_user, :with_slack_channel]
    factory :project_has_members, traits: [:with_project_user, :with_other_user]
    factory :project_has_todos, traits: [:with_project_user, :with_todos]
    factory :project_has_records, traits: [:with_project_user, :with_records]
    factory :project_is_archived, traits: [:with_project_user, :is_archived]

  end

  factory :project_for_update, class: Project do

    trait :setting do
      name "blablabla"
      price_of_hour 10_000_000
      hours_limit 100
      description "hahaha"
    end

    trait :project_users do
      project_users_attributes { [{ slack_user: "haha", id: ProjectUser.last.try(:id) }] }
    end
  end

end
