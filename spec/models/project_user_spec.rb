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
#

require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  let(:project_user) { FactoryGirl.create :project_user }

  context "FactoryGirl" do
    it { expect(project_user).not_to be_new_record }
    it { attributes_for :project_user_for_update }
  end

  describe ".project_archived" do
    let!(:user) { create(:user) }
    let!(:project1) { create(:project, is_archived: true) }
    let!(:project2) { create(:project, is_archived: false) }
    let!(:project_user1) { create(:project_user, user: user, project: project1) }
    let!(:project_user2) { create(:project_user, user: user, project: project2) }
    subject { ProjectUser.project_archived(user.project_users, true) }

    it "ProjectUser is archived " do
      expect(subject).to include(project_user1)
      expect(subject).not_to include(project_user2)
    end
  end
end
