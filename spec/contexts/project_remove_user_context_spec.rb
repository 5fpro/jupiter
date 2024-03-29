require 'rails_helper'

describe ProjectRemoveUserContext do
  subject { described_class.new(owner, user, project) }

  let(:owner) { FactoryBot.create :user }
  let!(:project) { FactoryBot.create :project_has_members, owner: owner }
  let(:user) { project.users.find { |u| u.id != owner.id } }

  context 'success' do
    it 'project not has user' do
      expect {
        subject.perform
      }.to change { project.reload.has_user?(user) }.to(false)
    end

    it '#update_users_count' do
      expect {
        subject.perform
      }.to change { project.reload.users.count }.by(-1)
    end
  end

  it '#validates_owner!' do
    project.update_attribute :owner, FactoryBot.create(:user)
    expect {
      @result = subject.perform
    }.not_to change { project.reload.users_count }
    expect(@result).to eq false
  end

  it 'validates_user!' do
    subject.perform
    expect {
      @result = subject.perform
    }.not_to change { project.reload.users_count }
    expect(@result).to eq false
  end

  it '#validates_is_not_self!' do
    expect {
      @result = described_class.new(owner, owner, project).perform
    }.not_to change { project.reload.users_count }
    expect(@result).to eq false
  end
end
