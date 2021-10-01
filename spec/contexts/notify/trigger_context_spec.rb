require 'rails_helper'

describe Notify::TriggerContext do
  subject { described_class.new(project, :record_created) }

  let!(:project) { FactoryBot.create :project_has_records }
  let!(:user) { project.owner }
  let!(:record) { project.records.last }

  context 'one slack channel' do
    before { FactoryBot.create :slack_channel, :record_created, project: project }

    before { project.reload }

    it do
      expect {
        subject.perform(record: record)
      }.to have_enqueued_job(SlackNotifyJob)
    end

    context 'two slack channel' do
      before { FactoryBot.create :slack_channel, :record_created, project: project }

      before { project.reload }

      it do
        expect {
          subject.perform(record: record)
        }.to have_enqueued_job(SlackNotifyJob).exactly(2)
      end
    end

    context 'slack channel without events' do
      before { FactoryBot.create :slack_channel, project: project, events: [''] }

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
