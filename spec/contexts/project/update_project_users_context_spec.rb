require 'rails_helper'

describe Project::UpdateProjectUsersContext, type: :context do
  subject { described_class.new(project, params) }

  let!(:project) { FactoryBot.create :project, :with_project_user }
  let!(:project_user) { project.project_users.last }
  let(:params) { attributes_for(:project_for_update, :project_users) }

  it { expect { subject.perform }.to change { project_user.reload.slack_user } }

  context 'fail' do
    before { project.update_column :name, '' }

    it { expect { subject.perform }.not_to change { project_user.reload.slack_user } }
  end
end
