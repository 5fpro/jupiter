require 'rails_helper'

describe Notify::SendToUserContext do
  let!(:project) { FactoryGirl.create :project_for_slack_notify }
  let!(:user) { project.owner }

  subject { described_class.new(project, user, "haha") }

  it { expect { subject.perform }.to change_sidekiq_jobs_size_of(SlackService, :notify).by(1) }

  context "no primary slack channel" do
    before { project.update_attribute :primary_slack_channel_id, nil }

    it { expect { subject.perform }.not_to change_sidekiq_jobs_size_of(SlackService, :notify) }
  end

  context "user not in project" do
    let(:user) { FactoryGirl.create :user }

    it { expect { subject.perform }.not_to change_sidekiq_jobs_size_of(SlackService, :notify) }
  end

  context "project_user has no slack_user" do
    before { project.project_users.first.update_attribute :slack_user, "" }

    it { expect { subject.perform }.not_to change_sidekiq_jobs_size_of(SlackService, :notify) }
  end
end
