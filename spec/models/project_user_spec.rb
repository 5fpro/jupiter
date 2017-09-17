# == Schema Information
#
# Table name: project_users
#
#  id         :integer          not null, primary key
#  project_id :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sort       :integer
#  data       :hstore
#  archived   :boolean          default(FALSE)
#  wage       :integer
#

require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  let(:project_user) { FactoryGirl.create :project_user }

  context 'FactoryGirl' do
    it { expect(project_user).not_to be_new_record }
    it { attributes_for :project_user_for_update }
  end
end
