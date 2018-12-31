require 'rails_helper'

describe Notify::TriggerContext do
  let!(:project) { FactoryGirl.create :project_has_records }
  let!(:user) { project.owner }
  let!(:record) { project.records.last }

  subject { described_class.new(project, :record_created) }

  context 'one slack channel' do
    before { FactoryGirl.create :slack_channel, :record_created, project: project }
    before { project.reload }

    it do
      expect {
        subject.perform(record: record)
      }.to have_enqueued_job(SlackNotifyJob)
    end

    context 'two slack channel' do
      before { FactoryGirl.create :slack_channel, :record_created, project: project }
      before { project.reload }

      it do
        expect {
          subject.perform(record: record)
        }.to have_enqueued_job(SlackNotifyJob).exactly(2)
      end
    end

    context 'slack channel without events' do
      before { FactoryGirl.create :slack_channel, project: project, events: [''] }
      before { project.reload }

      it do
        expect {
          subject.perform(record: record)
        }.to have_enqueued_job(SlackNotifyJob)
      end
    end
  end

  context 'no slack channels' do
    it do
      expect {
        subject.perform(record: record)
      }.not_to have_enqueued_job(SlackNotifyJob)
    end
  end
end
