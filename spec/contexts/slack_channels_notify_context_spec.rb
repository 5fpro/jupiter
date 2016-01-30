require 'rails_helper'

describe SlackChannelsNotifyContext do
  let(:project) { project_created! }
  let(:user) { project.owner }
  let(:record) { record_created!(user, project) }

  subject { described_class.new(project, :record_created) }

  context "one slack channel" do
    before { FactoryGirl.create :slack_channel, project: project, events: ["record_created"] }

    it { expect { subject.perform(record: record) }.to change_sidekiq_jobs_size_of(SlackService, :notify).by(1) }

    context "two slack channel" do
      before { FactoryGirl.create :slack_channel, project: project, events: ["record_created"] }

      it { expect { subject.perform(record: record) }.to change_sidekiq_jobs_size_of(SlackService, :notify).by(2) }
    end

    context "slack channel without events" do
      before { FactoryGirl.create :slack_channel, project: project, events: [""] }

      it { expect { subject.perform(record: record) }.to change_sidekiq_jobs_size_of(SlackService, :notify).by(1) }
    end
  end

  context "no slack channels" do
    it { expect { subject.perform(record: record) }.not_to change_sidekiq_jobs_size_of(SlackService, :notify) }
  end
end
