require 'rails_helper'

describe SlackChannelCreateContext do
  let(:project) { FactoryGirl.create :project }
  let(:user) { project.owner }
  let(:params) { attributes_for(:slack_channel_for_create) }

  subject { described_class.new(user, project) }

  context 'success' do
    it { expect { subject.perform(params) }.to change { project.slack_channels.count }.by(1) }
    it do
      slack_channel = subject.perform(params)
      expect(slack_channel.name).to eq params[:name]
    end
  end

  context 'user is not owner' do
    let(:user) { FactoryGirl.create :user }
    subject { described_class.new(user, project) }

    it { expect { subject.perform(params) }.not_to change { project.slack_channels.count } }
  end
end
