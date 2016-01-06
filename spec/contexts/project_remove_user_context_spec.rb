require 'rails_helper'

describe ProjectRemoveUserContext do
  let(:owner){ FactoryGirl.create :user }
  let(:user){ FactoryGirl.create :user }
  let(:project){ project_created!(owner) }

  before{ project_invite!(project, user) }

  subject{ described_class.new(owner, user, project) }

  context "success" do
    it "project not has user" do
      expect{
        subject.perform
      }.to change{ project.reload.has_user?(user) }.to(false)
    end
    it "#update_users_count" do
      expect{
        subject.perform
      }.to change{ project.reload.users.count }.by(-1)
    end
  end

  it "#validates_owner!" do
    project.update_attribute :owner, FactoryGirl.create(:user)
    expect{
      @result = subject.perform
    }.not_to change{ project.reload.users_count }
    expect(@result).to eq false
  end

  it "validates_user!" do
    subject.perform
    expect{
      @result = subject.perform
    }.not_to change{ project.reload.users_count }
    expect(@result).to eq false
  end

  it "#validates_is_not_self!" do
    expect{
      @result = described_class.new(owner, owner, project).perform
    }.not_to change{ project.reload.users_count }
    expect(@result).to eq false
  end
end
