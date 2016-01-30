require 'rails_helper'

describe SlackChannelCreateContext do
  let(:project) { FactoryGirl.create :project }
  let(:user) { project.owner }
  let(:params) { FactoryGirl.attributes_for(:slack_channel, :create) }

  subject { described_class.new(user, project) }

  it { expect { subject.perform(params) }.to change { project.slack_channels.count }.by(1) }

  context "user is not owner" do
    let(:user) { FactoryGirl.create :user }
    subject { described_class.new(user, project) }

    it { expect { subject.perform(params) }.not_to change { project.slack_channels.count } }
  end
end
