require 'rails_helper'

describe Notify::SendToSlackContext do
  subject { described_class.new('haha', slack_channel) }

  let(:slack_channel) { FactoryBot.create :slack_channel }

  it do
    expect {
      subject.perform
    }.to enqueue_job(SlackNotifyJob)
  end

  it do
    expect {
      subject.perform(async: false)
    }.not_to enqueue_job(SlackNotifyJob)
  end

  context 'webhook null' do
    let(:slack_channel) { FactoryBot.create :slack_channel, webhook: nil }

    it { expect(subject.perform).to eq false }

    it do
      expect {
        subject.perform
      }.not_to enqueue_job(SlackNotifyJob)
    end
  end

  context 'room null' do
    let(:slack_channel) { FactoryBot.create :slack_channel, room: nil }

    it { expect(subject.perform).to eq false }

    it do
      expect {
        subject.perform
      }.not_to enqueue_job(SlackNotifyJob)
    end
  end
end
