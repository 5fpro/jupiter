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
  it "FactoryGirl" do
    expect(FactoryGirl.create :slack_channel).not_to be_new_record 
  end
end
