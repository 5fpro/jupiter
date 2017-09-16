require 'rails_helper'

describe Notify::SendToUserContext do
  let!(:project) { FactoryGirl.create :project_for_slack_notify }
  let!(:user) { project.owner }

  subject { described_class.new(project, user, "haha") }

  it do
    expect {
      subject.perform
    }.to enqueue_job(SlackNotifyJob)
  end

  context "no primary slack channel" do
    before { project.update_attribute :primary_slack_channel_id, nil }

    it do
      expect {
        subject.perform
      }.not_to enqueue_job(SlackNotifyJob)
    end
  end

  context "user not in project" do
    let(:user) { FactoryGirl.create :user }

    it do
      expect {
        subject.perform
      }.not_to enqueue_job(SlackNotifyJob)
    end
  end

  context "project_user has no slack_user" do
    before { project.project_users.first.update_attribute :slack_user, "" }

    it do
      expect {
        subject.perform
      }.not_to enqueue_job(SlackNotifyJob)
    end
  end
end
