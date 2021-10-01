require 'rails_helper'

describe Common::ProjectAddUserContext do
  subject { described_class.new(project, user).perform }

  let(:user) { FactoryBot.create :user }
  let(:project) { FactoryBot.create :project }

  it 'success' do
    expect {
      subject
    }.to change { project.reload.has_user?(user) }.to(true)
  end

  it '#update_users_count' do
    expect {
      subject
    }.to change { project.reload.users_count }.by(1)
  end

  describe '#validates_user_not_in_project!' do
    before { subject }

    it 'users_count' do
      expect {
        described_class.new(project, user).perform
      }.not_to change { project.reload.users_count }
    end

    it 'project_users.count' do
      expect {
        described_class.new(project, user).perform
      }.not_to change { project.reload.project_users.count }
    end
  end
end
