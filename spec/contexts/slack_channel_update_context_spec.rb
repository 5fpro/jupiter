require 'rails_helper'

describe SlackChannelUpdateContext do
  subject { described_class.new(user, slack_channel) }

  let(:slack_channel) { FactoryBot.create :slack_channel }
  let(:user) { slack_channel.project.owner }
  let(:params) { attributes_for(:slack_channel_for_update) }

  it { expect { subject.perform(params) }.to change { slack_channel.reload.name }.to(params[:name]) }

  context 'user is not owner' do
    let(:user) { FactoryBot.create :user }

    it { expect { subject.perform(params) }.not_to change { slack_channel.reload.name } }
  end

  context 'update :events' do
    let(:params) { { events: ['', 'record_created'] } }

    it { expect { subject.perform(params) }.to change { slack_channel.reload.events }.to(['record_created']) }
  end

  context 'update primary' do
    context 'from false to true' do
      let(:params) { { primary: '1' } }

      before { slack_channel.project.update_attribute :primary_slack_channel_id, '' }

      it { expect { subject.perform(params) }.to change { slack_channel.reload.primary? }.from(false).to(true) }
    end

    context 'from true to false' do
      let(:params) { { primary: '0' } }

      before { slack_channel.project.update_attribute :primary_slack_channel_id, slack_channel.id }

      it { expect { subject.perform(params) }.to change { slack_channel.reload.primary? }.from(true).to(false) }
    end
  end
end
