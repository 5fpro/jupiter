require 'rails_helper'

describe SlackChannelUpdateContext do
  let(:slack_channel) { FactoryGirl.create :slack_channel }
  let(:params) { FactoryGirl.attributes_for(:slack_channel, :update) }

  subject { described_class.new(slack_channel, params) }

  it { expect { subject.perform }.to change { slack_channel.reload.name }.to(params[:name]) }

end
