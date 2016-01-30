require 'rails_helper'

describe Notify::SendToSlackContext do
  let(:slack_channel) { FactoryGirl.create :slack_channel }

  subject { described_class.new("haha", slack_channel) }

  it { expect { subject.perform }.to change_sidekiq_jobs_size_of(SlackService, :notify).by(1) }

  it { expect { subject.perform(async: false) }.not_to change_sidekiq_jobs_size_of(SlackService, :notify) }

  context "webhook null" do
    let(:slack_channel) { FactoryGirl.create :slack_channel, webhook: nil }

    it { expect(subject.perform).to eq false }
    it { expect { subject.perform }.not_to change_sidekiq_jobs_size_of(SlackService, :notify) }
  end

  context "room null" do
    let(:slack_channel) { FactoryGirl.create :slack_channel, room: nil }

    it { expect(subject.perform).to eq false }
    it { expect { subject.perform }.not_to change_sidekiq_jobs_size_of(SlackService, :notify) }
  end
end
