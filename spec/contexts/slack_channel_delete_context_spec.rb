require 'rails_helper'

describe SlackChannelDeleteContext do
  let(:slack_channel) { FactoryGirl.create :slack_channel }
  let(:project) { slack_channel.project }
  let(:user) { project.owner }

  subject { described_class.new(user, slack_channel) }

  it { expect { subject.perform }.to change { project.slack_channels.count }.by(-1) }

  context "not owner" do
    let(:user2) { FactoryGirl.create :user }
    before { project_invite!(project, user2) }
    subject { described_class.new(user2, slack_channel) }

    it { expect { subject.perform }.not_to change { project.slack_channels.count } }
  end
end
