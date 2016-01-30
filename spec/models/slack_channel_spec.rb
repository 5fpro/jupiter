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

  it "FactoryGirl" do
    expect(slack_channel).not_to be_new_record
  end

  it "#events and & #event?" do
    slack_channel.update_attribute :events, ["", "record_created"]
    expect( SlackChannel.find(slack_channel.id).event?(:record_created) ).to eq true
  end
end
