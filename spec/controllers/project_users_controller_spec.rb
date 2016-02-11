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

RSpec.describe ProjectUsersController, type: :request do

  describe "#update" do
    let(:data) { attributes_for(:project_user_for_update) }
    let!(:user) { FactoryGirl.create(:user) }
    let(:project_user) { user.project_users.first }

    before do
      signin_user(user)
      FactoryGirl.create :project, :with_project_user, owner: user
    end

    context "success" do
      subject { put "/project_users/#{project_user.id}", project_user: data }
      before { subject }

      it { expect(response).to be_redirect }
      it { expect(project_user.reload.sort).not_to be_nil }

      context "follow redirect" do
        before { follow_redirect! }

        it { expect(response).to be_success }
      end
    end

    context "not in project" do
      subject { put "/project_users/xxxxxx", project_user: data }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

end
