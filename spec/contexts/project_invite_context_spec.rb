require 'rails_helper'

describe ProjectInviteContext do
  let(:me) { FactoryGirl.create :user }
  let(:user) { FactoryGirl.create :user }
  let(:project) { project_created!(me) }

  subject { described_class.new(me, user.email, project).perform }

  context "success" do
    it "project has user" do
      expect {
        subject
      }.to change { project.reload.has_user?(user) }.to(true)
    end
    it "project.users.count" do
      expect {
        subject
      }.to change { project.reload.users.count }.by(1)
    end
  end

  it "validates_me_in_project!" do
    project.project_users.where(user_id: me.id).first.destroy
    expect {
      @result = subject
    }.not_to change { project.reload.users_count }
    expect(@result).to eq false
  end

  it "validates_user_is_not_me!" do
    expect {
      @result = described_class.new(me, me, project).perform
    }.not_to change { project.reload.users_count }
    expect(@result).to eq false
  end

  describe "validates_user_in_project!" do
    before { described_class.new(me, user.email, project).perform }
    subject { described_class.new(me, user.email, project).perform }

    it { expect(subject).to be_falsey }
  end
end
