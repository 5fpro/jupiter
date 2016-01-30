require 'rails_helper'

describe SlackChannelCreateContext do
  let(:project) { FactoryGirl.create :project }
  let(:params) { FactoryGirl.attributes_for(:slack_channel, :create) }

  subject { described_class.new(project, params) }

  it { expect { subject.perform }.to change { project.slack_channels.count }.by(1) }

end
