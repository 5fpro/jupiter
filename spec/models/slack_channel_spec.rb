# == Schema Information
#
# Table name: slack_channels
#
#  id         :integer          not null, primary key
#  project_id :integer
#  disabled   :boolean          default(FALSE)
#  data       :hstore
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe SlackChannel, type: :model do
  let(:slack_channel) { FactoryGirl.create :slack_channel }

  context 'FactoryGirl' do
    it { expect(slack_channel).not_to be_new_record }
    it { FactoryGirl.create :slack_channel, :record_created }
    it { FactoryGirl.create :slack_channel, :approach_hours_limit }
    it { attributes_for :slack_channel_for_update }
    it { attributes_for :slack_channel_for_create }
  end

  it '#events and & #event?' do
    slack_channel.update_attribute :events, ['', 'record_created']
    expect(SlackChannel.find(slack_channel.id).event?(:record_created)).to eq true
  end
end
