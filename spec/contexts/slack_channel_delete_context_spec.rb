require 'rails_helper'

describe SlackChannelDeleteContext do

  subject { described_class.new(user, slack_channel) }

  let!(:project) { FactoryBot.create :project_has_members }
  let!(:slack_channel) { FactoryBot.create :slack_channel, project: project }
  let(:user) { project.owner }

  it { expect { subject.perform }.to change { project.slack_channels.count }.by(-1) }

  context 'not owner' do
    subject { described_class.new(user2, slack_channel) }

    let(:user2) { project.users.last }

    it { expect { subject.perform }.not_to change { project.slack_channels.count } }
  end
end
