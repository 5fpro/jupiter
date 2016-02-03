require 'rails_helper'

RSpec.describe ProjectUsersController, type: :request do

  describe "#update" do
    let(:data) { data_for(:update_project_user) }
    let!(:user) { FactoryGirl.create(:user) }
    let(:project_user) { user.project_users.first }

    before do
      signin_user(user)
      project_created!(user)
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