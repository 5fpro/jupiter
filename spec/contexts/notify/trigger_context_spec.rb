require 'rails_helper'

describe Notify::TriggerContext do
  let!(:project) { FactoryGirl.create :project_has_records }
  let!(:user) { project.owner }
  let!(:record) { project.records.last }

  subject { described_class.new(project, :record_created) }

  context "one slack channel" do
    before { FactoryGirl.create :slack_channel, :record_created, project: project }
    before { project.reload }

    it { expect { subject.perform(record: record) }.to change_sidekiq_jobs_size_of(SlackService, :notify).by(1) }

    context "two slack channel" do
      before { FactoryGirl.create :slack_channel, :record_created, project: project }
      before { project.reload }

      it { expect { subject.perform(record: record) }.to change_sidekiq_jobs_size_of(SlackService, :notify).by(2) }
    end

    context "slack channel without events" do
      before { FactoryGirl.create :slack_channel, project: project, events: [""] }
      before { project.reload }

      it { expect { subject.perform(record: record) }.to change_sidekiq_jobs_size_of(SlackService, :notify).by(1) }
    end
  end

  context "no slack channels" do
    it { expect { subject.perform(record: record) }.not_to change_sidekiq_jobs_size_of(SlackService, :notify) }
  end
end
