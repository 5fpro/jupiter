require 'rails_helper'

describe SlackChannelUpdateContext do
  let(:slack_channel) { FactoryGirl.create :slack_channel }
  let(:user) { slack_channel.project.owner }
  let(:params) { FactoryGirl.attributes_for(:slack_channel, :update) }

  subject { described_class.new(user, slack_channel) }

  it { expect { subject.perform(params) }.to change { slack_channel.reload.name }.to(params[:name]) }

  context "user is not owner" do
    let(:user) { FactoryGirl.create :user }

    it { expect { subject.perform(params) }.not_to change { slack_channel.reload.name } }
  end

  context "update :events" do
    let(:params) { { events: ["", "record_created"] } }
    it { expect { subject.perform(params) }.to change { slack_channel.reload.events }.to(["record_created"]) }
  end
end
