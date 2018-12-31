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

RSpec.describe ProjectUsersController, type: :request do

  describe '#update' do
    let(:data) { attributes_for(:project_user_for_update) }
    let!(:user) { FactoryGirl.create(:user) }
    let(:project_user) { user.project_users.first }

    before do
      signin_user(user)
      FactoryGirl.create :project, :with_project_user, owner: user
    end

    context 'success' do
      subject { put "/project_users/#{project_user.id}", params: { project_user: data } }
      before { subject }

      it { expect(response).to be_redirect }
      it { expect(project_user.reload.sort).not_to be_nil }

      context 'follow redirect' do
        before { follow_redirect! }

        it { expect(response).to be_success }
      end
    end

    context 'not in project' do
      subject { put '/project_users/xxxxxx', params: { project_user: data } }

      it { expect { subject }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context 'archive project with remove from sorted list' do
      let!(:project_users) { create_list(:project_user, 3, user: user) }
      before { project_users.map { |pu| pu.update(sort: :last) } }

      def get_max_sort_index
        project_users.map { |pu| pu.reload.sort }.select(&:present?).max
      end

      it do
        expect {
          put "/project_users/#{project_users.last.id}", params: { project_user: { archived: true, sort: :remove } }
        }.to change { get_max_sort_index }.from(3).to(2)
      end
    end
  end

end
