# == Schema Information
#
# Table name: project_users
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  let(:project_user) { FactoryGirl.create :project_user }

  it "FactoryGirl" do
    expect(project_user).not_to be_new_record
  end
end
